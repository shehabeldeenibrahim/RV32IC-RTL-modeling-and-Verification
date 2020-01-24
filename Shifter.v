/*******************************************************************
*
* Module: Shifter.v
* Project: SAS
* Author:ahmedkhatter@aucegypt.edu
* Description: Performs sll,srl,sra instructions
*
* Change history: 26/10/18 - Creation
*
**********************************************************************/

`timescale 1ns/1ns

module Shifter(
input [31:0] tobeshifted,
input [4:0] amount,
input [1:0] left,
output [31:0] aftershifting
);

reg signed [31:0] shifting;



always @(*) begin

    shifting=tobeshifted;
    
    if(left[0]==1 && left[1]==0)begin
    
        if(amount[0]==1) begin 
				shifting = shifting <<1; 
        end
        
        if(amount[1]==1) begin 
				shifting = shifting <<2;
        end
        
        if(amount[2]==1) begin
				shifting = shifting <<4;
        end
        
        if(amount[3]==1) begin
				shifting = shifting <<8;
        end
        
        if(amount[4]==1) begin
				shifting = shifting <<16;
        end
        
    end
    
    else if(left[1]==0 && left[0]==0)begin
    
        if(amount[0]==1) begin 
				shifting = shifting>>1; 
        end
        
        if(amount[1]==1)begin 
				shifting = shifting>>2;
        end
        
        if(amount[2]==1)begin
				shifting = shifting >>4;
        end
        
        if(amount[3]==1)begin
				shifting = shifting >>8;
        end
        
        if(amount[4]==1) begin
				shifting = shifting >>16;
        end
        
    end
    
    else begin
    
        if(amount[0]==1) begin 
				shifting = $signed(shifting)>>>1; 
        end
        
        if(amount[1]==1)begin 
				shifting = $signed(shifting)>>>2;
        end
        
        if(amount[2]==1)begin
				shifting = $signed(shifting)>>>4;
        end
        
        if(amount[3]==1)begin
				shifting = $signed(shifting)>>>8;
        end
        
        if(amount[4]==1) begin
				shifting = $signed(shifting)>>>16;
        end
    
    end

end

assign aftershifting=shifting;

	
endmodule



