/*******************************************************************
*
* Module: ALU.v
* Project: SAS
* Author:ahmedkhatter@aucegypt.edu
* Description: Arithmatic Logical Unit
*
* Change history: 26/10/18 - Creation
*
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module ALU(
    input [3:0] sel,
    input [2:0] func3,
    input [31:0] input1,
    input [31:0] input2,
	 input CompFlag,
    output reg [31:0] alu_out,
    output reg flag
);

    wire [31:0] sum_diff;
    wire sub;
    wire [31:0] shifted;
    
    assign sub = (sel==1)?1:0;

    AdderSub a1(sub,input1,input2,sum_diff);
    Shifter s1(input1,{input2[4],input2[3],input2[2],input2[1],input2[0]},{sel[1],sel[0]}, shifted);

    always @(*) begin
        case(sel)
            `ALU_ADD: alu_out=sum_diff;
            `ALU_SUB: alu_out=sum_diff;
            `ALU_AND: alu_out=input1&input2;
            `ALU_OR: alu_out=input1|input2;
            `ALU_XOR: alu_out=input1^input2;
            `ALU_SLL: alu_out=shifted;
            `ALU_SRL: alu_out=shifted;
            `ALU_SRA: alu_out=shifted;
            `ALU_SLTU: alu_out= (input1<input2)?1'b1:1'b0;
            `ALU_SLT: alu_out= ($signed(input1)<$signed(input2))?1'b1:1'b0;
				`ALU_PASS: alu_out= input2;
				`ALU_JUMP: alu_out= (CompFlag == 1'b1)?(input2 + 32'd2):(input2 + 32'd4);
				`ALU_PASS1: alu_out=input1;
				`ALU_CLEAR: alu_out=(~input1)&input2;
            default: alu_out=0;
        endcase
         
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
