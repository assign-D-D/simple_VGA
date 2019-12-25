`timescale 1ns / 1ps

module sync_pre(
h_visible,h_front,h_sync_pulse,h_back,h_total,
v_visible,v_front,v_sync_pulse,v_back,v_total,
sync_clk,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);

input [17:0]         h_visible;
input [17:0]         h_front;
input [17:0]         h_sync_pulse;
input [17:0]         h_back;
input [17:0]         h_total;
input [17:0]         v_visible;
input [17:0]         v_sync_pulse;
input [17:0]         v_front;
input [17:0]         v_back;
input [17:0]         v_total;
input sync_clk,rst_n;
output h_sync,v_sync;
output reg[17:0] h_cnt;
output reg[17:0] v_cnt;
output wire visible;
always@(posedge sync_clk,negedge rst_n)
    begin
        if(~rst_n)
            h_cnt<=18'd0;
        else
        begin
            if(h_cnt<h_total-1'd1)
                h_cnt<=h_cnt+1'd1;
            else
                h_cnt<=18'd0;
        end
    end
assign h_sync = (h_cnt<h_sync_pulse)?1'b0:1'b1;
always@(posedge sync_clk,negedge rst_n)
    begin
        if(~rst_n)
            v_cnt<=18'd0;
        else
        begin
            if(v_cnt==v_total-1'd1&&h_cnt==h_total-1'd1)
                v_cnt<=18'd0;
            else
                if(h_cnt==h_total-1'd1)
                    v_cnt<=v_cnt+1'd1;
                else
                    ;
        end
    end
assign v_sync = (v_cnt<v_sync_pulse)?1'b0:1'b1;
assign visible = (h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + h_visible) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + v_visible));
endmodule
