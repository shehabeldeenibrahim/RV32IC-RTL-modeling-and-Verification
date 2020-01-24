// file: Pctemp.v
// author: @shehabtarek

`timescale 1ns/1ns

module ClkCounter(
input clk_small,
input rst,
output counter,
output reg Dclk);

assign counter=temp;

reg temp;
always@ (posedge clk_small , posedge rst)
begin

	 if(rst == 1)
    	begin
    	    temp = 1;
    		Dclk = clk_small;
    	end
	else begin
	
		if(temp==1)
		begin
			temp = 0;
		end
		
		else begin 
		 temp =1;
		end
	 Dclk = ~Dclk;
	end  
end

endmodule 





