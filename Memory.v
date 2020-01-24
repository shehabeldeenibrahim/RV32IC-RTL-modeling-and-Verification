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

module Memory(
    input clk,
	 input rst,
    input memory_write, 
    input [31:0] memory_data_in,
    input [1:0] memory_size,
    input [31:0] memory_addr,
	 input memory_unsigned,
    output reg  [31:0] memory_data_out
);

    reg [31:0] memory_data_out_temp;
    reg[7:0] mem[(4*1024-1):0];
	 
	 wire [23:0] signedbit_0;
	 wire [15:0] signedbit_1;
	 wire [15:0] signedbit;
	 assign signedbit = {mem[memory_addr+1], mem[memory_addr]};
	 assign signedbit_0 = (signedbit[7] == 1)?24'hFFFFFF:24'b0;
	 assign signedbit_1 = (signedbit[15] == 1)?16'hFFFF:16'b0;
    
	  initial begin
	//NMI
		{mem[3744],mem[3743],mem[3742],mem[3741]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3748],mem[3747],mem[3746],mem[3745]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3752],mem[3751],mem[3750],mem[3749]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//Ecall
	   {mem[3760],mem[3759],mem[3758],mem[3757]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3764],mem[3763],mem[3762],mem[3761]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3768],mem[3767],mem[3766],mem[3765]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//Ebreak
		{mem[3776],mem[3775],mem[3774],mem[3773]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3780],mem[3779],mem[3778],mem[3777]}=32'b001100000100_01111_110_00000_1110011;		//mie = 'b01111
		{mem[3784],mem[3783],mem[3782],mem[3781]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//Timer
	   {mem[3792],mem[3791],mem[3790],mem[3789]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3796],mem[3795],mem[3794],mem[3793]}=32'b1011_0000_0001_11111_111_01010_1110011;   //TIMER = 'b0
		{mem[3800],mem[3799],mem[3798],mem[3797]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3804],mem[3803],mem[3802],mem[3801]}=32'b001100000010_00000_000_00000_1110011;     //MRET

	//INT[0]
	   {mem[3808],mem[3807],mem[3806],mem[3805]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3812],mem[3811],mem[3810],mem[3809]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3816],mem[3815],mem[3814],mem[3813]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[1]
	   {mem[3824],mem[3923],mem[3922],mem[3921]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3828],mem[3927],mem[3926],mem[3925]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3832],mem[3931],mem[3930],mem[3929]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[2]
	   {mem[3840],mem[3839],mem[3838],mem[3837]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3844],mem[3843],mem[3842],mem[3841]}=32'b001100000100_01111_110_00000_1110011;  //mie = 'b01111
		{mem[3848],mem[3847],mem[3846],mem[3845]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[3]
	   {mem[3856],mem[3855],mem[3854],mem[3853]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3860],mem[3859],mem[3858],mem[3857]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3864],mem[3863],mem[3862],mem[3861]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[4]
	   {mem[3872],mem[3871],mem[3870],mem[3869]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3876],mem[3875],mem[3874],mem[3873]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3880],mem[3879],mem[3878],mem[3877]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[5]
	   {mem[3888],mem[3887],mem[3886],mem[3885]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3892],mem[3891],mem[3890],mem[3889]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3896],mem[3895],mem[3894],mem[3893]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[6]
	   {mem[3904],mem[3903],mem[3902],mem[3901]}=32'b0011_0000_0100_11111_111_01010_1110011;		//mie='b00000
		{mem[3908],mem[3907],mem[3906],mem[3905]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3912],mem[3911],mem[3910],mem[3909]}=32'b001100000010_00000_000_00000_1110011;     //MRET
	//INT[7]
	   {mem[3920],mem[4019],mem[4018],mem[4017]}=32'b0011_0000_0100_11111_111_01010_1110011;   //mie = 'b00000
		{mem[3924],mem[4023],mem[4022],mem[4021]}=32'b001100000100_01111_110_00000_1110011;   //mie = 'b01111
		{mem[3928],mem[4027],mem[4026],mem[4025]}=32'b001100000010_00000_000_00000_1110011;     //MRET
		
       $readmemh("./test2.hex", mem);
		 
     
	 end 
	 always@(*)
	 begin
				if(memory_size == 2'b00) memory_data_out={((memory_unsigned == 1)?24'b0:signedbit_0), mem[memory_addr]}; 
            else if(memory_size == 2'b01) memory_data_out={((memory_unsigned == 1)?16'b0:signedbit_1), mem[memory_addr+1], mem[memory_addr]};
            else if(memory_size == 2'b10) memory_data_out={mem[memory_addr+3], mem[memory_addr+2], mem[memory_addr+1], mem[memory_addr]};
	 end
	 
	 
    always @ (posedge clk) 
    begin
        if(memory_write == 1) 
		  begin 
            if(memory_size == 2'b00) mem[memory_addr]=memory_data_in[7:0];
            else if(memory_size == 2'b01) {mem[memory_addr+1], mem[memory_addr]}=memory_data_in[15:0];
            else if(memory_size == 2'b10) {mem[memory_addr+3], mem[memory_addr+2], mem[memory_addr+1], mem[memory_addr]}=memory_data_in;
        end
    end 
endmodule
 