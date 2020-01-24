// file: HaxardDetection.v
// author: @shehabtarek

`timescale 1ns/1ns
module HazardDetection(
input [4:0] IF_ID_RegisterRs1,
input [4:0] IF_ID_RegisterRs2,
input [4:0] ID_EX_RegisterRd,
input ID_EX_MemRead,
output /*reg*/ stall);


/*always @(*)
begin
if(((IF_ID_RegisterRs1==ID_EX_RegisterRd)||(IF_ID_RegisterRs2==ID_EX_RegisterRd))&&ID_EX_MemRead&&ID_EX_RegisterRd !=0)
    stall = 1;
else
    stall = 0;
end*/

assign stall=0;
endmodule

