`timescale 1ns / 1ps
module block_image(clk,rst_n,h_sync,v_sync,r_vga,g_vga,b_vga);
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

input clk,rst_n;
output h_sync,v_sync;
wire sync_clk;
output wire[3:0] r_vga;
output wire[3:0] g_vga;
output wire[3:0] b_vga;
wire[9:0] h_cnt;
wire[9:0] v_cnt;
reg[17:0] addra;
wire[11:0] dout;
wire visible;

clock_div u(clk,rst_n,sync_clk);
sync s(sync_clk,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);
block_ram ram(sync_clk,rst_n,1'b0,addra,12'b0,dout);

assign {r_vga,g_vga,b_vga} = visible?dout:12'b0;

always@*
begin
    if(~rst_n)
        addra = 18'b0;
    else
        if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 10'd270) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 10'd384) )
            addra = (v_cnt - v_sync_pulse - v_back)*18'd270 + h_cnt - h_sync_pulse - h_back;
        else
            addra = 18'b0;
end
endmodule
