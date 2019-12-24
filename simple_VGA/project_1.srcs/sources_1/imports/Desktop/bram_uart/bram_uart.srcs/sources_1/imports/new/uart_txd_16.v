`timescale 1ns/1ps

module uart_rxd_16
(
    input               clk_9          , 
    input               rst_n        , 
    input               uart_start   , 
    input               uart_input   ,
    output reg [11:0]   rgb_data    ,
    output reg [18:0]   write_address,
    output reg          write_enable,
	output reg [7:0]    frame      ,
    output reg [15:0]   width       ,
    output reg [15:0]   height      ,
    output reg [2:0]    state       ,
    output reg [7:0]    O_data
);
wire uart_receive_clk;
//parameter      BPS9600_CNT        = 10416    ,//9600bps    
//                 BPS19200_CNT       = 5208     ,//19200bps    
//                 BPS38400_CNT       = 2604     ,//38400bps   
//                 BPS57600_CNT       = 1736     ,//57600bps    
//                 BPS115200_CNT      = 868      ;//115200bps    

//parameter   BPS_SELECT         = BPS115200_CNT  ;//select the 115200bps
parameter BPS_SELECT  = 14'd80; 
reg [13:0]  receive_cnt   ;//计数

always @(posedge clk_9, negedge rst_n)
begin
    if(~rst_n)
        receive_cnt <= 14'd0;
    else
        begin
        if(receive_cnt == BPS_SELECT - 1'b1)
            receive_cnt <= 14'd0;
        else
            receive_cnt <= receive_cnt + 1'b1;
        end
end

assign uart_receive_clk = (receive_cnt == BPS_SELECT >> 1'b1) ? 1'b1 : 1'b0 ;

reg         rx_reg0 ;
reg         rx_reg1 ;
reg         rx_reg2 ;
reg         rx_reg3 ;

reg         R_receiving     ;

reg [3:0]   R_state         ;
reg [7:0]   R_para_data_reg ;
reg         receive_done;
wire        uart_receive_neg;//下降沿的标志

reg accept_count;
reg [7:0] rg_data;//临时储存的rg信号


always @(posedge clk_9 or negedge rst_n)
begin
    if(~rst_n)
        begin
            rx_reg0 <= 1'b0 ;
            rx_reg1 <= 1'b0 ;
            rx_reg2 <= 1'b0 ;
            rx_reg3 <= 1'b0 ;
        end 
    else
        begin  
            rx_reg0 <= uart_input      ;
            rx_reg1 <= rx_reg0  ; 
            rx_reg2 <= rx_reg1  ; 
            rx_reg3 <= rx_reg2  ;//消除亚稳态 
        end   
end

assign uart_receive_neg    =    (~rx_reg2) & rx_reg3 ;//监听下降沿

always @(posedge clk_9 or negedge rst_n)
begin
    if(~rst_n)
        R_receiving <= 1'b0 ;
    else if(receive_done)
        R_receiving <= 1'b0;
    else if(uart_start && uart_receive_neg)
        R_receiving <= 1'b1 ;          
end

always @(posedge clk_9 or negedge rst_n)
begin
    if(~rst_n)
        begin
            R_state         <= 4'd0 ;
            R_para_data_reg <= 8'd0 ;
            receive_done    <= 1'b0;
            write_address   <= 19'd0;
            write_enable    <= 1'b0;
            state           <= 3'd0;
            frame           <= 8'd0;
            width           <= 16'd0;
            height          <= 16'd0;
            rgb_data        <= 12'd0;
            O_data          <= 8'd0;
            accept_count    <= 1'd0;
            //O_bps_rx_clk_en <= 1'b0 ;
        end
    else if(R_receiving)
        begin
            //O_bps_rx_clk_en <= 1'b1 ;
            if(uart_receive_clk)
                begin
                    case(R_state)
                        4'd0  : 
                            begin
                                R_para_data_reg <= 8'd0             ;
                                R_state         <= R_state + 1'b1   ;
                                receive_done    <= 1'b0;
                            end
                        4'd1  : 
                            begin
                                R_para_data_reg[0]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end
                        4'd2  :
                            begin
                                R_para_data_reg[1]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end
                        4'd3  :
                            begin
                                R_para_data_reg[2]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end 
                        4'd4  : 
                            begin
                                R_para_data_reg[3]  <= rx_reg3      ; 
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end 
                        4'd5  :
                            begin
                                R_para_data_reg[4]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end
                        4'd6  : 
                            begin
                                R_para_data_reg[5]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end
                        4'd7  :
                            begin
                                R_para_data_reg[6]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end
                        4'd8  : 
                            begin
                                R_para_data_reg[7]  <= rx_reg3      ;
                                R_state             <= R_state + 1'b1   ;
                                receive_done        <= 1'b0;
                            end 
                        4'd9  : 
                            begin
                                case(state)
                                3'd0: 
                                begin
                                    frame               <= R_para_data_reg;
                                    state               <= 3'd1;
                                end
                                3'd1: 
                                    if(~accept_count)
                                    begin
                                        width[15:8]     <= R_para_data_reg;
                                        accept_count    <= 1'd1;
                                    end
                                    else
                                    begin
                                        width[7:0]      <= R_para_data_reg;
                                        accept_count    <= 1'd0;
                                        state <= 3'd2;
                                    end
                                3'd2: 
                                    if(~accept_count)
                                    begin
                                        height[15:8]    <= R_para_data_reg;
                                        accept_count    <= 1'd1;
                                    end
                                    else
                                    begin
                                        height[7:0]     <= R_para_data_reg;
                                        accept_count    <= 1'd0;
                                        state           <= 3'd3;
                                    end
                                default:
                                begin
                                    if(~accept_count)
                                    begin
                                        rg_data         <= R_para_data_reg;
                                        accept_count    <= 1'b1;
                                    end
                                    else
                                    begin
                                        rgb_data        <= {rg_data,R_para_data_reg[7:4]};
                                        accept_count    <= 1'b0;
                                        write_enable    <= 1'b1;
                                        write_address   <= write_address + 1'd1;
                                    end
                                    state               <= 3'd3;
                                end
                                endcase
                                O_data                  <= R_para_data_reg;
                                receive_done            <= 1'b1;
                                R_state                 <= 4'd0;
                            end 
                            
                        default:
                        begin
                            R_state                     <= 4'd0;    
                            write_enable                <=1'b0;
                        end                                                  
                    endcase 
                end
            else
            begin
                write_enable        <=1'b0;
            end
        end
    else
        begin
            R_state                 <= 4'd0 ;
            R_para_data_reg         <= 8'd0 ;
            receive_done            <= 1'b0;
            write_enable            <= 1'b0;
            //O_bps_rx_clk_en     <= 1'b0 ;
        end        
end

endmodule