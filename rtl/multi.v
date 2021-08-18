module multi(
					a,
					b,
					data_out
);

input [7:0]a,b;

output [15:0]data_out;

wire [14:0]ab;

assign ab = a[6:0] * b[6:0];
assign data_out = {a[7]^b[7],ab};


endmodule

