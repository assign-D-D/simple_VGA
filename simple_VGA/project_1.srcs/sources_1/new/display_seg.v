`timescale 1ns / 1ps

module display_seg(S,rst_n,clk,DIG,Y);
input               rst_n   ;//reset
input               clk     ;//100MHz clock
input  [1:0]        S       ;//select the resolution
output [7:0]        DIG     ;//select the tube
output [7:0]        Y       ;//to light up

reg                 clk_seg ;//500Hz clock
reg    [31:0]       cnt     ;
reg    [2:0]        scan_cnt;
reg    [6:0]        Y_r     ;
reg    [7:0]        DIG_r   ;

assign Y     = { 1'b1 ,(~Y_r[6:0])};//dot never light
assign DIG   = ~DIG_r;
parameter period = 200000;//500Hz
always @(posedge clk or negedge rst_n)//frequency division clk->clk_seg
begin
    if (~rst_n) 
    begin
        cnt             <= 0;
        clk_seg         <= 0;
    end
    else 
    begin
        if (cnt         ==  (period >> 1) - 1)
        begin
            clk_seg     <= ~clk_seg;
            cnt         <= 0;
        end
        else
            cnt         <= cnt + 1;
    end
end

always @(posedge clk_seg or negedge rst_n)//change scan_cnt based on clk_seg
begin
    if (~rst_n)
        scan_cnt        <= 0;
    else begin
        scan_cnt        <= scan_cnt+1;
        if(scan_cnt == 3'd7)  
            scan_cnt    <= 0;   
    end
end

always @(scan_cnt)//select tube
begin 
    case (scan_cnt)
        3'b000 : DIG_r = 8'b0000_0001;
        3'b001 : DIG_r = 8'b0000_0010;
        3'b010 : DIG_r = 8'b0000_0100;
        3'b011 : DIG_r = 8'b0000_1000;
        3'b100 : DIG_r = 8'b0001_0000;
        3'b101 : DIG_r = 8'b0010_0000;
        3'b110 : DIG_r = 8'b0100_0000;
        3'b111 : DIG_r = 8'b1000_0000;
        default :DIG_r = 8'b0000_0000;
    endcase
end

always @(scan_cnt)//decoder to display on 7-seg tube
if(~rst_n)
    Y_r =  7'b000_0000;
else
    begin
        case(scan_cnt)
            0: 
                Y_r = 7'b011_1111;
                /*case(S)
                    3'b010:
                        Y_r = 7'b111_1111;//8
                    default:
                        Y_r = 7'b011_1111;//0
                endcase*/
            1:
                case(S)
                    /*3'b000:
                        Y_r = 7'b111_1111;
                    3'b001:
                        Y_r = 7'b011_1111;
                    3'b010:
                        Y_r = 7'b111_1101;
                    3'b011:
                        Y_r = 7'b011_1111;
                    3'b100:
                        Y_r = 7'b110_1101;
                    3'b101:
                        Y_r = 7'b011_1111;*/
                    2'b00:
                        Y_r = 7'b111_1111;
                    2'b10:
                        Y_r = 7'b110_1101;    
                    default:
                        Y_r = 7'b011_1111;
                endcase
            2:
                case(S)
                    /*3'b000:
                        Y_r = 7'b110_0110;
                    3'b001:
                        Y_r = 7'b111_1101;
                    3'b010:
                        Y_r = 7'b010_0111;
                    3'b011:
                        Y_r = 7'b111_1111;
                    3'b100:
                        Y_r = 7'b100_1111;
                    3'b101:
                        Y_r = 7'b110_0110;*/
                    2'b01:
                        Y_r = 7'b111_1111;
                    2'b10:
                        Y_r = 7'b100_1111;
                    default:
                        Y_r = 7'b110_0110;
               endcase
            3: Y_r = 7'b000_0000;
            4:
                Y_r = 7'b011_1111;
                /*case(S)                            
                    3'b000:
                        Y_r = 7'b011_1111;
                    3'b001:
                        Y_r = 7'b011_1111;
                    3'b010:
                        Y_r = 7'b110_0110;
                    3'b011:
                        Y_r = 7'b011_1111;
                    3'b100:
                        Y_r = 7'b011_1111;
                    3'b101:
                        Y_r = 7'b011_1111;
                    default:
                        Y_r = 7'b011_1111;
                endcase*/
            5: 
                case(S)
                    /*3'b000:
                        Y_r = 7'b110_0110;
                    3'b001:
                        Y_r = 7'b011_1111;
                    3'b010:
                        Y_r = 7'b101_1011;
                    3'b011:
                        Y_r = 7'b111_1111;
                    3'b100:
                        Y_r = 7'b110_0110;
                    3'b101:
                        Y_r = 7'b110_0110;*/
                    2'b01:
                        Y_r = 7'b111_1111;         
                    default:
                        Y_r = 7'b110_0110;
                endcase
            6:
                case(S)
                    /*3'b000:
                        Y_r = 7'b111_1101;
                    3'b001:
                        Y_r = 7'b111_1111;
                    3'b010:
                        Y_r = 7'b011_1111;
                    3'b011:
                        Y_r = 7'b101_1011;
                    3'b100:
                        Y_r = 7'b111_1101;
                    3'b101:
                        Y_r = 7'b111_1101;*/
                    2'b01:
                        Y_r = 7'b101_1011;    
                    default:
                        Y_r = 7'b111_1101;
                endcase
            7: 
                case(S)
                    /*3'b010:
                        Y_r = 7'b000_0110;
                    3'b011:
                        Y_r = 7'b000_0110;*/
                    2'b01:
                        Y_r = 7'b000_0110;    
                    default:
                        Y_r = 7'b000_0000;
                endcase
            default: Y_r = 7'b000_0000;
        endcase
    end
endmodule
