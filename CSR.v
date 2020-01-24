`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:21 11/12/2018 
// Design Name: 
// Module Name:    CSR 
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
module CSR(
	input clk,
	input rst,
	input [31:0] pc,
    input [11:0] csr_address,
    input [31:0] csr_write_data,
    input csr_write,
	 input interrupt,
	 input instruction,
    output [31:0] csr_read_data,
	 output reg comp,
	 output reg [3:0] mie,
	 output reg [31:0] mepc
    );
	 
	 reg [2:0] address_mapped;
	 wire Dclk, counter;
	 /*
mcycle=0
mtime=1
mtimecmp=2
minstret=3
mepc=4
mie=5
mip=6
*/

 ClkCounter c(.clk_small(clk),.rst(rst),.counter(counter),.Dclk(Dclk));
	 always@(*)
			begin
				if(csr_address==12'hB00) //mcycle
					address_mapped=0;
				else if(csr_address==12'hB01) //mtime
					address_mapped=1;
				else if(csr_address==12'hB03) //mtimecmp
					address_mapped=2;
				else if(csr_address==12'hB02) //minstret
					address_mapped=3;
				else if(csr_address==12'h341) //mepc
					address_mapped=4;
				else if(csr_address==12'h304) //mie
					address_mapped=5;
				else if(csr_address==12'h305) //mip
					address_mapped=6;
				if(csr_rf[1]>=csr_rf[2])
										comp=1;
									else
										comp=0;
			   mie=csr_rf[5][3:0];
				mepc=csr_rf[4];
			end
	reg[31:0] csr_rf[6:0];
	assign csr_read_data =  csr_rf[address_mapped];
	integer i;
   always @ (posedge clk or posedge rst or posedge counter)
	 begin
			 if(rst)
					begin
							for (i=0; i<7; i=i+1)
								begin
									if((i!=2)&&(i!=5))
										csr_rf[i] <= 32'b0;
									comp=0;
								end
							csr_rf[2]=32'd2000; //mtimecmp hardcoded
							csr_rf[5]=32'b01111; //mie hardcoded
					end
			 else
			    begin
					 if(clk)
							begin
									csr_rf[0] <= csr_rf[0]+1; //mcycle update
									
									if(instruction==1)
									begin
										csr_rf[3]<=csr_rf[3]+1;
									end
							end
					 if(counter)
						begin
							csr_rf[1]<=csr_rf[1]+1;
						end
					  if(csr_write==1) 
							begin
								csr_rf[address_mapped] <= csr_write_data;
							end
					end
	end
	
always @(posedge interrupt)
	begin
		csr_rf[4]<=pc;  //mepc
	end

endmodule
