`timescale 1ns / 1ps

module rca32(
input [31:0] a,
input [31:0] b,
input cin,
output wire [31:0] sum,
output wire [31:0] cout
);

integer i;
reg [31:0] sumtemp;
reg [31:0] couttemp;

always @(*)
begin	
   sumtemp[0] = a[0] ^ b[0] ^ cin;
   couttemp[0] = a[0]&b[0] | b[0]&cin | a[0]&cin;

for(i=1;i<32;i=i+1)
    begin
		sumtemp[i] = a[i] ^ b[i] ^ couttemp[i-1];
		  couttemp[i] = a[i]&b[i] | b[i]&couttemp[i-1] | a[i]&couttemp[i-1];
	end

end
assign cout=couttemp;
assign sum = sumtemp;
endmodule
