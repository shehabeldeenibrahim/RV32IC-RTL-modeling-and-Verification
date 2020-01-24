`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:12:15 10/29/2018
// Design Name:   DataPath
// Module Name:   G:/project_xlinix/ms1/dp_test.v
// Project Name:  ms1
// Target Device:  
// Tool versions:  
// Description:  
//
// Verilog Test Fixture created by ISE for module: DataPath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
///////////////////////////////////////////// ///////////////////////////////////

module dp_test;

	// Inputs
	reg clk;
	reg rst;
	reg NMI;
	reg[7:0] IRQ;

	// Instantiate the Unit Under Test (UUT)
	MainPath uut (
		.clk(clk), 
		.rst(rst),
		.NMI(NMI),
	   .IRQ(IRQ)
	);

always #5 clk=~clk;
 initial begin

           // Initialize Inputs

           clk = 1;

           rst=1;

           NMI=0;

           IRQ=8'b00000000;

           #1

           rst=0;

           #25
			  
			//IRQ=8'b00000000;
				
           #20;

           //NMI=0;

 

           // Wait 100 ns for global reset to finish

 

       

           // Add stimulus here

 

      end     
		endmodule

