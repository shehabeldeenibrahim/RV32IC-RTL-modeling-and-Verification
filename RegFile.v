`timescale 1ns / 1ps
module RegFile(
	input  clk,
	input rst,
	input  rf_write_register,
	input  [4:0] rs1_rd,
	input  [31:0] rs2_data,
	output  [31:0] read_data1,
	output  [31:0] read_data2
	);
	assign read_data1 = (rs1_rd==0) ? 31'b0: rf[rs1_rd];
	assign read_data2 = (rs2_data==0) ? 31'b0: rf[rs2_data];
    reg[31:0] rf[31:0];
	 
	  integer i;

    always @ (posedge clk or posedge rst)
	 begin
			 if(rst)begin
					
					 for (i=0; i<32; i=i+1) rf[i] <= 32'b0;
					end
			  
			 else begin
			 
			 
				  if(rf_write_register==1) 
					begin	rf[rs1_rd] <= rs2_data;
						//$display("RF: Write 0x%X (%d) to %d", rf_write_data, rf_write_data, rf_rd);
				  end
				  
				  /*else if(rf_write_register==0)
				  begin
	
					
					read_data1 <= (rs1_rd==0) ? 31'b0: rf[rs1_rd];
					read_data2 <= (rs2_data==0) ? 31'b0: rf[rs2_data];
					end*/
				end
	
	end
endmodule 