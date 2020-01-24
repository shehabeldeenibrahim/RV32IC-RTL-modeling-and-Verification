`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2018 02:29:05 PM
// Design Name: 
// Module Name: ForwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 
 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2018 02:29:05 PM
// Design Name: 
// Module Name: ForwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 
 
module ForwardingUnit(
input MEMWB_RegWrite_out,
input IDEX_MemWrite_out,
input [4:0] IR_out_rs1,
input [4:0] IDEX_IW_out_rd,
input [4:0] IDEX_IW_out_rs1,
input [4:0] IDEX_IW_out_rs2,
input [4:0] IR_out_rs2,
input MEMWB_MemToReg_out,
input [4:0] MEMWB_RD,
output reg [1:0] forwardA,
output reg [1:0] forwardB
    );



always @(*)
begin


//EX Hazard 
if(MEMWB_RegWrite_out && (IDEX_IW_out_rd!=0) && (MEMWB_RD == IDEX_IW_out_rs1))
   
    forwardA = 2'b10;
    
    else 
      forwardA = 2'b00;
    
if(MEMWB_RegWrite_out && (IDEX_IW_out_rd!=0) && (MEMWB_RD == IDEX_IW_out_rs2))

    forwardB = 2'b10;
    
     else 
       forwardB = 2'b00;


//MEM Hazard    
 if((MEMWB_MemToReg_out||(MEMWB_MemToReg_out&&IDEX_MemWrite_out)) && (MEMWB_RD != 0) && (MEMWB_RD==IDEX_IW_out_rs1) ) 
    forwardA = 2'b01;
       /*else 
       forwardA = 2'b00;*/


if((MEMWB_MemToReg_out||(MEMWB_MemToReg_out&&IDEX_MemWrite_out)) && (MEMWB_RD != 0) && (MEMWB_RD==IDEX_IW_out_rs2) ) 
    forwardB = 2'b01;
       /*else 
       forwardB = 2'b00;*/

end

endmodule

