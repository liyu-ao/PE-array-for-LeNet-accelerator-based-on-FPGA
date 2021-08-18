`timescale 1ns/1ps
`define halfword_width 16
`define DATA_SIZE 8

module u_PE_column(
    input         				            clk_cal, 
	input 					                rst_cal,
	input               		            dinVld,
	input       [`DATA_SIZE-1:0] 	        IWeight,IMap_0,IMap_1,IMap_2,IMap_3,
	input         			                IweightVld,ImapVld_0,ImapVld_1,ImapVld_2,ImapVld_3,
    input       [`DATA_SIZE-1:0]            din_0,din_1,din_2,din_3,
    input       [`DATA_SIZE-1:0]            bias,
	output 	    [`DATA_SIZE-1:0] 	        dout_0,dout_1,dout_2,dout_3,
    output      [`DATA_SIZE-1:0]            NMap_0,NMap_1,NMap_2,NMap_3,
    output                                  NMapVld_0,NMapVld_1,NMapVld_2,NMapVld_3
    );

u_PE_pass u_PE_0(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap       (IMap_0     ),
        .IWeight    (IWeight    ),
        .ImapVld    (ImapVld_0  ),
        .IweightVld (IweightVld ),
        .bias       (bias       ),
        .dout	    (dout_0   	),
        .din        (din_0   	),
        .dinVld     (dinVld     ),
        .NMap       (NMap_0     ),
        .NMapVld    (NMapVld_0  )
    );

u_PE_pass u_PE_1(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap       (IMap_1     ),
        .IWeight    (IWeight    ),
        .ImapVld    (ImapVld_1  ),
        .IweightVld (IweightVld ),
        .bias       (bias       ),
        .dout	    (dout_1   	),
        .din        (din_1   	),
        .dinVld     (dinVld     ),
        .NMap       (NMap_1     ),
        .NMapVld    (NMapVld_1  )
    );

u_PE_pass u_PE_2(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap       (IMap_2     ),
        .IWeight    (IWeight    ),
        .ImapVld    (ImapVld_2  ),
        .IweightVld (IweightVld ),
        .bias       (bias       ),
        .dout	    (dout_2   	),
        .din        (din_2   	),
        .dinVld     (dinVld     ),
        .NMap       (NMap_2     ),
        .NMapVld    (NMapVld_2  )
    );

u_PE_pass u_PE_3(
        .clk_cal    (clk_cal    ),
        .rst_cal    (rst_cal    ),
        .IMap       (IMap_3     ),
        .IWeight    (IWeight    ),
        .ImapVld    (ImapVld_3  ),
        .IweightVld (IweightVld ),
        .bias       (bias       ),
        .dout	    (dout_3   	),
        .din        (din_3   	),
        .dinVld     (dinVld     ),
        .NMap       (NMap_3     ),
        .NMapVld    (NMapVld_3  )
    );


endmodule
