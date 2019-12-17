`timescale 1ns / 1ps
module UART_SDRAM(
    inout [15:0]    ddr3_dq,
    inout [1:0]     ddr3_dqs_n,
    inout [1:0]     ddr3_dqs_p,
    // Outputs
    output [14:0]   ddr3_addr,
    output [2:0]    ddr3_ba,
    output          ddr3_ras_n,
    output          ddr3_cas_n,
    output          ddr3_we_n,
    output          ddr3_reset_n,
    output [0:0]    ddr3_ck_p,
    output [0:0]    ddr3_ck_n,
    output [0:0]    ddr3_cke,
    output [0:0]    ddr3_cs_n,
    output [1:0]    ddr3_dm,
    output [0:0]    ddr3_odt,
    
    input clk,
    input rst_n,
    output h_sync,
    output v_sync,
    output [3:0] r_vga,
    output [3:0] g_vga,
    output [3:0] b_vga,
    input uart,
    output init_calib_complete
);
parameter h_visible = 10'd640;
parameter h_front = 10'd16;
parameter h_sync_pulse = 10'd96; 
parameter h_back = 10'd48;
parameter h_total = 10'd800;

parameter v_visible = 10'd480; 
parameter v_front = 10'd10;
parameter v_sync_pulse = 10'd2;
parameter v_back = 10'd33;
parameter v_total = 10'd525;

reg [3:0] frame;
reg [11:0] width,height;
reg [28:0] address;
reg [28:0] write_address;
reg [28:0] read_address; 
reg [2:0] command;
reg ram_enable;
reg [127:0] write_data;
wire [127:0] read_data;
wire read_data_end;
wire read_data_valid;
wire ram_ready;
wire ram_write_rdy;
wire ram_sr_active;
wire ram_ref_ack;
wire ram_zq_ack;
wire ui_clk;
wire ui_clk_sync_rst;
wire init_calib_complete;
wire [11:0] device_temp;
wire writable = ;\\TODO
wire readable = ;\\TODO
reg [?:0] state;\\TODO
reg [?:0] accept_data;\\TODO
reg has_writen;
clock_div u(clk,rst_n,sync_clk);
sync #(.h_visible(h_visible)
        .h_front(h_front)
        .h_sync_pulse(h_sync_pulse)
        .h_back(h_back)
        .h_total(h_total)

        .v_visible(v_visible)
        .v_front(v_front)
        .v_sync_pulse(v_sync_pulse)
        .v_back(v_back)
        .v_total(v_total)) 
        s(sync_clk,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);

sdram r(ddr3_dq,
        ddr3_dqs_n,
        ddr3_dqs_p,
        ddr3_addr,
        ddr3_ba,
        ddr3_ras_n,
        ddr3_cas_n,
        ddr3_we_n,
        ddr3_reset_n,
        ddr3_ck_p,
        ddr3_ck_n,
        ddr3_cke,
        ddr3_cs_n,
        ddr3_dm,
        ddr3_odt,
        clk,
        clk,
        address,
        command,
        ram_enable,
        write_data,
        writable,
        16'b0,//掩码直接给0
        writable,
        read_data,
        read_data_end,
        read_data_valid,
        ram_ready,
        ram_write_rdy,
        1'b0,
        1'b0,
        1'b0,
        ram_sr_active,
        ram_ref_ack,
        ram_zq_ack,
        ui_clk,
        ui_clk_sync_rst,
        init_calib_complete,
        device_temp,
        rst_n
        )
// assign {r_vga,g_vga,b_vga} = visible?dout:12'b0;
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        address <= 29'b0;
        ram_enable <= 1'b0;
        writable <= 1'b0;
        command <= 3'b010;//invalid
        state <= 0;
    end
    else
    begin
        case (state)
        0,1,2,3:
        begin
            address <= 29'b0;
            ram_enable <= 1'b0;
            writable <= 1'b0;
            command <= 3'b000;//invalid
            write_data <= 128'b0;
        end 
        4://write
        begin
            if(accept_finished)
            begin
                state <= 5;
                command <= 3'b001;
                address <= 28'b0;
                ram_enable <= 1'b0;
            end
            else if(writable & ram_ready & init_calib_complete & ram_write_rdy)
            begin
                command <= 3'b0;
                ram_enable <= 1'b1;
                address <= write_address;
            end
            else
            begin
                ram_enable <= 1'b0;
            end
        end
        5://read
        begin
            if(readable & init_calib_complete & ram_ready)
            begin
                command <= 3'b001;
                address <= read_address;
                ram_enable <= 1'b1;
            end
        end
            default: 
        endcase
    end
end
endmodule // 