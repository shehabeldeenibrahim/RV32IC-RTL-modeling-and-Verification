module EdgeDetector(clk, rst, level, z);
	input clk, rst, level;
	output z; 


reg [1:0]ed;
always @(posedge clk)
	ed <= {ed[0], level};
	
	
assign z = (ed == 2'b01); 

endmodule
