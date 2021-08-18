`timescale 1ns/1ps
`define halfword_width 16
`define DATA_SIZE 8

module u_PE_array(
    input         				            clk_cal, 
	input 				                  	rst_cal,
    input                                   dinVld,
	input       [`DATA_SIZE-1:0] 	        IWeight0,IWeight1,IWeight2,IWeight3,IWeight4,IMap0,IMap1,IMap2,IMap3,
	input         			                IweightVld0,IweightVld1,IweightVld2,IweightVld3,IweightVld4,ImapVld0,ImapVld1,ImapVld2,ImapVld3,
    input       [`DATA_SIZE-1:0]            bias0,bias1,bias2,bias3,bias4,
	output 	    [`DATA_SIZE-1:0] 	        dout0,dout1,dout2,dout3
    );

    wire        [`DATA_SIZE-1:0]    dout00,dout10,dout20,dout30,dout01,dout11,dout21,dout31,dout02,dout12,dout22,dout32,dout03,dout13,dout23,dout33,dout04,dout14,dout24,dout34,dout05,dout15,dout25,dout35;
    wire        [`DATA_SIZE-1:0]    IMap00,IMap10,IMap20,IMap30,IMap01,IMap11,IMap21,IMap31,IMap02,IMap12,IMap22,IMap32,IMap03,IMap13,IMap23,IMap33,IMap04,IMap14,IMap24,IMap34,IMap05,IMap15,IMap25,IMap35;
    wire                            ImapVld00,ImapVld10,ImapVld20,ImapVld30,ImapVld01,ImapVld11,ImapVld21,ImapVld31,ImapVld02,ImapVld12,ImapVld22,ImapVld32,ImapVld03,ImapVld13,ImapVld23,ImapVld33,ImapVld04,ImapVld14,ImapVld24,ImapVld34,ImapVld05,ImapVld15,ImapVld25,ImapVld35;

    assign dout0    = dout00;
    assign dout1    = dout10;
    assign dout2    = dout20;
    assign dout3    = dout30;
    assign IMap00    = IMap0;
    assign IMap10    = IMap1;
    assign IMap20    = IMap2;
    assign IMap30    = IMap3;
    assign ImapVld00 = ImapVld0;
    assign ImapVld10 = ImapVld1;
    assign ImapVld20 = ImapVld2;
    assign ImapVld30 = ImapVld3;

u_PE_column column_0(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap_0     (IMap00     ),
        .IMap_1     (IMap10     ),
        .IMap_2     (IMap20     ),
        .IMap_3     (IMap30     ),
        .ImapVld_0  (ImapVld00  ),
        .ImapVld_1  (ImapVld10  ),
        .ImapVld_2  (ImapVld20  ),
        .ImapVld_3  (ImapVld30  ),
        .IWeight    (IWeight0   ),
        .IweightVld (IweightVld0),
        .bias       (bias0      ),
        .dout_0	    (dout00  	),
        .dout_1	    (dout10  	),
        .dout_2	    (dout20  	),
        .dout_3	    (dout30  	),
        .din_0      (dout01   	),
        .din_1      (dout11   	),
        .din_2      (dout21   	),
        .din_3      (dout31   	),
        .dinVld     (dinVld     ),
        .NMap_0     (IMap01     ),
        .NMap_1     (IMap11     ),
        .NMap_2     (IMap21     ),
        .NMap_3     (IMap31     ),
        .NMapVld_0  (ImapVld01  ),
        .NMapVld_1  (ImapVld11  ),
        .NMapVld_2  (ImapVld21  ),
        .NMapVld_3  (ImapVld31  )
    );

u_PE_column column_1(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap_0     (IMap01     ),
        .IMap_1     (IMap11     ),
        .IMap_2     (IMap21     ),
        .IMap_3     (IMap31     ),
        .ImapVld_0  (ImapVld01  ),
        .ImapVld_1  (ImapVld11  ),
        .ImapVld_2  (ImapVld21  ),
        .ImapVld_3  (ImapVld31  ),
        .IWeight    (IWeight1   ),
        .IweightVld (IweightVld1),
        .bias       (bias1      ),
        .dout_0	    (dout01  	),
        .dout_1	    (dout11  	),
        .dout_2	    (dout21  	),
        .dout_3	    (dout31  	),
        .din_0      (dout02   	),
        .din_1      (dout12   	),
        .din_2      (dout22   	),
        .din_3      (dout32   	),
        .dinVld     (dinVld     ),
        .NMap_0     (IMap02     ),
        .NMap_1     (IMap12     ),
        .NMap_2     (IMap22     ),
        .NMap_3     (IMap32     ),
        .NMapVld_0  (ImapVld02  ),
        .NMapVld_1  (ImapVld12  ),
        .NMapVld_2  (ImapVld22  ),
        .NMapVld_3  (ImapVld32  )
    );

u_PE_column column_2(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap_0     (IMap02     ),
        .IMap_1     (IMap12     ),
        .IMap_2     (IMap22     ),
        .IMap_3     (IMap32     ),
        .ImapVld_0  (ImapVld02  ),
        .ImapVld_1  (ImapVld12  ),
        .ImapVld_2  (ImapVld22  ),
        .ImapVld_3  (ImapVld32  ),
        .IWeight    (IWeight2   ),
        .IweightVld (IweightVld2),
        .bias       (bias2      ),
        .dout_0	    (dout02  	),
        .dout_1	    (dout12  	),
        .dout_2	    (dout22  	),
        .dout_3	    (dout32  	),
        .din_0      (dout03   	),
        .din_1      (dout13   	),
        .din_2      (dout23   	),
        .din_3      (dout33   	),
        .dinVld     (dinVld     ),
        .NMap_0     (IMap03     ),
        .NMap_1     (IMap13     ),
        .NMap_2     (IMap23     ),
        .NMap_3     (IMap33     ),
        .NMapVld_0  (ImapVld03  ),
        .NMapVld_1  (ImapVld13  ),
        .NMapVld_2  (ImapVld23  ),
        .NMapVld_3  (ImapVld33  )
    );

u_PE_column column_3(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap_0     (IMap03     ),
        .IMap_1     (IMap13     ),
        .IMap_2     (IMap23     ),
        .IMap_3     (IMap33     ),
        .ImapVld_0  (ImapVld03  ),
        .ImapVld_1  (ImapVld13  ),
        .ImapVld_2  (ImapVld23  ),
        .ImapVld_3  (ImapVld33  ),
        .IWeight    (IWeight3   ),
        .IweightVld (IweightVld3),
        .bias       (bias3      ),
        .dout_0	    (dout03  	),
        .dout_1	    (dout13  	),
        .dout_2	    (dout23  	),
        .dout_3	    (dout33  	),
        .din_0      (dout04   	),
        .din_1      (dout14   	),
        .din_2      (dout24   	),
        .din_3      (dout34   	),
        .dinVld     (dinVld     ),
        .NMap_0     (IMap04     ),
        .NMap_1     (IMap14     ),
        .NMap_2     (IMap24     ),
        .NMap_3     (IMap34     ),
        .NMapVld_0  (ImapVld04  ),
        .NMapVld_1  (ImapVld14  ),
        .NMapVld_2  (ImapVld24  ),
        .NMapVld_3  (ImapVld34  )
    );

u_PE_column column_4(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap_0     (IMap04     ),
        .IMap_1     (IMap14     ),
        .IMap_2     (IMap24     ),
        .IMap_3     (IMap34     ),
        .ImapVld_0  (ImapVld04  ),
        .ImapVld_1  (ImapVld14  ),
        .ImapVld_2  (ImapVld24  ),
        .ImapVld_3  (ImapVld34  ),
        .IWeight    (IWeight4   ),
        .IweightVld (IweightVld4),
        .bias       (bias4      ),
        .dout_0	    (dout04  	),
        .dout_1	    (dout14  	),
        .dout_2	    (dout24  	),
        .dout_3	    (dout34  	),
        .din_0      (dout05   	),
        .din_1      (dout15   	),
        .din_2      (dout25   	),
        .din_3      (dout35   	),
        .dinVld     (dinVld     ),
        .NMap_0     (IMap05     ),
        .NMap_1     (IMap15     ),
        .NMap_2     (IMap25     ),
        .NMap_3     (IMap35     ),
        .NMapVld_0  (ImapVld05  ),
        .NMapVld_1  (ImapVld15  ),
        .NMapVld_2  (ImapVld25  ),
        .NMapVld_3  (ImapVld35  )
    );

endmodule
