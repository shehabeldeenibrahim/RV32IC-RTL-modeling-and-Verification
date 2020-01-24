`include "defines.v"
module ControlUnit (
    input [4:0] opcode,
	 input [2:0] func,
	 input [11:0]func12,
    output Branch,
    output MemRead,
    output MemToReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output jump,
    output auipc,
	 output csr,
	 output csr_imm,
	 output MRET,
	 output US
);
    
    assign Branch = (opcode[4:2]==6)?1:0;
    assign MemRead = (opcode[4:2]==0)?1:0; 
    assign MemToReg = (opcode[4:2]==0)?1:0;
    assign ALUOp[1] = ((opcode[4:2]==3)||(opcode[4:2]==1))?1:0;
    assign ALUOp[0] = ((opcode[4:2]==6)||(opcode[4:2]==1))?1:0;
    assign MemWrite = (opcode[4:2]==2)?1:0;
    assign ALUSrc = ((opcode[4:2]==0)||(opcode[4:2]==2)||(opcode[4:2]==1)||(opcode==`OPCODE_LUI))?1:0;
    assign RegWrite = ((opcode[4:2]==0)||(opcode[4:2]==1)||(opcode[4:2]==3)||(opcode==`OPCODE_JALR)||(opcode==`OPCODE_JAL)||(opcode==`OPCODE_CSR))?1:0;
    assign auipc = (opcode== (`OPCODE_AUIPC));
    assign jump = (opcode==(`OPCODE_JALR))||(opcode==(`OPCODE_JAL));
	 assign csr = (opcode== (`OPCODE_CSR));
	 assign csr_imm = (func[2]==1&&opcode== (`OPCODE_CSR));
	 assign MRET =((opcode== (`OPCODE_CSR))&&(func12==32'h302))?1'b1:1'b0;
	 assign US = func[2]; 
	 
endmodule
