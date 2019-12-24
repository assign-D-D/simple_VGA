`timescale 1ns / 1ps

module sync(sync_clk,rst_n,frame,
h_visible,h_front,h_sync_pulse,h_back,h_total,
v_visible,v_front,v_sync_pulse,v_back,v_total,
h_sync,v_sync,h_cnt,v_cnt,f_cnt,visible);

input [10:0]         h_visible;
input [10:0]         h_front;
input [10:0]         h_sync_pulse;
input [10:0]         h_back;
input [10:0]         h_total;
input [10:0]         v_visible;
input [10:0]         v_sync_pulse;
input [10:0]         v_front;
input [10:0]         v_back;
input [10:0]         v_total;
input sync_clk,rst_n;
input [7:0] frame;
output h_sync,v_sync;
output reg[10:0] h_cnt;
output reg[10:0] v_cnt;
output reg[7:0] f_cnt;
output wire visible;
always@(posedge sync_clk,negedge rst_n)
    begin
        if(~rst_n)
            h_cnt<=11'd0;
        else
        begin
            if(h_cnt<h_total-11'd1)
                h_cnt<=h_cnt+1'd1;
            else
                h_cnt<=11'd0;
        end
    end
assign h_sync = (h_cnt<h_sync_pulse)?1'b0:1'b1;
always@(posedge sync_clk,negedge rst_n)
    begin
        if(~rst_n)
            v_cnt<=11'd0;
        else
        begin
            if(v_cnt==v_total-1'd1&&h_cnt==h_total-1'd1)
                v_cnt<=11'd0;
            else
                if(h_cnt==h_total-1'd1)
                    v_cnt<=v_cnt+1'd1;
                else
                    v_cnt<=v_cnt;
        end
    end
always@(posedge sync_clk,negedge rst_n)
    begin
        if(~rst_n)
            f_cnt <= 8'd0;
        else
        begin
            if(f_cnt==frame-1'd1&&v_cnt==v_total-1'd1&&h_cnt==h_total-1'd1)      
                f_cnt<=8'd0;
            else
                if(v_cnt==v_total-1'd1&&h_cnt==h_total-1'd1)
                    f_cnt<=f_cnt+1'd1;
                else
                    f_cnt<=f_cnt;
        end
    end
assign v_sync = (v_cnt<v_sync_pulse)?1'b0:1'b1;
assign visible = (h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + h_visible) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + v_visible));
endmodule
