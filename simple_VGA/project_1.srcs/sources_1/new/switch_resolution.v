`timescale 1ns / 1ps
module switch_resolution(
rst_n,S,clk,
clk_out,
h_visible,h_front,h_sync_pulse,h_back,h_total,
v_visible,v_front,v_sync_pulse,v_back,v_total,
DIG,Y);

//SIGNAL 640 * 350 @60Hz timing 25MHz               
parameter H_VISIBLE_640_350 = 'd640;
parameter H_FRONT_640_350 = 'd16;
parameter H_SYNC_PULSE_640_350 = 'd96; 
parameter H_BACK_640_350 = 'd48;
parameter H_TOTAL_640_350 = 'd800;

parameter V_VISIBLE_640_350 = 'd350; 
parameter V_FRONT_640_350 = 'd37;
parameter V_SYNC_PULSE_640_350 = 'd2;
parameter V_BACK_640_350 = 'd60;
parameter V_TOTAL_640_350 = 'd449;

//SIGNAL 640 * 400 @60Hz timing 25MHz               
parameter H_VISIBLE_640_400 = 'd640;
parameter H_FRONT_640_400 = 'd16;
parameter H_SYNC_PULSE_640_400 = 'd96; 
parameter H_BACK_640_400 = 'd48;
parameter H_TOTAL_640_400 = 'd800;

parameter V_VISIBLE_640_400 = 'd400; 
parameter V_FRONT_640_400 = 'd12;
parameter V_SYNC_PULSE_640_400 = 'd2;
parameter V_BACK_640_400 = 'd35;
parameter V_TOTAL_640_400 = 'd449;

//SIGNAL 640 * 480 @60Hz timing 25MHz               
parameter H_VISIBLE_640_480 = 'd640;
parameter H_FRONT_640_480 = 'd16;
parameter H_SYNC_PULSE_640_480 = 'd96; 
parameter H_BACK_640_480 = 'd48;
parameter H_TOTAL_640_480 = 'd800;

parameter V_VISIBLE_640_480 = 'd480; 
parameter V_FRONT_640_480 = 'd10;
parameter V_SYNC_PULSE_640_480 = 'd2;
parameter V_BACK_640_480 = 'd33;
parameter V_TOTAL_640_480 = 'd525;

////SIGNAL 800 * 600 @60Hz timing 40MHz
//parameter H_VISIBLE_800_600 = 'd800;
//parameter H_FRONT_800_600 = 'd40;
//parameter H_SYNC_PULSE_800_600 = 'd128; 
//parameter H_BACK_800_600 = 'd88;
//parameter H_TOTAL_800_600 = 'd1056;

//parameter V_VISIBLE_800_600 = 'd600; 
//parameter V_FRONT_800_600 = 'd1;
//parameter V_SYNC_PULSE_800_600 = 'd4;
//parameter V_BACK_800_600 = 'd23;
//parameter V_TOTAL_800_600 = 'd628;


////SIGNAL 1024 * 768 @60Hz timing 65MHz
//parameter H_VISIBLE_1024_768 = 'd1024;
//parameter H_FRONT_1024_768 = 'd24;
//parameter H_SYNC_PULSE_1024_768 = 'd136; 
//parameter H_BACK_1024_768 = 'd160;
//parameter H_TOTAL_1024_768 = 'd1344;

//parameter V_VISIBLE_1024_768 = 'd768; 
//parameter V_FRONT_1024_768 = 'd3;
//parameter V_SYNC_PULSE_1024_768 = 'd6;
//parameter V_BACK_1024_768 = 'd29;
//parameter V_TOTAL_1024_768 = 'd806;


//SIGNAL 1280 * 800 @60 Hz timing 83.46MHz
parameter H_VISIBLE_1280_800 = 'd1280;
parameter H_FRONT_1280_800 = 'd64;
parameter H_SYNC_PULSE_1280_800 = 'd136; 
parameter H_BACK_1280_800 = 'd200;
parameter H_TOTAL_1280_800 = 'd1680;

parameter V_VISIBLE_1280_800 = 'd800; 
parameter V_FRONT_1280_800 = 'd1;
parameter V_SYNC_PULSE_1280_800 = 'd3;
parameter V_BACK_1280_800 = 'd24;
parameter V_TOTAL_1280_800 = 'd828;

/*parameter RESOLUTION_640_480  = 3'b000;
*//*parameter RESOLUTION_800_600  = 3'b001;
parameter RESOLUTION_1024_768 = 3'b010;*//*
parameter RESOLUTION_1280_800 = 3'b011;
parameter RESOLUTION_640_350 = 3'b100;
parameter RESOLUTION_640_400 = 3'b101;
*/
parameter RESOLUTION_640_480  = 2'b00;
parameter RESOLUTION_1280_800 = 2'b01;
parameter RESOLUTION_640_350 = 2'b10;
parameter RESOLUTION_640_400 = 2'b11;
input rst_n;
input clk;
input [1:0]S;
output reg clk_out;
output reg [17:0]h_visible;
output reg [17:0]h_front;
output reg [17:0]h_sync_pulse;
output reg [17:0]h_back;
output reg [17:0]h_total;
output reg [17:0]v_visible;
output reg [17:0]v_sync_pulse;
output reg [17:0]v_front;
output reg [17:0]v_back;
output reg [17:0]v_total;
output [7:0]DIG;
output [7:0]Y;

wire clk_9;
wire clk_25;//SIGNAL 640 * 480 @60Hz timing 25MHz
/*wire clk_40;//SIGNAL 800 * 600 @60Hz timing 40MHz
wire clk_65;//SIGNAL 1024 * 768 @60Hz timing 65MHz*/
wire clk_83;//SIGNAL 1280 * 800 @60Hz timing 83.46MHz
wire clk_100;

various_clk vc(clk_100,clk_83,clk_25,clk_9,rst_n,clk);
display_seg s(S,rst_n,clk_100,DIG,Y);
always@(*)
begin
    case(S)
        RESOLUTION_640_350: 
        begin
            clk_out         = clk_25;
            
            h_visible       = H_VISIBLE_640_350;
            h_front         = H_FRONT_640_350;
            h_sync_pulse    = H_SYNC_PULSE_640_350; 
            h_back          = H_BACK_640_350;
            h_total         = H_TOTAL_640_350;
            
            v_visible       = V_VISIBLE_640_350;
            v_front         = V_FRONT_640_350;
            v_sync_pulse    =  V_SYNC_PULSE_640_350; 
            v_back          = V_BACK_640_350;
            v_total         = V_TOTAL_640_350;
        end
        RESOLUTION_640_400: 
        begin
            clk_out         = clk_25;
            
            h_visible       = H_VISIBLE_640_400;
            h_front         = H_FRONT_640_400;
            h_sync_pulse    = H_SYNC_PULSE_640_400; 
            h_back          = H_BACK_640_400;
            h_total         = H_TOTAL_640_400;
            
            v_visible       = V_VISIBLE_640_400;
            v_front         = V_FRONT_640_400;
            v_sync_pulse    =  V_SYNC_PULSE_640_400; 
            v_back          = V_BACK_640_400;
            v_total         = V_TOTAL_640_400;
        end    
        RESOLUTION_640_480: 
        begin
            clk_out         = clk_25;
            
            h_visible       = H_VISIBLE_640_480;
            h_front         = H_FRONT_640_480;
            h_sync_pulse    = H_SYNC_PULSE_640_480; 
            h_back          = H_BACK_640_480;
            h_total         = H_TOTAL_640_480;
            
            v_visible       = V_VISIBLE_640_480;
            v_front         = V_FRONT_640_480;
            v_sync_pulse    =  V_SYNC_PULSE_640_480; 
            v_back          = V_BACK_640_480;
            v_total         = V_TOTAL_640_480;
        end
//        RESOLUTION_800_600: 
//        begin 
//            clk_out         = clk_40;

//            h_visible       = H_VISIBLE_800_600;
//            h_front         = H_FRONT_800_600;
//            h_sync_pulse    = H_SYNC_PULSE_800_600; 
//            h_back          = H_BACK_800_600;
//            h_total         = H_TOTAL_800_600;
                        
//            v_visible       = V_VISIBLE_800_600;
//            v_front         = V_FRONT_800_600;
//            v_sync_pulse    =  V_SYNC_PULSE_800_600; 
//            v_back          = V_BACK_800_600;
//            v_total         = V_TOTAL_800_600;            
//        end
//        RESOLUTION_1024_768: 
//        begin
//            clk_out         = clk_65;
            
//            h_visible       = H_VISIBLE_1024_768;
//            h_front         = H_FRONT_1024_768;
//            h_sync_pulse    = H_SYNC_PULSE_1024_768; 
//            h_back          = H_BACK_1024_768;
//            h_total         = H_TOTAL_1024_768;
                        
//            v_visible       = V_VISIBLE_1024_768;
//            v_front         = V_FRONT_1024_768;
//            v_sync_pulse    = V_SYNC_PULSE_1024_768; 
//            v_back          = V_BACK_1024_768;
//            v_total         = V_TOTAL_1024_768;            
//        end
        RESOLUTION_1280_800: 
        begin
            clk_out         = clk_83;
            
            h_visible       = H_VISIBLE_1280_800;
            h_front         = H_FRONT_1280_800;
            h_sync_pulse    = H_SYNC_PULSE_1280_800; 
            h_back          = H_BACK_1280_800;
            h_total         = H_TOTAL_1280_800;
                        
            v_visible       = V_VISIBLE_1280_800;
            v_front         = V_FRONT_1280_800;
            v_sync_pulse    =  V_SYNC_PULSE_1280_800; 
            v_back          = V_BACK_1280_800;
            v_total         = V_TOTAL_1280_800;
        end
        default:
        begin
            clk_out         = clk_25;
            
            h_visible       = H_VISIBLE_640_480;
            h_front         = H_FRONT_640_480;
            h_sync_pulse    = H_SYNC_PULSE_640_480; 
            h_back          = H_BACK_640_480;
            h_total         = H_TOTAL_640_480;
            
            v_visible       = V_VISIBLE_640_480;
            v_front         = V_FRONT_640_480;
            v_sync_pulse    = V_SYNC_PULSE_640_480; 
            v_back          = V_BACK_640_480;
            v_total         = V_TOTAL_640_480;
        end
    endcase
end
endmodule
