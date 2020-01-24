`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:36:26 10/30/2018
// Design Name:   ControlUnit
// Module Name:   C:/Users/Ahmed Khatter/Desktop/Projects/Archifinal/CU_tb.v
// Project Name:  Archifinal
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ControlUnit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CU_tb;

	// Inputs
	reg [4:0] opcode;

	// Outputs
	wire Branch;
	wire MemRead;
	wire MemToReg;
	wire [1:0] ALUOp;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	wire jump;
	wire auipc;

	// Instantiate the Unit Under Test (UUT)
	ControlUnit uut (
		.opcode(opcode), 
		.Branch(Branch), 
		.MemRead(MemRead), 
		.MemToReg(MemToReg), 
		.ALUOp(ALUOp), 
		.MemWrite(MemWrite), 
		.ALUSrc(ALUSrc), 
		.RegWrite(RegWrite), 
		.jump(jump), 
		.auipc(auipc)
	);

	initial begin
		// Initialize Inputs
		opcode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

