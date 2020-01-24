`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:22 11/12/2018 
// Design Name: 
// Module Name:    ExtInt 
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

module ExtInt(
input [7:0] IRQ, 
output reg [2:0] INTNUM,
output reg INT
    );
	 //reg [2:0] INTNUM;
	 //reg INT;
 always@(*) begin
 
	if(IRQ[0]&&!IRQ[1]&&!IRQ[2]&&!IRQ[3]&&!IRQ[4]&&!IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd0;
		end
	else if(!IRQ[0]&&IRQ[1]&&!IRQ[2]&&!IRQ[3]&&!IRQ[4]&&!IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd1;
		end
	else if(!IRQ[0]&&!IRQ[1]&&IRQ[2]&&!IRQ[3]&&!IRQ[4]&&!IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd2;
		end
	else if(!IRQ[0]&&!IRQ[1]&&!IRQ[2]&&IRQ[3]&&!IRQ[4]&&!IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd3;
		end
	else if(!IRQ[0]&&!IRQ[1]&&!IRQ[2]&&!IRQ[3]&&IRQ[4]&&!IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd4;
		end
	else if(!IRQ[0]&&!IRQ[1]&&!IRQ[2]&&!IRQ[3]&&!IRQ[4]&&IRQ[5]&&!IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd5;
		end
	else if(!IRQ[0]&&!IRQ[1]&&!IRQ[2]&&!IRQ[3]&&!IRQ[4]&&!IRQ[5]&&IRQ[6]&&!IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd6;
		end
	else if(!IRQ[0]&&!IRQ[1]&&!IRQ[2]&&!IRQ[3]&&!IRQ[4]&&!IRQ[5]&&!IRQ[6]&&IRQ[7])
		begin
			INT<=1;
			INTNUM<=3'd7;
		end
	else begin
		INT<=0;
		INTNUM<=3'd0;
	end
		
	end


	
endmodule
