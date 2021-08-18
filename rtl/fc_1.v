`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2017 08:00:24 AM
// Design Name: 
// Module Name: fc_1
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
`define CONV2_DEEP 50
`define POOL2_OUTPUT 4
`define DATA_SIZE 8

module fc_1(
    clk, rst, fc_1_en, bias_weights_bram_douta, result_bram_douta,
    bias_weights_bram_ena, bias_weights_bram_addra,
    result_bram_ena, result_bram_wea, result_bram_addra, result_bram_dina,
    fc_1_finish
    );
    input clk;
    input rst;
    input fc_1_en;
    input [`DATA_SIZE-1:0] bias_weights_bram_douta;
    input [`DATA_SIZE-1:0] result_bram_douta;
    output reg bias_weights_bram_ena;
    output reg [18:0] bias_weights_bram_addra;
    output reg result_bram_ena;
    output reg result_bram_wea;
    output reg [14:0] result_bram_addra;
    output reg [`DATA_SIZE-1:0] result_bram_dina;
    output reg fc_1_finish;
    
    reg [`DATA_SIZE-1:0] matrix1;
    reg [`DATA_SIZE-1:0] matrix2;
    reg matrix1_vld;
    reg matrix2_vld;
    reg [`DATA_SIZE-1:0] bias;
    wire [`DATA_SIZE-1:0] dout;
    wire dout_vld;
    reg [`DATA_SIZE-1:0] result;
    
    u_PE #(
        .Calcycle(`POOL2_OUTPUT*`POOL2_OUTPUT*`CONV2_DEEP)
    ) fc_1_ma(
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
            circle = 0;
            
    parameter pool2_result_base = 17600,
              fc1_weights_base = 25500,
              fc1_bias_base = 430570,
              fc1_result_base = 18400;
              

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
            if(fc_1_en == 1'b1)
            begin
                case(state)
                    S_IDLE:
                    begin
                        row <= 0;
                        column <= 0;
                        matrix1 <= 0;
                        matrix2 <= 0;
                        matrix1_vld <= 0;
                        matrix2_vld <= 0;
                        bias <= 0;
                        result <= 0;
                        fc_1_finish <= 1'b0;
                        state <= S_CHECK;
                    end
                    S_CHECK:
                    begin
                        if(row == `FC1_SIZE)
                        begin
                            bias_weights_bram_ena <= 1'b0;
                            result_bram_ena <= 1'b0;
                            result_bram_wea <= 1'b0;
                            fc_1_finish <= 1'b1;
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
                                bias_weights_bram_addra <= fc1_bias_base + row;
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
                        if(column < `POOL2_OUTPUT*`POOL2_OUTPUT*`CONV2_DEEP)
                        begin
                            if(circle == 0)
                            begin
                                result_bram_ena <= 1'b1;
                                result_bram_addra <= pool2_result_base + column;
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= fc1_weights_base + row * `CONV2_DEEP * `POOL2_OUTPUT * `POOL2_OUTPUT + column;
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
