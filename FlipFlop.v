// file: FlipFlop.v
// author: @cherifsalama

`timescale 1ns/1ns

module FlipFlop(
	 input slowclk,
    input clk, 
    input rst, 
    input d, 
    output reg q
);

    always @(posedge clk or posedge rst) begin
	if(rst == 1)
      q<=0; 
		
	 else// if (slowclk==0)
begin
		  q<=d;
    end
end
endmodule

