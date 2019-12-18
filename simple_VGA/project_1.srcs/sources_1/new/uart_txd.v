`timescale 1ns/1ps

module uart_rxd
(
    input    I_clk         , 
    input    I_rst_n       , 
    input    I_rx_start    , 
    input    I_rs232_rxd   ,
    output reg [11:0] rgb_data ,
    output reg [28:0] write_address,
    output reg write_enable,
	output reg [7:0] frame,
    output reg [15:0] width,
    output reg [15:0] height,
    output reg [3:0] state
);
wire I_bps_rx_clk;

parameter   C_BPS9600     = 10416    ,    
            C_BPS19200    = 5208     ,    
            C_BPS38400    = 2604     ,   
            C_BPS57600    = 1736     ,    
            C_BPS115200   = 868      ;    
    
parameter   C_BPS_SELECT      = C_BPS115200  ; 
reg [13:0]  R_bps_rx_cnt   ;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_bps_rx_cnt <= 14'd0 ;
    else //if(I_bps_rx_clk_en == 1'b1)
        begin
            if(R_bps_rx_cnt == C_BPS_SELECT)
                R_bps_rx_cnt <= 14'd0 ;
            else
                R_bps_rx_cnt <= R_bps_rx_cnt + 1'b1 ;                 
        end    
    /*else
        R_bps_rx_cnt <= 14'd0 ;*/        
end

assign I_bps_rx_clk = (R_bps_rx_cnt == C_BPS_SELECT >> 1'b1) ? 1'b1 : 1'b0 ;

reg         R_rs232_rx_reg0 ;
reg         R_rs232_rx_reg1 ;
reg         R_rs232_rx_reg2 ;
reg         R_rs232_rx_reg3 ;

reg         R_receiving     ;

reg [3:0]   R_state         ;
reg [7:0]   R_para_data_reg ;

wire        W_rs232_rxd_neg ;

reg [1:0] accept_count;
reg [3:0] r_next;


always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        begin
            R_rs232_rx_reg0 <= 1'b0 ;
            R_rs232_rx_reg1 <= 1'b0 ;
            R_rs232_rx_reg2 <= 1'b0 ;
            R_rs232_rx_reg3 <= 1'b0 ;
        end 
    else
        begin  
            R_rs232_rx_reg0 <= I_rs232_rxd      ;
            R_rs232_rx_reg1 <= R_rs232_rx_reg0  ; 
            R_rs232_rx_reg2 <= R_rs232_rx_reg1  ; 
            R_rs232_rx_reg3 <= R_rs232_rx_reg2  ; 
        end   
end

assign W_rs232_rxd_neg    =    (~R_rs232_rx_reg2) & R_rs232_rx_reg3 ;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
    begin
        R_receiving <= 1'b0 ;
        write_address <= 29'd0;
        write_enable <= 1'b0;
        state <= 3'd0;
    end
    else if(I_rx_start && W_rs232_rxd_neg)
        R_receiving <= 1'b1 ;          
end

always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        begin
            R_state         <= 4'd0 ;
            R_para_data_reg <= 8'd0 ;
            //O_bps_rx_clk_en <= 1'b0 ;
        end 
    else if(R_receiving)
        begin
            //O_bps_rx_clk_en <= 1'b1 ;
            if(I_bps_rx_clk)
                begin
                    case(R_state)
                        4'd0  : 
                            begin
                                R_para_data_reg <= 8'd0             ;
                                R_state         <= R_state + 1'b1   ;
                                write_enable    <=  1'b0;
                            end
                        4'd1  : 
                            begin
                                R_para_data_reg[0]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end
                        4'd2  :
                            begin
                                R_para_data_reg[1]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end
                        4'd3  :
                            begin
                                R_para_data_reg[2]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end 
                        4'd4  : 
                            begin
                                R_para_data_reg[3]  <= I_rs232_rxd      ; 
                                R_state             <= R_state + 1'b1   ;
                            end 
                        4'd5  :
                            begin
                                R_para_data_reg[4]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end
                        4'd6  : 
                            begin
                                R_para_data_reg[5]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end
                        4'd7  :
                            begin
                                R_para_data_reg[6]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end
                        4'd8  : 
                            begin
                                R_para_data_reg[7]  <= I_rs232_rxd      ;
                                R_state             <= R_state + 1'b1   ;
                            end 
                        4'd9  : 
                            begin
                                case(state)
                                3'd0: {frame,state} <= {R_para_data_reg,3'd1};
                                3'd1: 
                                    if(accept_count==2'd0)
                                        {width[7:0],accept_count} <= {R_para_data_reg,2'd1};
                                    else
                                        {width[15:8],accept_count,state} <= {R_para_data_reg,2'd0,3'd2};
                                3'd2: 
                                    if(accept_count==2'd0)
                                        {height[7:0],accept_count} <= {R_para_data_reg,2'd1};
                                    else
                                        {height[15:8],accept_count,state} <= {R_para_data_reg,2'd0,3'd3};
                                3'd3:
                                    case(accept_count)
                                    2'd0:{rgb_data[11:4],accept_count} <= {R_para_data_reg,2'd1};
                                    2'd1:
                                        begin
                                            {rgb_data[3:0],r_next} <= R_para_data_reg;
                                            write_enable <= 1'b1;
                                            write_address <= write_address + 29'd1;
                                            accept_count <= 2'd2;
                                        end
                                    2'd2:
                                        begin
                                            rgb_data <= {r_next,R_para_data_reg};
                                            write_enable <= 1'b1;
                                            write_address <= write_address + 29'd1;
                                            accept_count <= 2'd0;
                                        end
                                    default:
                                        accept_count <= 3'd0;
                                R_state <= 4'd0;
                            end 
                            
                        default:R_state <= 4'd0;                                                      
                    endcase 
                end
        end
    else
        begin
            R_state   <= 4'd0 ;
            R_para_data_reg   <= 8'd0 ;
            //O_bps_rx_clk_en     <= 1'b0 ;
        end        
end

endmodule