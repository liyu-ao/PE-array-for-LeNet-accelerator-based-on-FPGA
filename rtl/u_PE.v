`timescale 1ns/1ps
`define halfword_width 16
`define DATA_SIZE 8


module u_PE#(
    parameter Calcycle=25 
)(
	input         				            clk_cal, 
	input 					                rst_cal,
	input  		[`DATA_SIZE-1:0] 	        IWeight, IMap,
	input         				            ImapVld,IweightVld,
    input       [`DATA_SIZE-1:0]            bias,
	output 	    [`DATA_SIZE-1:0] 	        OMap, 
	output        				            OMapVld
);
    //parameter Calcycle=25;// K*K*IChannel 

	wire 		                    I_CalDataVld;	
	reg [10:0]                      MultiCount;
    wire[`halfword_width-1:0]       Multi,PEsum,data_B;
    wire[`halfword_width-1:0]       Sum_a;
	wire[`halfword_width-1:0]       Sum_m;
	reg [`halfword_width-1:0]       data_B_R;

	//IMap * IWeight 
	multi u_multi(.a(IMap),.b(IWeight),.data_out(Sum_m));
	add u_add(.A(Multi),.B(data_B),.out(Sum_a));
    
    assign data_B       = (MultiCount == 0)?  {bias[7],5'b0,bias[6:0],3'b0} : data_B_R;
	assign Multi        = (I_CalDataVld == 1'b1)? Sum_m : 16'b0;
	assign PEsum        = (I_CalDataVld == 1'b1)? Sum_a : 16'b0;
	assign I_CalDataVld = ImapVld & IweightVld;
	assign OMapVld     = MultiCount == (Calcycle-1);
	assign OMap         = (PEsum[15])? 8'b0 : (PEsum[2])?{PEsum[15],PEsum[9:3]+1'b1}:{PEsum[15],PEsum[9:3]};
	
	
	always@(posedge rst_cal or posedge clk_cal )
	begin
		if(rst_cal)begin
			MultiCount  <= 0;
            data_B_R    <= 0;
		end
		else begin
			if(I_CalDataVld)begin 	
				MultiCount  <= MultiCount + 1;	
				data_B_R    <= PEsum;								
				if(MultiCount == (Calcycle-1)) begin
					MultiCount  <= 0;
					data_B_R    <= 0;
				end							
			end 
		end	
	end

 
endmodule
