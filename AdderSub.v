`timescale 1ns/1ns

module AdderSub (
    input sub,
    input [31:0] input1,
    input [31:0] input2,
    output [31:0] adderout
);

    wire co;
    wire ci;
    wire [31:0] b2;
    
    assign ci=sub?1:0;
    assign b2=sub?~input2:input2;
    
    rca32 r(input1,b2,ci,adderout,co);
endmodule
