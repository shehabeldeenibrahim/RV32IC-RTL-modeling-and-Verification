/******************************************************************* *
* Module: MainPath.v
* Project: SAS
* Author: Seif Shalan
* Description: -
*
* Change History: 21/11/2018 - Created File
*
* **********************************************************************/

`timescale 1ns/1ns

module MainPath(
   input clk,
   input rst,
	input NMI,
	input[7:0] IRQ
);

   wire [31:0] DataMem_out;
	wire memory_write;
	wire [31:0] RS2ALU_Mux_Out;
	wire [1:0] MemSize;
	wire [31:0] Mem_Addr;
	wire memory_unsigned;
    
   Memory Mem(.clk(clk), .rst(rst), .memory_write(memory_write), .memory_data_in(RS2ALU_Mux_Out), .memory_size(MemSize), .memory_addr(Mem_Addr), .memory_unsigned(memory_unsigned), .memory_data_out(DataMem_out));
   DataPath DataPath(.clk(clk), .rst(rst), .NMI(NMI), .IRQ(IRQ), .DataMem_out(DataMem_out), .memory_write(memory_write), .RS2ALU_Mux_Out(RS2ALU_Mux_Out), .MemSize(MemSize), .Mem_Addr(Mem_Addr), .memory_unsigned(memory_unsigned));

endmodule

