`timescale 1ns / 1ps
module vga_move(clk_25,rst_n,color_controller,h_sync,v_sync,r_vga,g_vga,b_vga);
input clk_25;
input rst_n;
input [11:0] color_controller;
output h_sync;
output v_sync;
output reg [3:0]r_vga,g_vga,b_vga;

wire visible;
wire[17:0] h_cnt,v_cnt;
parameter H_VISIBLE = 'd640;
parameter H_FRONT = 'd16;
parameter H_SYNC_PULSE = 'd96; 
parameter H_BACK = 'd48;
parameter H_TOTAL = 'd800;

parameter V_VISIBLE = 'd480; 
parameter V_FRONT = 'd10;
parameter V_SYNC_PULSE = 'd2;
parameter V_BACK = 'd33;
parameter V_TOTAL = 'd525;
parameter WIDTH = 32; 
parameter HEIGHT = 24;

sync_pre sy(H_VISIBLE,H_FRONT,H_SYNC_PULSE,H_BACK,H_TOTAL,
            V_VISIBLE,V_FRONT,V_SYNC_PULSE,V_BACK,V_TOTAL,clk_25,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);
 
reg [9:0] v_max = 10'd59; 
reg [9:0] v_min = 10'd35; 
reg [9:0] h_min = 10'd144; 
reg [9:0] h_max = 10'd176;

reg [1:0] orientation = 2'b11;

always @ (posedge v_sync or negedge rst_n)
begin
if(~rst_n) 
    begin 
        v_max = 10'd59;
        v_min = 10'd35;
        h_min = 10'd144;
        h_max = 10'd176;
        orientation = 2'b11; 
    end 
else 
begin 
     case(orientation)
        2'b00: 
            begin
                if (v_min == V_SYNC_PULSE + V_BACK && h_min > H_SYNC_PULSE + H_BACK )
                    orientation = 2'b01;
                else if (v_min > V_SYNC_PULSE + V_BACK  && h_min == H_SYNC_PULSE + H_BACK )
                    orientation = 2'b10;
                else if (v_min == V_SYNC_PULSE + V_BACK && h_min == H_SYNC_PULSE + H_BACK )
                    orientation = 2'b11;
                else ;
            end
        2'b01:  
            begin
            if (v_max == V_SYNC_PULSE + V_BACK+V_VISIBLE && h_min > H_SYNC_PULSE + H_BACK )
                orientation = 2'b00;
            else if (v_max < V_SYNC_PULSE + V_BACK+V_VISIBLE && h_min == H_SYNC_PULSE + H_BACK )
                orientation = 2'b11;
            else if (v_max == V_SYNC_PULSE + V_BACK+V_VISIBLE && h_min == H_SYNC_PULSE + H_BACK )
                orientation = 2'b10;
            else ;
            end
        2'b10: 
            begin
            if (v_min  == V_SYNC_PULSE + V_BACK&& h_max < H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b11;
               else if (v_min > V_SYNC_PULSE + V_BACK && h_max == H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b00;
               else if (v_min == V_SYNC_PULSE + V_BACK && h_max == H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b01;
               else ;
             end
         2'b11: 
         begin
             if (v_max == V_SYNC_PULSE + V_BACK+V_VISIBLE && h_max < H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b10;
             else if (v_max < V_SYNC_PULSE + V_BACK+V_VISIBLE && h_max == H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b01;
             else if (v_max == V_SYNC_PULSE + V_BACK+V_VISIBLE && h_max == H_SYNC_PULSE + H_BACK+H_VISIBLE )
                    orientation = 2'b00;
             else ;
             end
         default: orientation = 2'b11;
     endcase
      v_max <= v_max + ( orientation[0]? 1 : -1 );
      v_min <= v_min + ( orientation[0]? 1 : -1 );
      h_min <= h_min + ( orientation[1]? 1 : -1 );
      h_max <= h_max + ( orientation[1]? 1 : -1 ); 
end
end
 
            
always @(posedge clk_25 or negedge rst_n) 
begin
    if(~rst_n)
         {r_vga,g_vga,b_vga} <= 12'b0;        
    else 
    begin
        if (h_cnt >= H_SYNC_PULSE + H_BACK  
            && h_cnt < H_SYNC_PULSE + H_BACK + H_VISIBLE 
            && v_cnt >= V_SYNC_PULSE + V_BACK 
            && v_cnt < V_SYNC_PULSE + V_BACK + V_VISIBLE)
            begin
                if(h_cnt >= h_min 
                    && h_cnt < h_max 
                    && v_cnt >= v_min 
                    && v_cnt < v_max)
                    
                   {r_vga,g_vga,b_vga} <= color_controller;  
                else        
                   {r_vga,g_vga,b_vga} <= 12'b0;
            end
        else 
        begin
           {r_vga,g_vga,b_vga} <= 12'b0;
        end
    end
end


endmodule
