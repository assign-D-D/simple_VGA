`timescale 1ns/1ps
module clock_div(input clk,rst_n,output reg clk_out);
parameter period  =4;
reg [3:0] cnt;
always @(posedge clk,negedge rst_n)
begin
    if (~rst_n)begin
        cnt<=0;
        clk_out<=0;
    end
    else 
		if (cnt==(period>>1)-1)begin
            clk_out<=~clk_out;
			cnt<=0;
        end
        else begin
            cnt<=cnt+1;
		end
end
endmodule