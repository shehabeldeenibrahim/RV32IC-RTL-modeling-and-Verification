`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:12 11/13/2018 
// Design Name: 
// Module Name:    Flag 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//

`include "defines.v"


module Flag(
	 input [2:0] func3,
    input [31:0] input1,
    input [31:0] input2,
    output reg flag

    );
	 
    always @(*) begin

        case(func3)
            `BR_BEQ: flag=(input1==input2)?1:0;
            `BR_BNE : flag=(input1!=input2)?1:0;
            `BR_BLT : flag=($signed(input1)<$signed(input2))?1:0;
            `BR_BGE : flag=($signed(input1)>=$signed(input2))?1:0;
            `BR_BLTU :flag=(input1<input2)?1:0;
            `BR_BGEU :flag=(input1>=input2)?1:0;
            default: flag=0;
        endcase
		  end


endmodule
