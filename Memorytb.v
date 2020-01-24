// file: Memory_tb.v
// author: @shehabtarek
// Testbench for Memory

`timescale 1ns/1ns

module Memory_tb;

	//Inputs
	reg clk;
	reg rst;
	reg memory_write;
	reg [31: 0] memory_data_in;
	reg [1: 0] memory_size;
	reg [31: 0] memory_addr;


	//Outputs
	wire  [31:0] memory_data_out;


	//Instantiation of Unit Under Test
	Memory uut (
		.clk(clk),
		.rst(rst),
		.memory_write(memory_write),
		.memory_data_in(memory_data_in),
		.memory_size(memory_size),
		.memory_addr(memory_addr),
		.memory_data_out( memory_data_out)
	);


    always #5 clk=~clk;
	initial begin
	//Inputs initialization
		clk = 1;
		memory_write = 1;
		memory_data_in = 10;
		memory_size = 0;
		memory_addr = 0;
		rst = 1;
		
		#25
		rst = 0;
		memory_write = 0;
		memory_size=0;
		memory_addr=0;


	//Wait for the reset
		#100;

	end

endmodule

