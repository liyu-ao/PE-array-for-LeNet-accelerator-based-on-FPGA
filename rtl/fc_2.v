`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2018 12:22:35 AM
// Design Name: 
// Module Name: fc_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define FC1_SIZE 500
`define FC2_SIZE 10
`define DATA_SIZE 8

module fc_2(
    clk, rst, fc_2_en, bias_weights_bram_douta, result_bram_douta,
    bias_weights_bram_ena, bias_weights_bram_addra,
    result_bram_ena, result_bram_wea, result_bram_addra, result_bram_dina,
    fc_2_finish,
    out_result
    );
    input clk;
    input rst;
    input fc_2_en;
    input [`DATA_SIZE-1:0] bias_weights_bram_douta;
    input [`DATA_SIZE-1:0] result_bram_douta;
    output reg bias_weights_bram_ena;
    output reg [18:0] bias_weights_bram_addra;
    output reg result_bram_ena;
    output reg result_bram_wea;
    output reg [14:0] result_bram_addra;
    output reg [`DATA_SIZE-1:0] result_bram_dina;
    output reg fc_2_finish;
    output reg [79:0] out_result;
    
    reg [`DATA_SIZE-1:0] matrix1;
    reg [`DATA_SIZE-1:0] matrix2;
    reg matrix1_vld;
    reg matrix2_vld;
    reg [`DATA_SIZE-1:0] bias;
    wire [`DATA_SIZE-1:0] dout;
    wire dout_vld;
    reg [`DATA_SIZE-1:0] result;
    
    u_PE #(
        .Calcycle(`FC1_SIZE)
    ) fc_2_ma(
        .clk_cal(clk),
        .rst_cal(rst),
        .IMap(matrix1),
        .IWeight(matrix2),
        .ImapVld(matrix1_vld),
        .IweightVld(matrix2_vld),
        .bias(bias),
        .OMap(dout),
        .OMapVld(dout_vld)
    );    


    reg [4:0] state;
    
    parameter S_IDLE         = 5'b10000,
              S_CHECK        = 5'b01000,
              S_LOAD_BIAS    = 5'b00100,
              S_MULTI_ADD    = 5'b00010,
              S_STORE_RESULT = 5'b00001;
              
    integer row = 0,
            column = 0,
            circle = 0,
            data_begin = 0;
            
    parameter fc1_result_base = 18400,
              fc2_weights_base = 425500,
              fc2_bias_base = 431070,
              fc2_result_base = 18900;
              
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            state <= S_IDLE;
            bias_weights_bram_ena <= 1'b0;
            result_bram_ena <= 1'b0;
            result_bram_wea <= 1'b0;
        end
        else
        begin
            if(fc_2_en == 1'b1)
            begin
                case(state)
                    S_IDLE:
                    begin
                        row <= 0;
                        column <= 0;
                        matrix1 <= 0;
                        matrix2 <= 0;
                        matrix1_vld <= 1'b0;
                        matrix2_vld <= 1'b0;
                        bias <= 0;
                        result <= 0;
                        //out_result <= 0;
                        fc_2_finish <= 1'b0;
                        state <= S_CHECK;
                    end
                    S_CHECK:
                    begin
                        if(row == `FC2_SIZE)
                        begin
                            bias_weights_bram_ena <= 1'b0;
                            result_bram_ena <= 1'b0;
                            result_bram_wea <= 1'b0;
                            fc_2_finish <= 1'b1;
                            state <= S_IDLE;
                        end
                        else
                        begin
                            circle <= 0;
                            result <= 0;
                            state <= S_LOAD_BIAS;
                        end
                    end
                    S_LOAD_BIAS:
                    begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= fc2_bias_base + row;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                state <= S_MULTI_ADD;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                    end
                    S_MULTI_ADD:
                    begin
                        if(column < `FC1_SIZE)
                        begin
                            if(circle == 0)
                            begin
                                result_bram_ena <= 1'b1;
                                result_bram_addra <= fc1_result_base + column;
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= fc2_weights_base + row * `FC1_SIZE + column;
                                matrix1_vld <= 1'b0;
                                matrix2_vld <= 1'b0;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                matrix1 <= result_bram_douta;
                                matrix1_vld <= 1'b1;
                                matrix2 <= bias_weights_bram_douta;
                                matrix2_vld <= 1'b1;
                                column <= column + 1;
                                circle <= 0;
                            end
                            else
                            begin
                                matrix1_vld <= 1'b0;
                                matrix2_vld <= 1'b0;
                                circle <= circle + 1;
                            end
                        end
                        else
                        begin
                            circle <= 0;
                            result_bram_ena <= 1'b0;
                            bias_weights_bram_ena <= 1'b0;
                            matrix1 <= 0;
                            matrix1_vld <= 1'b0;
                            matrix2 <= 0;
                            matrix2_vld <= 1'b0;
                            result <= dout;
                            state <= S_STORE_RESULT;
                        end
                    end
                    S_STORE_RESULT:
                    begin
                        if(circle == 0)
                        begin
                            result_bram_ena <= 1'b1;
                            result_bram_wea <= 1'b1;
                            result_bram_addra <= fc1_result_base + row;
                            result_bram_dina <= result;
                            circle <= circle + 1;
                        end
                        else if(circle == 3)
                        begin
                            $display("result%d : %b\n", row,result);
                            data_begin = 8 * (10 - row) - 1;
                            out_result[data_begin-:8] <= result;
                            result_bram_ena <= 1'b0;
                            result_bram_wea <= 1'b0;
                            circle <= 0;
                            column <= 0;
                            row <= row + 1;
                            state <= S_CHECK;
                        end
                        else
                        begin
                            circle <= circle + 1;
                        end
                    end
                    default:
                    begin
                        state <= S_IDLE;
                        bias_weights_bram_ena <= 1'b0;
                        result_bram_ena <= 1'b0;
                        result_bram_wea <= 1'b0;
                    end
                endcase
            end
        end
    end
       
endmodule
