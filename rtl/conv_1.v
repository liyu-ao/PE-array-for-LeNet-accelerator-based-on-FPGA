`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2017 05:44:43 PM
// Design Name: 
// Module Name: conv_1
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

`define INPUT_NODE 784
`define IMAGE_SIZE 28
`define NUM_CHANNELS 1
`define CONV1_DEEP 20
`define CONV1_SIZE 5
`define CONV1_OUTPUT 24
`define DATA_SIZE 8

module conv_1(
    clk, rst, conv_1_en, bias_weights_bram_douta, input_bram_douta, graph,
    bias_weights_bram_ena, bias_weights_bram_addra,
    result_bram_ena, result_bram_wea, result_bram_addra, result_bram_dina,
    input_bram_ena, input_bram_addra,
    conv_1_finish
    );
    input clk;
    input rst;
    input conv_1_en;
    input [`DATA_SIZE-1:0] bias_weights_bram_douta;
    input [`DATA_SIZE-1:0] input_bram_douta;
    input [4:0] graph;
    output reg bias_weights_bram_ena;
    output reg [18:0] bias_weights_bram_addra;
    output reg result_bram_ena;
    output reg result_bram_wea;
    output reg [14:0] result_bram_addra;
    output reg [`DATA_SIZE-1:0] result_bram_dina;
    output reg input_bram_ena;
    output reg [12:0] input_bram_addra;
    output reg conv_1_finish;
    
    
    integer filter = 0,
            channel = 0,
            row = 0,
            column = 0,
            count = 0;
    
    reg [`DATA_SIZE-1:0] IMap0,IMap1,IMap2,IMap3;
    reg [`DATA_SIZE-1:0] IWeight0,IWeight1,IWeight2,IWeight3,IWeight4;
    reg ImapVld0,ImapVld1,ImapVld2,ImapVld3;
    reg IweightVld0,IweightVld1,IweightVld2,IweightVld3,IweightVld4;
    reg [`DATA_SIZE-1:0] bias0,bias1,bias2,bias3,bias4;
    wire [`DATA_SIZE-1:0] dout0,dout1,dout2,dout3;
    reg dinVld;
    // reg [`DATA_SIZE-1:0] result0,result1,result2,result3;

    u_PE_array array_conv_1(
        .clk_cal    (clk        ),
        .rst_cal    (rst        ),
        .IWeight0   (IWeight0   ),
        .IWeight1   (IWeight1   ),
        .IWeight2   (IWeight2   ),
        .IWeight3   (IWeight3   ),
        .IWeight4   (IWeight4   ),
        .IweightVld0(IweightVld0),
        .IweightVld1(IweightVld1),
        .IweightVld2(IweightVld2),
        .IweightVld3(IweightVld3),
        .IweightVld4(IweightVld4),
        .IMap0      (IMap0      ),
        .IMap1      (IMap1      ),
        .IMap2      (IMap2      ),
        .IMap3      (IMap3      ),
        .ImapVld0   (ImapVld0   ),
        .ImapVld1   (ImapVld1   ),
        .ImapVld2   (ImapVld2   ),
        .ImapVld3   (ImapVld3   ),
        .dout0      (dout0  	),
        .dout1      (dout1  	),
        .dout2      (dout2  	),
        .dout3      (dout3  	),
        .bias0	    (bias0  	),
        .bias1	    (bias1	    ),
        .bias2      (bias2      ),
        .bias3	    (bias3  	),
        .bias4	    (bias4  	),
	    .dinVld     (dinVld     )
    );
    reg [4:0] state;

    parameter S_IDLE         = 5'b10000,
              S_CHECK        = 5'b01000,
              S_LOAD_BIAS    = 5'b00100,
              S_CONVOLUTE    = 5'b00010,
              S_STORE_RESULT = 5'b00001;    
    
    integer circle = 0;
    integer PE_array_row = 0;
    integer PE_array_column = 0;
    integer PE_array_row_and_column = 0;
    
    parameter conv1_weights_base = 0,
              conv1_bias_base = 430500,
              conv1_result_base = 0;
    
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            state <= S_IDLE;
            bias_weights_bram_ena <= 1'b0;
            result_bram_ena <= 1'b0;
            result_bram_wea <= 1'b0;
            input_bram_ena <= 1'b0;
        end
        else
        begin
            if(conv_1_en == 1'b1)
            begin
                case(state)
                    S_IDLE:
                    begin
                        filter <= 0;
                        channel <= 0;
                        row <= 0;
                        column <= 0;
                        IMap0 <= 0;
                        ImapVld0 <= 0;
                        IMap1 <= 0;
                        ImapVld1 <= 0;
                        IMap2 <= 0;
                        ImapVld2 <= 0;
                        IMap3 <= 0;
                        ImapVld3 <= 0;
                        IWeight0 <= 0;
                        IweightVld0 <= 0;
                        bias0 <= 0;
                        conv_1_finish <= 1'b0;
                        state <= S_CHECK;
                    end
                    S_CHECK:
                    begin
                        if(filter == `CONV1_DEEP)
                        begin
                            bias_weights_bram_ena <= 1'b0;
                            result_bram_ena <= 1'b0;
                            result_bram_wea <= 1'b0;
                            input_bram_ena <= 1'b0;
                            conv_1_finish <= 1'b1;
                            state <= S_IDLE;
                        end
                        else
                        begin
                            circle <= 0;
                            PE_array_row <= 0;
                            PE_array_column <= 0;
                            PE_array_row_and_column <= 0;
                            count <= 0;
                            state <= S_LOAD_BIAS;
                        end
                    end
                    S_LOAD_BIAS:
                    begin
                        if(PE_array_column == 0)
                        begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= conv1_bias_base + filter + 0;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias0 <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                PE_array_column <= PE_array_column + 1;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                        end

                        if(PE_array_column == 1)
                        begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= conv1_bias_base + filter + 1;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias1 <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                PE_array_column <= PE_array_column + 1;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                        end

                        if(PE_array_column == 2)
                        begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= conv1_bias_base + filter + 2;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias2 <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                PE_array_column <= PE_array_column + 1;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                        end

                        if(PE_array_column == 3)
                        begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= conv1_bias_base + filter + 3;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias3 <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                PE_array_column <= PE_array_column + 1;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                        end

                        if(PE_array_column == 4)
                        begin
                            if(circle == 0)
                            begin
                                bias_weights_bram_ena <= 1'b1;
                                bias_weights_bram_addra <= conv1_bias_base + filter + 4;
                                circle <= circle + 1;
                            end
                            else if(circle == 3)
                            begin
                                bias4 <= bias_weights_bram_douta;
                                circle <= 0;
                                bias_weights_bram_ena <= 1'b0;
                                PE_array_column <= 0;
                                state <= S_CONVOLUTE;
                            end
                            else
                            begin
                                circle <= circle + 1;
                            end
                        end
                        
                    end
                    S_CONVOLUTE:
                    begin
                        if(count < `CONV1_SIZE * `CONV1_SIZE)
                        begin
                            if(PE_array_row_and_column == 0)
                            begin
                                if(circle == 0)
                                begin
                                    bias_weights_bram_ena <= 1'b1;
                                    bias_weights_bram_addra <= conv1_weights_base + (filter + 0)*`CONV1_SIZE*`CONV1_SIZE + count;
                                    ImapVld3 <= 1'b0;
                                    IweightVld0 = 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IWeight0 <= bias_weights_bram_douta;
                                    IweightVld0 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row_and_column == 1)
                            begin
                                if(circle == 0)
                                begin
                                    bias_weights_bram_ena <= 1'b1;
                                    bias_weights_bram_addra <= conv1_weights_base + (filter + 1)*`CONV1_SIZE*`CONV1_SIZE + count;
                                    IweightVld1 = 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IWeight1 <= bias_weights_bram_douta;
                                    IweightVld1 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row_and_column == 2)
                            begin
                                if(circle == 0)
                                begin
                                    bias_weights_bram_ena <= 1'b1;
                                    bias_weights_bram_addra <= conv1_weights_base + (filter + 2)*`CONV1_SIZE*`CONV1_SIZE + count;
                                    IweightVld2 = 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IWeight2 <= bias_weights_bram_douta;
                                    IweightVld2 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row_and_column == 3)
                            begin
                                if(circle == 0)
                                begin
                                    bias_weights_bram_ena <= 1'b1;
                                    bias_weights_bram_addra <= conv1_weights_base + (filter + 3)*`CONV1_SIZE*`CONV1_SIZE + count;
                                    IweightVld3 = 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IWeight3 <= bias_weights_bram_douta;
                                    IweightVld3 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row_and_column == 4)
                            begin
                                if(circle == 0)
                                begin
                                    bias_weights_bram_ena <= 1'b1;
                                    bias_weights_bram_addra <= conv1_weights_base + (filter + 4)*`CONV1_SIZE*`CONV1_SIZE + count;
                                    IweightVld4 = 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IWeight4 <= bias_weights_bram_douta;
                                    IweightVld4 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row_and_column == 5)
                            begin
                                if(circle == 0)
                                begin
                                    input_bram_ena <= 1'b1;
                                    input_bram_addra <= graph * `INPUT_NODE + (row + count / `CONV1_SIZE) * `IMAGE_SIZE + column + 0 + count % `CONV1_SIZE;
                                    ImapVld0 <= 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IMap0 <= input_bram_douta;
                                    ImapVld0 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            else if(PE_array_row_and_column == 6)
                            begin
                                if(circle == 0)
                                begin
                                    input_bram_ena <= 1'b1;
                                    input_bram_addra <= graph * `INPUT_NODE + (row + count / `CONV1_SIZE) * `IMAGE_SIZE + column + 1 + count % `CONV1_SIZE;
                                    ImapVld0 <= 1'b0;
                                    ImapVld1 <= 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IMap1 <= input_bram_douta;
                                    ImapVld1 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            else if(PE_array_row_and_column == 7)
                            begin
                                if(circle == 0)
                                begin
                                    input_bram_ena <= 1'b1;
                                    input_bram_addra <= graph * `INPUT_NODE + (row + count / `CONV1_SIZE) * `IMAGE_SIZE + column + 2 + count % `CONV1_SIZE;
                                    ImapVld1 <= 1'b0;
                                    ImapVld2 <= 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IMap2 <= input_bram_douta;
                                    ImapVld2 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= PE_array_row_and_column + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            else if(PE_array_row_and_column == 8)
                            begin
                                if(circle == 0)
                                begin
                                    input_bram_ena <= 1'b1;
                                    input_bram_addra <= graph * `INPUT_NODE + (row + count / `CONV1_SIZE) * `IMAGE_SIZE + column + 3 + count % `CONV1_SIZE;
                                    ImapVld2 <= 1'b0;
                                    ImapVld3 <= 1'b0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    IMap3 <= input_bram_douta;
                                    ImapVld3 <= 1'b1;
                                    circle <= 0;
                                    PE_array_row_and_column <= 0;
                                    count <= count + 1;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end
                        end
                        else
                            begin
                                circle <= 0;
                                PE_array_row_and_column <= 0;
                                count <= 0;
                                input_bram_ena <= 1'b0;
                                bias_weights_bram_ena <= 1'b0;
                                IMap0 <= 0;
                                ImapVld0 <= 0;
                                IMap1 <= 0;
                                ImapVld1 <= 0;
                                IMap2 <= 0;
                                ImapVld2 <= 0;
                                IMap3 <= 0;
                                ImapVld3 <= 0;
                                state <= S_STORE_RESULT;
                            end
                    end
                    S_STORE_RESULT:
                    begin
                        if(PE_array_column < 5)
                        begin
                            if(PE_array_row == 0)
                            begin
                                if(circle == 0)
                                begin
                                    result_bram_ena <= 1'b1;
                                    result_bram_wea <= 1'b1;
                                    result_bram_addra <= conv1_result_base + (filter + PE_array_column) * `CONV1_OUTPUT * `CONV1_OUTPUT + row * `CONV1_OUTPUT + column + 0;
                                    result_bram_dina <= dout0;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    result_bram_ena <= 1'b0;
                                    result_bram_wea <= 1'b0;
                                    PE_array_row <= PE_array_row + 1;
                                    circle <= 0;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row == 1)
                            begin
                                if(circle == 0)
                                begin
                                    result_bram_ena <= 1'b1;
                                    result_bram_wea <= 1'b1;
                                    result_bram_addra <= conv1_result_base + (filter + PE_array_column) * `CONV1_OUTPUT * `CONV1_OUTPUT + row * `CONV1_OUTPUT + column + 1;
                                    result_bram_dina <= dout1;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    result_bram_ena <= 1'b0;
                                    result_bram_wea <= 1'b0;
                                    PE_array_row <= PE_array_row + 1;
                                    circle <= 0;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row == 2)
                            begin
                                if(circle == 0)
                                begin
                                    result_bram_ena <= 1'b1;
                                    result_bram_wea <= 1'b1;
                                    result_bram_addra <= conv1_result_base + (filter + PE_array_column) * `CONV1_OUTPUT * `CONV1_OUTPUT + row * `CONV1_OUTPUT + column + 2;
                                    result_bram_dina <= dout2;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    result_bram_ena <= 1'b0;
                                    result_bram_wea <= 1'b0;
                                    PE_array_row <= PE_array_row + 1;
                                    circle <= 0;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end

                            if(PE_array_row == 3)
                            begin
                                if(circle == 0)
                                begin
                                    result_bram_ena <= 1'b1;
                                    result_bram_wea <= 1'b1;
                                    result_bram_addra <= conv1_result_base + (filter + PE_array_column) * `CONV1_OUTPUT * `CONV1_OUTPUT + row * `CONV1_OUTPUT + column + 3;
                                    result_bram_dina <= dout3;
                                    circle <= circle + 1;
                                end
                                else if(circle == 3)
                                begin
                                    dinVld <= 1;
                                    circle <= circle + 1;
                                end
                                else if(circle == 4)
                                begin
                                    dinVld <= 0;
                                    result_bram_ena <= 1'b0;
                                    result_bram_wea <= 1'b0;
                                    PE_array_row <= 0;
                                    PE_array_column <= PE_array_column + 1;
                                    circle <= 0;
                                end
                                else
                                begin
                                    circle <= circle + 1;
                                end
                            end                           
                        end
                        else 
                            begin
                                dinVld <= 0;
                                PE_array_column <= 0;
                                PE_array_row <= 0;

                                if(column == `CONV1_OUTPUT - 4)
                                    begin
                                        if(row == `CONV1_OUTPUT - 1)
                                        begin
                                            if(channel == `NUM_CHANNELS - 1)
                                            begin
                                                filter <= filter + 5;
                                            end
                                            channel <= (channel + 1) % `NUM_CHANNELS;
                                        end
                                        row <= (row + 1) % `CONV1_OUTPUT;
                                    end
                                column <= (column + 4) % `CONV1_OUTPUT;

                                state <= S_CHECK;
                            end
                    end
                    default
                    begin
                        state <= S_IDLE;
                        bias_weights_bram_ena <= 1'b0;
                        result_bram_ena <= 1'b0;
                        result_bram_wea <= 1'b0;
                        input_bram_ena <= 1'b0;
                    end
                endcase
            end
        end
    end
    
endmodule
