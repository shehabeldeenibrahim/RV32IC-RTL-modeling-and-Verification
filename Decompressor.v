`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:54:36 11/06/2018 
// Design Name: 
// Module Name:    Decompressor 
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
//////////////////////////////////////////////////////////////////////////////////
module Decompressor(
input [15:0] IW_Comp,
output reg [31:0] IW_Decomp
    );
	 
	 wire [1:0] opcode = IW_Comp[1:0];
	 wire [4:0] rd_rs1 = IW_Comp[11:7];
	 wire [4:0] rs2 = IW_Comp[6:2];
	 wire [2:0] funct3 = IW_Comp[15:13];
	 
	 always @ (*)
	 begin
		IW_Decomp = 32'b11111111111111111111111111111111;
		
		if(IW_Comp == 16'b1001000000000010)
			begin
				IW_Decomp <= 32'b00000000000100000000000001110011;
			end
			
		else if (opcode == 2'b00)
			begin
				case(funct3)
					0: //c.addi4spn*
					begin
						IW_Decomp <= {{2'b0,IW_Comp[10:7],IW_Comp[12:11],IW_Comp[5],IW_Comp[6],2'b0}, 5'd2, 3'b0, {2'b1,IW_Comp[4:2]}, 7'b0010011};
					end
					
					2: //c.lw*
					begin
						IW_Decomp <= {{(IW_Comp[5])?5'b11111:5'b0, IW_Comp[5], IW_Comp[12:10], IW_Comp[6], 2'b0}, {2'b1,IW_Comp[9:7]}, 3'b010, {2'b1,IW_Comp[4:2]}, 7'b0000011};
					end
					
					6: //c.sw*
					begin
						IW_Decomp <= {{(IW_Comp[5])?5'b11111:5'b0, IW_Comp[5], IW_Comp[12]}, {2'b1,IW_Comp[4:2]}, {2'b1,IW_Comp[9:7]}, 3'b010, {IW_Comp[11:10], IW_Comp[6], 2'b0}, 7'b0100011};
					end
				
				endcase
			end
			
		else if (opcode == 2'b01)
			begin
				case(funct3)
					0: //c.addi*
						begin
						IW_Decomp <= {{(IW_Comp[12])?6'b111111:6'b0, IW_Comp[6:2]}, IW_Comp[11:7], 3'b000, IW_Comp[6:2], 7'b0010011};
						end
						
					1: //c.jal*
						begin
							IW_Decomp <= {{IW_Comp[12],{IW_Comp[8], IW_Comp[10:9], IW_Comp[6], IW_Comp[7], IW_Comp[2], IW_Comp[11], IW_Comp[5:3]} , (IW_Comp[12])?9'b111111111:9'b0}, 5'b00001, 7'b1101111};
						end
					
					2: //c.li*
						begin
						IW_Decomp <= {{(IW_Comp[12])?7'b1111111:7'b0, IW_Comp[6:2]}, 8'b0, rd_rs1, 7'b0010011};
						end
						
					3: 
						begin
						if (IW_Comp[11:7] == 5'b00010) //c.addi16sp*
							begin
							IW_Decomp <= {{(IW_Comp[12])?2'b11:2'b0, IW_Comp[12], IW_Comp[4:3], IW_Comp[5], IW_Comp[2], IW_Comp[6], 4'b0}, IW_Comp[11:7], 3'b000, {2'b01, IW_Comp[4:2]}, 7'b0010011};
							end
						else //c.lui*
							begin
							IW_Decomp <= {{(IW_Comp[12])?14'b11111111111111:14'b0, IW_Comp[12], IW_Comp[6:2]}, rd_rs1, 7'b0110111};
							end
						end
						
					4:
						begin
						if ((IW_Comp[15:10] == 100011) && (IW_Comp[6:5] == 2'b10))  //c.or*
							begin
							IW_Decomp  <= {7'b0, {2'b01, IW_Comp[4:2]}, {2'b01, IW_Comp[9:7]}, 3'b110, {2'b01, IW_Comp[9:7]}, 7'b0110011};
							end
						else if ((IW_Comp[15:10] == 100011) && (IW_Comp[6:5] == 2'b01))	//c.xor*
							begin
							IW_Decomp  <= {7'b0, {2'b01, IW_Comp[4:2]}, {2'b01, IW_Comp[9:7]}, 3'b100, {2'b01, IW_Comp[9:7]}, 7'b0110011};
							end
						else if ((IW_Comp[15:10] == 100011) && (IW_Comp[6:5] == 2'b00))	//c.sub*
							begin
							IW_Decomp  <= {7'b0100000, {2'b01, IW_Comp[4:2]}, {2'b01, IW_Comp[9:7]}, 3'b000, {2'b01, IW_Comp[9:7]}, 7'b0110011};
							end
						else if (IW_Comp[11:10] == 2'b11)  //c.and*
						begin
							IW_Decomp <= {7'b0, {2'b01, IW_Comp[4:2]}, {2'b01, IW_Comp[9:7]}, 3'b111, {2'b01, IW_Comp[4:2]}, 7'b0110011};
						end
						else if (IW_Comp[11:10] == 2'b10)  //c.andi*
							begin
							IW_Decomp <= {{(IW_Comp[12])?6'b111111:6'b0, IW_Comp[12], IW_Comp[6:2]}, {2'b01, IW_Comp[9:7]}, 3'b111, {2'b01, IW_Comp[4:2]}, 7'b0110011};
							end
						else if (IW_Comp[11:10] == 2'b01)  //c.srai*
							begin
							IW_Decomp <= {6'b010000, IW_Comp[12], IW_Comp[6:2], {2'b01, IW_Comp[9:7]}, 3'b101, {2'b01, IW_Comp[9:7]}, 7'b0010011};
							end
						else if (IW_Comp[11:10] == 2'b00)  //c.srli*
							begin
							IW_Decomp  <= {6'b0, IW_Comp[12], IW_Comp[6:2], {2'b01, IW_Comp[9:7]}, 3'b101, {2'b01, IW_Comp[9:7]}, 7'b0010011};
							end
						end
						
					5: //c.j*
						begin
						IW_Decomp <= {{IW_Comp[12],{IW_Comp[8], IW_Comp[10:9], IW_Comp[6], IW_Comp[7], IW_Comp[2], IW_Comp[11], IW_Comp[5:3]} , (IW_Comp[12])?9'b111111111:9'b0}, 5'b0, 7'b1101111};
						end
						
					6: //c.beqz*
						begin
							IW_Decomp <= {{IW_Comp[12], IW_Comp[12], IW_Comp[12], IW_Comp[12], IW_Comp[6:5], IW_Comp[2]}, 5'b0, {2'b01, IW_Comp[9:7]}, 3'b000, {IW_Comp[11:10], IW_Comp[4:3], IW_Comp[12]}, 7'b1100011};
						end
						
					7: //c.bnez*
						begin
							IW_Decomp <= {{IW_Comp[12], IW_Comp[12], IW_Comp[12], IW_Comp[12], IW_Comp[6:5], IW_Comp[2]}, 5'b0, {2'b01, IW_Comp[9:7]}, 3'b001, {IW_Comp[11:10], IW_Comp[4:3], IW_Comp[12]}, 7'b1100011};
						end
						
				endcase
			end
			
		else if (opcode == 2'b10)
		begin
			case(funct3)
				0: //c.slli*
					begin
					IW_Decomp <= {6'b0, IW_Comp[12], IW_Comp[6:2], rd_rs1, 3'b001, rd_rs1, 7'b0010011};
					end

				2: //c.lwsp*
					begin
					IW_Decomp <= {{(IW_Comp[3])?4'b1111:4'b0, IW_Comp[3:2], IW_Comp[12], IW_Comp[6:4], 2'b0}, 5'b00010, 3'b010, rd_rs1, 7'b0000011};
					end
					
				4:
					begin
					if (IW_Comp[6:2] != 0)
						begin
							if (IW_Comp[12] == 1) //c.add*
								IW_Decomp  <= {7'b0, rs2, rd_rs1, 3'b0, rd_rs1, 7'b0110011};
							else //c.mv*
								IW_Decomp  <= {7'b0, rs2, 5'b0, 3'b0, rd_rs1, 7'b0110011};
						end
					else if (IW_Comp[12] == 1)  //c.jalr*
						IW_Decomp  <= {12'b0, rd_rs1, 3'b0, 5'b00001, 7'b1100111};
					else //c.jr*
						IW_Decomp  <= {12'b0, rd_rs1, 3'b0, 5'b0, 7'b1100111};
					end

				6: //c.swsp*
					begin
					IW_Decomp  <= {{(IW_Comp[8])?4'b1111:4'b0, IW_Comp[8:7], IW_Comp[12]}, rs2, 5'b00010, 3'b010, {IW_Comp[11:9], 2'b0}, 7'b0100011};
					end
				endcase
			end
		end
	 


endmodule
