`timescale 1ns / 1ps
module UART_SDRAM(
    input clk,
    input rst_n,
    output h_sync,
    output v_sync,
    output reg [3:0] r_vga,
    output reg [3:0] g_vga,
    output reg [3:0] b_vga,
    output [7:0] frame,
    output [7:0] O_data,
    input uart_input,
    input uart_start
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

wire [15:0] width,height;
reg [18:0] address;
wire [18:0] write_address;
wire [18:0] read_address;
wire [11:0] write_data;
wire [11:0] read_data;
wire write_enable ;//TODO
wire sync_clk;
wire visible;
wire [2:0] state;
wire [9:0] h_cnt;
wire [9:0] v_cnt;
wire [7:0] f_cnt;

clock_div u(clk,rst_n,sync_clk);

sync #( .h_visible(h_visible), 
.h_front(h_front), 
.h_sync_pulse(h_sync_pulse),
.h_back(h_back),
.h_total(h_total),
.v_visible(v_visible),
.v_front(v_front), 
.v_sync_pulse(v_sync_pulse),
.v_back(v_back),  
.v_total(v_total)) 
ii(sync_clk,rst_n,frame,h_sync,v_sync,h_cnt,v_cnt,f_cnt,visible);

block_ram_add blk_r_a(clk,write_enable,address,write_data,read_data);

uart_rxd uart_accept(
        clk,
        rst_n,
        uart_start,//外部控制 接收书籍
        uart_input,//接串口
        write_data,//写入内存的像素数据
        write_address,//要写入的内存地址
        write_enable,//是否要写的标志
        frame,//帧数
        width,
        height,
        state,//3 是写 4 是读,
        O_data
        );
uart_vga_out #( .h_visible(h_visible), 
        .h_front(h_front), 
        .h_sync_pulse(h_sync_pulse),
        .h_back(h_back),
        .h_total(h_total),
        .v_visible(v_visible),
        .v_front(v_front), 
        .v_sync_pulse(v_sync_pulse),
        .v_back(v_back),  
        .v_total(v_total)) uart_read(
        sync_clk,
        rst_n,
        h_cnt,
        v_cnt,
        f_cnt,
        visible,
        frame,
        width,
        height,
        write_address,//现在可访问的最高位
        read_address//要读取的地址
        );
// assign {r_vga,g_vga,b_vga} = visible?dout:12'b0;
always@(*)
    begin
        case (state)
        3'd0,3'd1,3'd2:
            address = 19'b0;
        3'd3://write
            address = write_address;
        3'd4://read
            address = read_address;
        default: ;
        endcase
    end

always@(*)
if(read_address==0)
    {r_vga,g_vga,b_vga} = 12'b111100000000;
else
    {r_vga,g_vga,b_vga} = read_data;

endmodule // 
