/*******************************************************************
*
* Module: Memory.v
* Project: SAS
* Author: @shehabtarek
* Description: Instruction and data memory
*
* Change history: 26/10/2018 - Did something
* 
**********************************************************************/
`timescale 1ns/1ns

module InstMemory(
    input clk,
	 input rst,
    input memory_write, 
    input [31:0] memory_data_in,
    input [1:0] memory_size,
    input [31:0] memory_addr,
    output reg [31:0] memory_data_out
);

    reg [31:0] memory_data_out_temp;
    //assign memory_data_out=memory_data_out_temp;
    //assign memory_data_out=mem[memory_addr];
    reg[7:0] mem[(4*1024-1):0];
    
    //assign memory_data_out = {mem[memory_addr+3], mem[memory_addr+2], mem[memory_addr+1], mem[memory_addr]};
	  //always @( posedge rst)
	  initial begin
		//{mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//	     {mem[3],mem[2],mem[1],mem[0]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//        {mem[7],mem[6],mem[5],mem[4]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//        {mem[11],mem[10],mem[9],mem[8]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//        {mem[15],mem[14],mem[13],mem[12]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//        {mem[19],mem[18],mem[17],mem[16]}=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 2
//        {mem[23],mem[22],mem[21],mem[20]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2 //should be skipped
//        {mem[27],mem[26],mem[25],mem[24]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
//        {mem[31],mem[30],mem[29],mem[28]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//        {mem[35],mem[34],mem[33],mem[32]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
//        {mem[39],mem[38],mem[37],mem[36]}=32'b0000000_00001_00110_000_00111_0110011 ; //add x7, x6, x1
//        {mem[43],mem[42],mem[41],mem[40]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
//        {mem[47],mem[46],mem[45],mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 
//        {mem[51],mem[49],mem[48],mem[47]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
//        {mem[55],mem[54],mem[53],mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
       $readmemh("./test2.hex", mem);
          
     
	 end 
    always @ (posedge clk) 
    begin
        if(memory_write==1) begin 
            if(memory_size==2'b00) mem[memory_addr]=memory_data_in[7:0];
            else if(memory_size==2'b01) {mem[memory_addr+1], mem[memory_addr]}=memory_data_in[15:0];
            else if(memory_size==2'b10) {mem[memory_addr+3], mem[memory_addr+2], mem[memory_addr+1], mem[memory_addr]}=memory_data_in;
        end
		  else begin
            if(memory_size==2'b00)   memory_data_out[7:0]={24'b0,mem[memory_addr]}; 
            else if(memory_size==2'b01) memory_data_out[15:0]={16'b0,mem[memory_addr+1], mem[memory_addr]};
            else if(memory_size==2'b10) memory_data_out={mem[memory_addr+3], mem[memory_addr+2], mem[memory_addr+1], mem[memory_addr]};
        end 
		  
        
    end 
endmodule
 

