`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2018 08:32:31 PM
// Design Name: 
// Module Name: conv_2
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

`define CONV1_DEEP 20
`define CONV2_DEEP 50
`define CONV2_SIZE 5
`define CONV2_INPUT 12
`define CONV2_OUTPUT 8
`define DATA_SIZE 8

module conv_2(
    clk, rst, conv_2_en, bias_weights_bram_douta, result_bram_douta,
    bias_weights_bram_ena, bias_weights_bram_addra,
    result_bram_ena, result_bram_wea, result_bram_addra, result_bram_dina,
    conv_2_finish
    );
    input clk;
    input rst;
    input conv_2_en;
    input [`DATA_SIZE-1:0] bias_weights_bram_douta;
    input [`DATA_SIZE-1:0] result_bram_douta;
    output reg bias_weights_bram_ena;
    output reg [18:0] bias_weights_bram_addra;
    output reg result_bram_ena;
    output reg result_bram_wea;
    output reg [14:0] result_bram_addra;
    output reg [`DATA_SIZE-1:0] result_bram_dina;
    output reg conv_2_finish;
    
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

    defparam array_conv_2.column_0.u_PE_0.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_0.u_PE_1.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_0.u_PE_2.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_0.u_PE_3.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_1.u_PE_0.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_1.u_PE_1.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_1.u_PE_2.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_1.u_PE_3.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_2.u_PE_0.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_2.u_PE_1.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_2.u_PE_2.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_2.u_PE_3.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_3.u_PE_0.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_3.u_PE_1.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_3.u_PE_2.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_3.u_PE_3.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_4.u_PE_0.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_4.u_PE_1.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_4.u_PE_2.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    defparam array_conv_2.column_4.u_PE_3.Calcycle = `CONV2_SIZE*`CONV2_SIZE*`CONV1_DEEP;
    u_PE_array array_conv_2(
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
    //integer count_channel = 0;
    integer PE_array_row_and_column = 0;
    
    parameter pool1_result_base = 11520,
              conv2_weights_base = 500,
              conv2_bias_base = 430520,
              conv2_result_base = 14400;
              
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
            if(conv_2_en == 1'b1)
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
                        IWeight1 <= 0;
                        IweightVld1 <= 0;
                        IWeight2 <= 0;
                        IweightVld2 <= 0;
                        IWeight3 <= 0;
                        IweightVld3 <= 0;
                        IWeight4 <= 0;
                        IweightVld4 <= 0;
                        bias0 <= 0;
                        bias1 <= 0;
                        bias2 <= 0;
                        bias3 <= 0;
                        bias4 <= 0;
                        conv_2_finish <= 1'b0;
                        state <= S_CHECK;
                    end
                    S_CHECK:
                    begin
                        if(filter == `CONV2_DEEP)
                        begin
                            bias_weights_bram_ena <= 1'b0;
                            result_bram_ena <= 1'b0;
                            result_bram_wea <= 1'b0;
                            conv_2_finish <= 1'b1;
                            state <= S_IDLE;
                        end
                        else
                        begin
                            circle <= 0;
                            count <= 0;
                            channel <= 0;
                            PE_array_row <= 0;
                            PE_array_column <= 0;
                            PE_array_row_and_column <= 0;
                            //count_channel <= 0;
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
                                bias_weights_bram_addra <= conv2_bias_base + filter + 0;
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
                                bias_weights_bram_addra <= conv2_bias_base + filter + 1;
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
                                bias_weights_bram_addra <= conv2_bias_base + filter + 2;
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
                                bias_weights_bram_addra <= conv2_bias_base + filter + 3;
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
                                bias_weights_bram_addra <= conv2_bias_base + filter + 4;
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
                        if(channel < `CONV1_DEEP)
                        begin
                            if(count < `CONV2_SIZE * `CONV2_SIZE)
                            begin
                                if(PE_array_row_and_column == 0)
                                begin
                                    if(circle == 0)
                                    begin
                                        bias_weights_bram_ena <= 1'b1;
                                        bias_weights_bram_addra <= conv2_weights_base + (filter + 0)*`CONV1_DEEP*`CONV2_SIZE*`CONV2_SIZE + channel*`CONV2_SIZE*`CONV2_SIZE + count;
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
                                        bias_weights_bram_addra <= conv2_weights_base + (filter + 1)*`CONV1_DEEP*`CONV2_SIZE*`CONV2_SIZE + channel*`CONV2_SIZE*`CONV2_SIZE + count;
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
                                        bias_weights_bram_addra <= conv2_weights_base + (filter + 2)*`CONV1_DEEP*`CONV2_SIZE*`CONV2_SIZE + channel*`CONV2_SIZE*`CONV2_SIZE + count;
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
                                        bias_weights_bram_addra <= conv2_weights_base + (filter + 3)*`CONV1_DEEP*`CONV2_SIZE*`CONV2_SIZE + channel*`CONV2_SIZE*`CONV2_SIZE + count;
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
                                        bias_weights_bram_addra <= conv2_weights_base + (filter + 4)*`CONV1_DEEP*`CONV2_SIZE*`CONV2_SIZE + channel*`CONV2_SIZE*`CONV2_SIZE + count;
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
                                        result_bram_ena <= 1'b1;
                                        result_bram_addra <= pool1_result_base + channel * `CONV2_INPUT * `CONV2_INPUT + (row + count / `CONV2_SIZE) * `CONV2_INPUT + (column + 0) + count % `CONV2_SIZE;
                                        ImapVld0 <= 1'b0;
                                        circle <= circle + 1;
                                    end
                                    else if(circle == 3)
                                    begin
                                        IMap0 <= result_bram_douta;
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
                                        result_bram_ena <= 1'b1;
                                        result_bram_addra <= pool1_result_base + channel * `CONV2_INPUT * `CONV2_INPUT + (row + count / `CONV2_SIZE) * `CONV2_INPUT + (column + 1) + count % `CONV2_SIZE;
                                        ImapVld0 <= 1'b0;
                                        ImapVld1 <= 1'b0;
                                        circle <= circle + 1;
                                    end
                                    else if(circle == 3)
                                    begin
                                        IMap1 <= result_bram_douta;
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
                                        result_bram_ena <= 1'b1;
                                        result_bram_addra <= pool1_result_base + channel * `CONV2_INPUT * `CONV2_INPUT + (row + count / `CONV2_SIZE) * `CONV2_INPUT + (column + 2) + count % `CONV2_SIZE;
                                        ImapVld1 <= 1'b0;
                                        ImapVld2 <= 1'b0;
                                        circle <= circle + 1;
                                    end
                                    else if(circle == 3)
                                    begin
                                        IMap2 <= result_bram_douta;
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
                                        result_bram_ena <= 1'b1;
                                        result_bram_addra <= pool1_result_base + channel * `CONV2_INPUT * `CONV2_INPUT + (row + count / `CONV2_SIZE) * `CONV2_INPUT + (column + 3) + count % `CONV2_SIZE;
                                        ImapVld2 <= 1'b0;
                                        ImapVld3 <= 1'b0;
                                        circle <= circle + 1;
                                    end
                                    else if(circle == 3)
                                    begin
                                        IMap3 <= result_bram_douta;
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
                                count <= 0;
                                ImapVld3 <= 0;
                                channel <= channel + 1;
                            end
                        end
                        else 
                        begin
                            circle <= 0;
                            PE_array_row_and_column <= 0;
                            count <= 0;
                            result_bram_ena <= 1'b0;
                            bias_weights_bram_ena <= 1'b0;
                            IMap0 <= 0;
                            ImapVld0 <= 0;
                            IMap1 <= 0;
                            ImapVld1 <= 0;
                            IMap2 <= 0;
                            ImapVld2 <= 0;
                            IMap3 <= 0;
                            ImapVld3 <= 0;
                            channel <= 0;
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
                                    result_bram_addra <= conv2_result_base + (filter + PE_array_column) * `CONV2_OUTPUT * `CONV2_OUTPUT + row * `CONV2_OUTPUT + column + 0;
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
                                    result_bram_addra <= conv2_result_base + (filter + PE_array_column) * `CONV2_OUTPUT * `CONV2_OUTPUT + row * `CONV2_OUTPUT + column + 1;
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
                                    result_bram_addra <= conv2_result_base + (filter + PE_array_column) * `CONV2_OUTPUT * `CONV2_OUTPUT + row * `CONV2_OUTPUT + column + 2;
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
                                    result_bram_addra <= conv2_result_base + (filter + PE_array_column) * `CONV2_OUTPUT * `CONV2_OUTPUT + row * `CONV2_OUTPUT + column + 3;
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

                                if(column == `CONV2_OUTPUT - 4)
                                    begin
                                        if(row == `CONV2_OUTPUT - 1)
                                        begin
                                            filter <= filter + 5;
                                        end
                                        row <= (row + 1) % `CONV2_OUTPUT;
                                    end
                                column <= (column + 4) % `CONV2_OUTPUT;

                                state <= S_CHECK;
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
