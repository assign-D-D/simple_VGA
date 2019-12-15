`timescale 1ns / 1ps

module colorlump(clk,rst_n,h_sync,v_sync,r_vga,g_vga,b_vga);
parameter h_visible = 10'd640;
parameter h_front = 10'd16;
parameter h_sync_pulse = 10'd96; 
parameter h_back = 10'd48;
parameter h_total = 10'd800;

input clk,rst_n;
output h_sync,v_sync;
wire sync_clk;
output reg[3:0] r_vga;
output reg[3:0] g_vga;
output reg[3:0] b_vga;
wire [9:0] h_cnt;
wire [9:0] v_cnt;
wire visible;
clock_div u(clk,rst_n,sync_clk);
sync s(sync_clk,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);
//reg[11:0] rgb_vga;
//assign {r_vga,g_vga,b_vga} = rgb_vga;
always @(*)
begin 
    if(visible)
        begin
            if(h_cnt<(h_sync_pulse+h_back+10'd80))
            begin
                r_vga=4'b0000;
                g_vga=4'b0000;
                b_vga=4'b0000;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd160))
            begin
                r_vga=4'b1111;
                g_vga=4'b1111;
                b_vga=4'b1111;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd240))
            begin
                r_vga=4'b1111;
                g_vga=4'b0000;
                b_vga=4'b0000;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd320))
            begin
                r_vga=4'b0000;
                g_vga=4'b1111;
                b_vga=4'b0000;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd400))
            begin
                r_vga=4'b0000;
                g_vga=4'b0000;
                b_vga=4'b1111;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd480))
            begin
                r_vga=4'b0000;
                g_vga=4'b1111;
                b_vga=4'b1111;
            end
            else if(h_cnt<(h_sync_pulse+h_back+10'd560))
            begin
                r_vga=4'b1111;
                g_vga=4'b0000;
                b_vga=4'b1111;
            end
            else 
            begin
                r_vga=4'b1111;
                g_vga=4'b1111;
                b_vga=4'b0000;
            end
        end
    else
    begin
        r_vga=4'b0000;
        g_vga=4'b0000;
        b_vga=4'b0000;
    end
end
endmodule
