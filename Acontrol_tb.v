`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:42:56 10/30/2018
// Design Name:   ALUControl
// Module Name:   C:/Users/Ahmed Khatter/Desktop/Projects/Archifinal/Acontrol_tb.v
// Project Name:  Archifinal
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALUControl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Acontrol_tb;

	// Inputs
	reg [1:0] ALUOp;
	reg [2:0] func3;
	reg func7;

	// Outputs
	wire [3:0] sel;

	// Instantiate the Unit Under Test (UUT)
	ALUControl uut (
		.ALUOp(ALUOp), 
		.func3(func3), 
		.func7(func7), 
		.sel(sel)
	);

	initial begin
		// Initialize Inputs
		ALUOp = 0;
		func3 = 3'b010;
		func7 = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

