/*******************************************************************
*
* Module: ALUControl.v
* Project: SAS
* Author:ahmedkhatter@aucegypt.edu
* Description: Arithmatic Logical Unit control signal sel
*
* Change history: 26/10/18 - Creation
*
**********************************************************************/
`include "defines.v"
`timescale 1ns/1ns

module ALUControl(
    input [1:0] ALUOp,
    input [2:0] func3,
    input func7,
	 input [4:0] opcode,
    output reg [3:0] sel
);

    always @(*) begin
        case(ALUOp) 
            0:	if (opcode==`OPCODE_CSR && (func3==`SYS_CSRRW || func3==`SYS_CSRRWI))
							sel = `ALU_PASS1;
						else if (opcode==`OPCODE_CSR && (func3==`SYS_CSRRS || func3==`SYS_CSRRSI))
							sel = `ALU_OR;
						else if (opcode==`OPCODE_CSR && (func3==`SYS_CSRRS || func3==`SYS_CSRRSI))
							sel = `ALU_OR;
						else if (opcode==`OPCODE_CSR && (func3==`SYS_CSRRC || func3==`SYS_CSRRCI))
							sel = `ALU_CLEAR;
					else 
						sel = `ALU_ADD;   //load/store
            1:	if((opcode==`OPCODE_JAL)||(opcode==`OPCODE_JALR))
						sel= `ALU_JUMP; 
					else 
						sel = `ALU_ADD;   //branching
						
            2: if(opcode==`OPCODE_LUI)
						sel = `ALU_PASS;
					else if((func3==`F3_ADD)&&!func7)//ADD,SUB....
                    sel = `ALU_ADD;
                else if (func3==`F3_ADD)
                    sel = `ALU_SUB;
                    
                else if(func3==`F3_SLL)
                    sel = `ALU_SLL;
                    
                else if(func3==`F3_SLT)
                    sel = `ALU_SLT;
                    
                else if(func3==`F3_SLTU)
                    sel = `ALU_SLTU;
                
                else if(func3==`F3_SRL && func7 ==1'b0)//SRL
                    sel = `ALU_SRL;
						  
					 else if(func3==`F3_SRL && func7 == 1'b1)//SRA
                    sel = `ALU_SRA;
                    
                else if(func3==`F3_XOR)
                    sel = `ALU_XOR;
                    
                 else if(func3==`F3_OR)
                    sel = `ALU_OR;
                    
                else if(func3==`F3_AND)
                    sel = `ALU_AND;
                    
                else
                    sel = 4'b0000;
						  
            3:	 if(func3==`F3_ADD)//ADDI....
                    sel = `ALU_ADD;
                    
                else if(func3==`F3_SLL)//SLLI
                    sel = `ALU_SLL;
                    
                else if(func3==`F3_SLT)//SLTI
                    sel = `ALU_SLT;
                    
                else if(func3==`F3_SLTU)//SLTIU
                    sel = `ALU_SLTU;
                
                else if(func3==`F3_SRL && func7 ==1'b0)//SRLI
                    sel = `ALU_SRL;
						  
					 else if(func3==`F3_SRL && func7 == 1'b1)//SRAI
                    sel = `ALU_SRA;
                    
                else if(func3==`F3_XOR)//XORI
                    sel = `ALU_XOR;
                    
                 else if(func3==`F3_OR)//ORI
                    sel = `ALU_OR;
                    
                else if(func3==`F3_AND)//ANDI
                    sel = `ALU_AND;
                    
                else
                    sel = 4'b0000;
            default: sel = `ALU_PASS;        
        endcase
    end
    
endmodule





