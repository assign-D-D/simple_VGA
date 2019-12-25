`timescale 1ns / 1ps
module block_image_rom(
S_resolution,S_fitmode,
clk_100,clk_83,clk_25,rst_n,
h_sync,v_sync,
r_vga,g_vga,b_vga,
DIG,Y);

wire [17:0]         h_visible;
wire [17:0]         h_front;
wire [17:0]         h_sync_pulse;
wire [17:0]         h_back;
wire [17:0]         h_total;
wire [17:0]         v_visible;
wire [17:0]         v_sync_pulse;
wire [17:0]         v_front;
wire [17:0]         v_back;
wire [17:0]         v_total;

parameter normal        = 3'b000;
parameter tile          = 3'b001;
parameter stretch       = 3'b010;
parameter center        = 3'b011;
parameter fit           = 3'b100;
parameter upsidedown    = 3'b101;

input                       clk_100,clk_83,clk_25,rst_n;
input [2:0]                 S_fitmode;
input [2:0]                 S_resolution;
output                      h_sync,v_sync;
wire                        sync_clk;
output wire[3:0]            r_vga;
output wire[3:0]            g_vga;
output wire[3:0]            b_vga;
output [7:0]                DIG;
output [7:0]                Y;
wire[17:0]                  h_cnt;
wire[17:0]                  v_cnt;

wire[11:0]                  dout;
wire                        visible;
reg[18:0]                  addra;
switch_resolution sr(rst_n,S_resolution,clk_100,clk_83,clk_25,sync_clk,
                        h_visible,h_front,h_sync_pulse,h_back,h_total,
                        v_visible,v_front,v_sync_pulse,v_back,v_total,
                        DIG,Y);

sync_pre s(h_visible,h_front,h_sync_pulse,h_back,h_total,
            v_visible,v_front,v_sync_pulse,v_back,v_total,
            sync_clk,rst_n,h_sync,v_sync,h_cnt,v_cnt,visible);
rom rom1(sync_clk,addra,dout);

assign {r_vga,g_vga,b_vga} = visible ? dout : 12'b0;

always @(*)
begin
    if(~rst_n)
        addra = 19'b0;
    else
        case(S_fitmode)
            normal:
                if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd270) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd384) )
                    addra = (v_cnt - v_sync_pulse - v_back) * 18'd270 + h_cnt - h_sync_pulse - h_back;//(normal version)
                else
                    addra = 19'b0;
            tile:
                if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd270) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd384) )
                    addra = (v_cnt - v_sync_pulse - v_back)*18'd270 + h_cnt - h_sync_pulse - h_back;
                else if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd540) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd384) )
                    addra = (v_cnt - v_sync_pulse - v_back)*18'd270 + h_cnt - h_sync_pulse - h_back - 18'd270;
                else if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd810) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd384) )
                    addra = (v_cnt - v_sync_pulse - v_back)*18'd270 + h_cnt - h_sync_pulse - h_back - 18'd540;
                else if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd270) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd768) )
                    addra = (v_cnt - v_sync_pulse - v_back - 18'd384)*18'd270 + h_cnt - h_sync_pulse - h_back;
                else if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd540) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd768) )
                    addra = (v_cnt - v_sync_pulse - v_back - 18'd384)*18'd270 + h_cnt - h_sync_pulse - h_back - 18'd270;
                else if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + 18'd810) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + 18'd768) )
                    addra = (v_cnt - v_sync_pulse - v_back - 18'd384)*18'd270 + h_cnt - h_sync_pulse - h_back - 18'd540;
                else
                    addra = 19'b0;
            stretch:
                addra = ((v_cnt - v_sync_pulse - v_back) *18'd384 / v_visible )*18'd270 + ((h_cnt - h_sync_pulse - h_back) * 18'd270 / h_visible);
            center:
                if(h_cnt >= (h_sync_pulse + h_back + h_visible/2 - 18'd135) && h_cnt < (h_sync_pulse + h_back + h_visible/2 + 18'd135) 
                        && v_cnt >= (v_sync_pulse + v_back + v_visible/2 - 18'd192) && v_cnt < (v_sync_pulse + v_back + v_visible/2 + 18'd192) )
                    addra = (v_cnt - (v_visible - 18'd384)/2 - v_sync_pulse - v_back)*18'd270 + h_cnt - (h_visible-11'd270)/2 - h_sync_pulse - h_back;
                else
                    addra = 19'b0;
            fit:
                if(h_cnt >= h_sync_pulse + h_back + (h_visible/2-(v_visible*18'd135/18'd384)) && h_cnt < h_sync_pulse + h_back + (h_visible/2+(v_visible*18'd135/18'd384)))
                    addra =   (v_cnt - v_sync_pulse - v_back) * 18'd384 / v_visible * 18'd270//270 must be multiplied at last cuz..2019.12.24 2:34
                            + (h_cnt - h_sync_pulse - h_back - (h_visible / 2 - (v_visible * 18'd45 / 18'd128) ) ) * 18'd384 / v_visible + 1;
                else
                    addra = 19'b0;
            upsidedown:
                if(h_cnt >= (h_sync_pulse + h_back + h_visible/2 - 18'd135) && h_cnt < (h_sync_pulse + h_back + h_visible/2 + 18'd135) 
                                    && v_cnt >= (v_sync_pulse + v_back + v_visible/2 - 18'd192) && v_cnt < (v_sync_pulse + v_back + v_visible/2 + 18'd192) )
                    addra = 18'd270 * 18'd384 - ((v_cnt - (v_visible-18'd384)/2 - v_sync_pulse - v_back)*18'd270 + h_cnt - (h_visible-18'd270)/2 - h_sync_pulse - h_back);
                else
                    addra = 19'b0;
            default:
                addra = 19'b0;
        endcase
end
endmodule
