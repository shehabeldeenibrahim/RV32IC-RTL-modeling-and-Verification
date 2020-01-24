/******************************************************************* *
* Module: DataPath.v
* Project: SAS
* Author: Seif Shalan
* Description: Full Data Path with instances of all required modules
*
* Change History: 26/10/2018 - Created File
*
* **********************************************************************/
`include "defines.v"
`timescale 1ns/1ns


module DataPath(
   input clk,
   input rst,
	input NMI,
	input[7:0] IRQ,
	input [31:0] DataMem_out,
	output memory_write,
   output [31:0] RS2ALU_Mux_Out,
	output [1:0] MemSize,
	output [31:0] Mem_Addr,
	output memory_unsigned
);


    wire [31:0] PC_4;
    wire [31:0] PC_New;
    wire [31:0] IDEX_PC;
    wire [31:0] JALR;
    wire jump;
    wire auipc;
    wire [31:0] PC;
    wire clk_long;
    wire Branch_Sel;
    /*
	 wire memory_write; 
    wire [31:0] Mem_Addr; 
    wire [31:0] DataMem_out;
    wire [31:0] RS2ALU_Mux_Out;
    wire [1:0] MemSize;
	 wire memory_unsigned;
	 */
    wire [31:0] IR_out; 
    wire [31:0] Imm_in; 
    wire Branch_in;
    wire MemRead_in;
    wire MemToReg_in;
    wire [1:0] ALUOp_in;
    wire MemWrite_in;
    wire ALUSrc_in;
    wire RegWrite_in;
    wire IDEX_Branch_out;
    wire IDEX_MemRead_out;
    wire IDEX_MemToReg_out;
    wire [1:0] IDEX_ALUOp_out;
    wire IDEX_MemWrite_out;
    wire IDEX_ALUSrc_out;
    wire IDEX_RegWrite_out;
    wire [31:0] IDEX_IW_out;
    wire MEMWB_MemToReg_out;
    wire MEMWB_MemWrite_out;
    wire Stall;
    wire [3:0] ALU_Sel;
    wire [31:0] ALU_out;
    wire ALUFlag;
    wire [4:0] RFIn_1;
    wire [31:0] RFIn_2;
    wire [31:0] RS1_in;
    wire [31:0] RS2_in;
    wire [31:0] IDEX_RS1_out;
    wire [31:0] IDEX_RS2_out;
    wire [31:0] WB_out;
    wire [31:0] JA_out;
    wire [31:0] ALUIn1; 
    wire [31:0] ALUIn2;
    wire [31:0] MEMWB_ALUOut;
    wire [31:0] Imm_Shifted_out;
    wire [31:0] AUIPC_out;
    wire [31:0] MEMWB_DataMemOut;
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire MEMWB_RegWrite_out; 
    wire [4:0] MEMWB_RD;
    wire [31:0] IDEX_Imm_out;
	 wire [31:0] MEMWB_AUIPCadderout;
	 wire [31:0] IDEX_AUIPCadder_out;
	 wire [31:0] jaltemp;
	 wire [31:0] DataIR_in;
	 wire [31:0] Inst_Decomp;
	 wire CompFlag_in;
	 wire IDEX_CompFlag;
	 wire MEMWB_jump_out;
	 wire MEMWB_auipc_out;
	 wire IDEX_jump_out;
	 wire IDEX_auipc_out;
	 wire [31:0] AUIPC_out_4;
    wire [31:0] Branching_out; 
	 wire [31:0] Branching_out_4;
	 wire [31:0] JAL_R_out_4;
	 assign JALR=ALU_out;
	  
	  
    /////////////////////////////////////////
	 wire[2:0] INTNUM;
	 wire Interruption;
    assign Interruption = NMI | INT | TIMER | ECALL | EBREAK; // have to add timing thing 
	 wire [31:0] EIHAmult;
	 wire [31:0] EIHAout;
	 wire ECALL, EBREAK;
	 assign ECALL= (IDEX_IW_out[`IR_opcode]==`OPCODE_SYSTEM && IDEX_IW_out[`IR_funct3]==3'b0 && IDEX_IW_out[20]==0)?1:0;
	 assign EBREAK=(IDEX_IW_out[`IR_opcode]==`OPCODE_SYSTEM && IDEX_IW_out[`IR_funct3]==3'b0 && IDEX_IW_out[20]==1)?1:0;
	 assign EIHAmult= (INTNUM<<4);
	 assign EIHAout=EIHAmult + 32'd3805;
	 wire TIMER;
	 assign TIMER= comp;
	 wire [31:0] PC_in,PC_in1;
	 wire [11:0] func12;
	 wire MRET,IDEX_MRET_out;
	 wire [31:0] IRMem_out;
	 wire UnsiSignal, IDEX_UnsiSignal_out;
	
    wire comp,MEMWB_CSR_Control_out,MEMWB_Instruction_done_out;
	 wire [31:0] csr_read_data,IDEX_CSR_read_data,MEMWB_CSR_read_data, ALU_Mux_In1,ALU_Mux_In2,WB_out_csr,mepc;
 	 wire [3:0] mie;
 	 wire csr, csr_imm_control,IDEX_CSR_imm_Control_out;
	
	 ExtInt extinterrupthandler(IRQ, INTNUM, INT);
	 /////////////////////////////////////////

    //PC Section
    ClkCounter Counter(.clk_small(clk), .rst(rst), .counter(counter), .Dclk(clk_long));
    Mux4_1 #(32) PC_Mux(.sel({IDEX_jump_out,Branch_Sel}), .in1(PC_4), .in2(Branching_out),.in3(JAL_R_out), .in4(AUIPC_out), .out(PC_New));// AUIPC_out was JALR/ALU_out
	 //PC register
    RegWLoad #(32) PC_reg(.clk(clk_long), .rst(rst), .load(~Stall), .data_in(PC_in1), .data_out(PC));
	 Mux2_1 #(32) PCiPC(.sel(Interruption), .in1(PC_New), .in2(PCi), .out(PC_in));
	 Mux2_1 #(32) PCiMRET(.sel(MRET), .in1(PC_in), .in2(mepc), .out(PC_in1));

	 ////////////////////////////////////////////////////////////////////
	 
	 assign PC_4 = (IRMem_out[1:0] == 2'b11)?(PC + 32'd4):(PC + 32'd2);
    //Mem Section
    Mux2_1 #(32) Addr_Mux(.sel(counter), .in2(PC), .in1(ALU_out), .out(Mem_Addr));
    Mux2_1 #(1) MemWrite_Mux(.sel(counter), .in1(IDEX_MemWrite_out), .in2(1'b0), .out(memory_write));
    Mux2_1 #(2) MemSize_Mux(.sel(counter), .in1(IDEX_IW_out[13:12]), .in2(2'b10), .out(MemSize));
	 
	 
    //MEMORY
    //Memory Mem(.clk(clk), .rst(rst), .memory_write(memory_write), .memory_data_in( RS2ALU_Mux_Out), .memory_size(MemSize), .memory_addr(Mem_Addr), .memory_data_out(DataMem_out));
    Decompressor Decomp(.IW_Comp(DataMem_out[31:0]), .IW_Decomp(Inst_Decomp));
	 assign DataIR_in = (DataMem_out[1:0] == 2'b11)?DataMem_out:Inst_Decomp;
	 assign CompFlag_in = (IRMem_out[1:0] == 2'b11)?1'b0:1'b1;
	 RegWLoad #(32) IR(.clk(~clk_long), .rst(rst), .load(~counter), .data_in(DataIR_in), .data_out(IR_out));
	 RegWLoad #(32) IRDecomp(.clk(~clk_long), .rst(rst), .load(~counter), .data_in(DataMem_out), .data_out(IRMem_out));
    
    //RF Section
	 wire [1:0] temp;
	 assign temp[1]= oring;
	 assign temp[0]=(counter==0)?0:MEMWB_RegWrite_out;
	 wire oring;
	 assign oring = MEMWB_jump_out | MEMWB_auipc_out;
	 
    rv32_ImmGen ImmGen(.IR(IR_out), .Imm(Imm_in));
    ControlUnit ControlUnit(.opcode(IR_out[`IR_opcode]),.MRET(MRET),.func12(IR_out[`IR_funct12]), .Branch(Branch_in), .MemRead(MemRead_in), .MemToReg(MemToReg_in), .ALUOp(ALUOp_in), .MemWrite(MemWrite_in), .ALUSrc(ALUSrc_in), .RegWrite(RegWrite_in) ,.jump(jump),.auipc(auipc), .csr(csr), .csr_imm(csr_imm_control),.func(IR_out[`IR_funct3]), .US(UnsiSignal));
    Mux2_1 #(5) RS1RD_Mux(.sel((counter==0)?0:MEMWB_RegWrite_out), .in1(IR_out[`IR_rs1]), .in2(MEMWB_RD), .out(RFIn_1));
    Mux2_1 #(32) JAL_AUIPC_Mux(.sel(MEMWB_jump_out), .in1(MEMWB_AUIPCadderout), .in2(IDEX_PC), .out(JA_out));
    Mux4_1 #(32) RS2Data_Mux(.sel(temp), .in1({27'b0, IR_out[`IR_rs2]}), .in2(WB_out_csr), .in3(JA_out), .in4(JA_out), .out(RFIn_2));
    RegFile RF(.clk(clk), .rst(rst), .rf_write_register((counter==0)?0:MEMWB_RegWrite_out), .rs1_rd(RFIn_1), .rs2_data(RFIn_2), .read_data1(RS1_in), .read_data2(RS2_in));
    HazardDetection HazardUnit(.IF_ID_RegisterRs1(IR_out[`IR_rs1]), .IF_ID_RegisterRs2(IR_out[`IR_rs2]), .ID_EX_RegisterRd(IDEX_IW_out[`IR_rd]), .ID_EX_MemRead(IDEX_MemRead_out), .stall(Stall));
    
	 
	 /////CSR instruction handling/////
	 CSR csr_rf(.clk(clk),.rst(rst),.mepc(mepc),.pc(PC),.csr_address(IR_out[`IR_csr]),.csr_write_data(MEMWB_ALUOut),.csr_write((counter==0)?0:MEMWB_CSR_Control_out),.interrupt(Interruption),.instruction(MEMWB_Instruction_done_out),.csr_read_data(csr_read_data),.comp(comp), .mie(mie));
	 Mux2_1 #(32)   csr_alu1(.sel(IDEX_CSR_imm_Control_out), .in1(ALUIn1), .in2(IDEX_Imm_out), .out(ALU_Mux_In1));
	 Mux2_1 #(32) 	 csr_alu2(.sel(IDEX_CSR_Control_out), .in1(ALUIn2), .in2(IDEX_CSR_read_data), .out(ALU_Mux_In2));
	 Mux2_1 #(32)   WB_Mux_csr(.sel(MEMWB_CSR_Control_out), .in1(WB_out), .in2(MEMWB_CSR_read_data), .out(WB_out_csr));
	 //////////////////////////////////

	 RegWLoad #(32) IDEX_csr_read_data_reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(csr_read_data), .data_out(IDEX_CSR_read_data));
    RegWLoad #(32) IDEX_IW_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IR_out), .data_out(IDEX_IW_out));
    RegWLoad #(32) IDEX_ImmGen_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(Imm_in), .data_out(IDEX_Imm_out));
    RegWLoad #(1)  IDEX_Branch_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:Branch_in), .data_out(IDEX_Branch_out));
    RegWLoad #(1)  IDEX_MemRead_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:MemRead_in), .data_out(IDEX_MemRead_out));
    RegWLoad #(1)  IDEX_MemToReg_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:MemToReg_in), .data_out(IDEX_MemToReg_out));
    RegWLoad #(2)  IDEX_ALUOp_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:ALUOp_in), .data_out(IDEX_ALUOp_out));
    RegWLoad #(1)  IDEX_MemWrite_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:MemWrite_in), .data_out(IDEX_MemWrite_out));
    RegWLoad #(1)  IDEX_UnsiSignal_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:UnsiSignal), .data_out(memory_unsigned));    
	 RegWLoad #(1)  IDEX_ALUSrc_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:ALUSrc_in), .data_out(IDEX_ALUSrc_out));
    RegWLoad #(1)  IDEX_RegWrite_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:RegWrite_in), .data_out(IDEX_RegWrite_out));
    RegWLoad #(32) IDEX_RS1_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(RS1_in), .data_out(IDEX_RS1_out));
    RegWLoad #(32) IDEX_RS2_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(RS2_in), .data_out(IDEX_RS2_out));
    RegWLoad #(32) IDEX_PC_Reg(.clk(clk_long),.rst(rst), .load(1'b1), .data_in(PC), .data_out(IDEX_PC));
	 RegWLoad #(1)  IDEX_jump_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:jump), .data_out(IDEX_jump_out));
	 RegWLoad #(1)  IDEX_auipc_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:auipc), .data_out(IDEX_auipc_out));
	 RegWLoad #(32) IDEX_auipcadder_Reg(.clk(clk_long),.rst(rst), .load(1'b1), .data_in(AUIPC_out), .data_out(IDEX_AUIPCadder_out));
	 RegWLoad #(1)  IDEX_instruction_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((Interruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:1'b1), .data_out(IDEX_Instruction_out));
	 RegWLoad #(1)  IDEX_CompFlag_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((FirstInterruption||Stall||IDEX_jump_out||Branch_Sel)?1'b0:CompFlag_in), .data_out(IDEX_CompFlag));
	 RegWLoad #(1)  IDEX_csr_control_bit(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((csr)), .data_out(IDEX_CSR_Control_out));
	 RegWLoad #(1)  IDEX_mret_bit(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(MRET), .data_out(IDEX_MRET_out));
	 RegWLoad #(1)  IDEX_csr_imm_control_bit(.clk(clk_long), .rst(rst), .load(1'b1), .data_in((csr_imm_control)), .data_out(IDEX_CSR_imm_Control_out));


//Interuption handling	 
	 reg [31:0] PCi;
	 wire FirstInterruption;
	 EdgeDetector IntEdge(clk, rst, Interruption, FirstInterruption);
 
	 always @(Interruption,rst) begin
		if (Interruption==1 && NMI==1) begin
			PCi= 32'd3741;
			end
		else if(Interruption==1 && NMI!=1 && EBREAK==1) begin
			PCi= 32'd3773;
		end
		else if(Interruption==1 && NMI!=1 && EBREAK!=1 && TIMER==1 && mie[0]==1'b1 &&mie[3]==1'b1)begin 
			PCi= 32'd3789;
		end
		else if(Interruption==1 && NMI!=1 && EBREAK!=1 && TIMER!=1 && INT==1 && mie[1]==1'b1&&mie[3]==1'b1)begin
			PCi=EIHAout; // External Interrupt handler output
		end
		else if(Interruption==1 && NMI!=1 && EBREAK!=1 && TIMER!=1 && INT!=1 && ECALL==1 && mie[2]==1'b1&&mie[3]==1'b1)begin
			PCi=32'd3757;
		end
		
		else begin 
			PCi=32'd0;// reset/ no interrupts
		end
	 end
	 
	 integer i_dis;
	 
	 
	 always @(ECALL)
	 begin
		if(ECALL)
		begin
			for(i_dis = 0; i_dis < 32; i_dis = i_dis + 1)
				$display("Reg[%d - %x] = %x", i_dis, i_dis, RF.rf[i_dis]);
			$finish;
		end
	 end


    //ALU Section
    ALUControl ALUControl(.opcode(IDEX_IW_out[`IR_opcode]),.ALUOp(IDEX_ALUOp_out), .func3(IDEX_IW_out[`IR_funct3]), .func7(IDEX_IW_out[30]), .sel(ALU_Sel));
    Mux4_1 #(32) ALUIn1_Mux(.sel(forwardA), .in1(IDEX_RS1_out), .in2(WB_out), .in3(MEMWB_ALUOut), .in4(32'b0), .out(ALUIn1));
    Mux4_1 #(32) RS2ALU_Mux(.sel(forwardB), .in1(IDEX_RS2_out), .in2(WB_out), .in3(MEMWB_ALUOut), .in4(32'b0), .out(RS2ALU_Mux_Out));
    Mux4_1 #(32) ALUIn2_Mux(.sel({IDEX_jump_out,IDEX_ALUSrc_out}), .in1(RS2ALU_Mux_Out), .in2(IDEX_Imm_out),.in3(IDEX_PC),.in4(IDEX_PC), .out(ALUIn2));
   
	 
    ALU ALU(.sel(ALU_Sel), .func3(IDEX_IW_out[`IR_funct3]), .input1(ALU_Mux_In1), .input2(ALU_Mux_In2), .CompFlag(IDEX_CompFlag), .alu_out(ALU_out), .flag(ALUFlag));

	 Mux2_1 #(32) RggD_Mux(.sel(IDEX_IW_out[3]), .in1(IDEX_RS1_out), .in2(IDEX_PC), .out(jaltemp));
  	 AdderSub AUIPC_Addr(.sub(IDEX_Imm_out[31]), .input1(jaltemp), .input2(((IDEX_Imm_out[31]==1'b0)?IDEX_Imm_out:(~IDEX_Imm_out+32'b1))), .adderout(AUIPC_out));
	 wire [31:0] JAL_R_out;
	 assign JAL_R_out = (IR_out[3])?AUIPC_out:{AUIPC_out[31:1], 1'b0};
  	 AdderSub branch_Addr(.sub(IDEX_Imm_out[31]), .input1(IDEX_PC), .input2(((IDEX_Imm_out[31]==1'b0)?IDEX_Imm_out:((~IDEX_Imm_out+32'b1)))), .adderout(Branching_out));
	 
    //Forwarding
    ForwardingUnit fwd(.IDEX_MemWrite_out(IDEX_MemWrite_out),.MEMWB_RegWrite_out(MEMWB_RegWrite_out),.IR_out_rs1(IR_out[`IR_rs1]),.IDEX_IW_out_rd(IDEX_IW_out[`IR_rd]),.IDEX_IW_out_rs1(IDEX_IW_out[`IR_rs1]),.IDEX_IW_out_rs2(IDEX_IW_out[`IR_rs2]),.IR_out_rs2(IR_out[`IR_rs2]),.MEMWB_MemToReg_out(MEMWB_MemToReg_out),.MEMWB_RD(MEMWB_RD),.forwardA(forwardA),.forwardB(forwardB));
    //Write back
	 Mux2_1 #(32) WB_Mux(.sel(MEMWB_MemToReg_out), .in1(MEMWB_ALUOut), .in2(MEMWB_DataMemOut), .out(WB_out));

    assign Branch_Sel = ALUFlag & IDEX_Branch_out;
    assign PCMux_Sel = jump | Branch_Sel; 
    
    RegWLoad #(1)  MEMWB_MemToReg_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_MemToReg_out), .data_out(MEMWB_MemToReg_out));
    RegWLoad #(32) MEMWB_ALUOut_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(ALU_out), .data_out(MEMWB_ALUOut));
    RegWLoad #(32) MEMWB_DataMemOut_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(DataMem_out), .data_out(MEMWB_DataMemOut));
    RegWLoad #(1)  MEMWB_RegWrite_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_RegWrite_out), .data_out(MEMWB_RegWrite_out));
    RegWLoad #(5)  MEMWB_RD_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_IW_out[`IR_rd]), .data_out(MEMWB_RD));
    RegWLoad #(1)  MEMWB_MemWrite_Reg2(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_MemWrite_out), .data_out(MEMWB_MemWrite_out));
 	 RegWLoad #(1)  MEMWB_jump_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_jump_out), .data_out(MEMWB_jump_out));
	 RegWLoad #(1)  MEMWB_auipc_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_auipc_out), .data_out(MEMWB_auipc_out));
	 RegWLoad #(32) MEMWB_AUIPCout_reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(AUIPC_out), .data_out(MEMWB_AUIPCadderout));
	 RegWLoad #(1)  MEMWB_instruction_Reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_Instruction_out), .data_out(MEMWB_Instruction_done_out));
	 RegWLoad #(32) MEMWB_csr_read_data_reg(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_CSR_read_data), .data_out(MEMWB_CSR_read_data));
	 RegWLoad #(1)  MEMWB_csr_control_bit(.clk(clk_long), .rst(rst), .load(1'b1), .data_in(IDEX_CSR_Control_out), .data_out(MEMWB_CSR_Control_out));

endmodule 