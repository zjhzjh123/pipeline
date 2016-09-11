`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:09:47 09/03/2016 
// Design Name: 
// Module Name:    Ctr 
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
module Ctr(
    input [5:0] opCode,
    output regDst,
    output aluSrc,
    output memToReg,
    output regWrite,
    output memRead,
    output memWrite,
    output branch,
    output [2:0] aluOp,
    output jump
    );
    reg regDst;
	 reg aluSrc;
	 reg memToReg;
	 reg regWrite;
	 reg memRead;
	 reg memWrite;
	 reg branch;
	 reg [2:0] aluOp;
	 reg jump;

/*
About Aluop[2:0]
000 => ADD
001 => SUB
010 => R_TYPE
011 => AND
100 => OR
101 => SLTI
*/	 
	 always @ (opCode)
	 begin
	 case(opCode)
	     6'b000010: // jump
		  begin
		      regDst = 0;
				aluSrc = 0;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b000; //Aluop == 000 => add Here use default
            jump = 1;
         end
	
	     6'b000000: // R Type
		  begin
		      regDst = 1;
				aluSrc = 0;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b010; //Aluop == 010 => R_type
            jump = 0;
         end
		
	     6'b100011: // lw
		  begin
		      regDst = 0;
				aluSrc = 1;
            memToReg = 1;
            regWrite = 1;
            memRead = 1;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b000;  //Aluop == 000 => add
            jump = 0;
         end
			
	     6'b101011: // sw
		  begin
		      regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 1;
            branch = 0;
            aluOp = 3'b000; // Aluop == 000 => add
            jump = 0;
         end

	     6'b000100: // beq
		  begin
		      regDst = 0;
				aluSrc = 0;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            branch = 1;
            aluOp = 3'b001; //Aluop == 001 => sub
            jump = 0;
         end
			
			6'b000101: //bne
			begin 
				regDst = 0;
				aluSrc = 0;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            branch = 1;
            aluOp = 3'b111; //Aluop == 001 => sub
            jump = 0;
			end 
			
			6'b001000: //addi
			begin
		      regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b000; //Aluop == 000 => add
            jump = 0;
			end
			
         6'b001001: //subi
         begin
		      regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b001; //Aluop == 001 => sub
            jump = 0;
         end
         
         6'b001100: //andi
         begin
				regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b011; //Aluop == 011 => and
            jump = 0;
         end

         6'b001101: //ori
         begin
				regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b100; //Aluop == 100 => or
            jump = 0;
         end
			
			6'b001010: //slti
         begin
				regDst = 0;
				aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b101; //Aluop == 101 => slt
            jump = 0;
         end
			
	 default:
		  begin
		      regDst = 0;
				aluSrc = 0;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b00;
            jump = 0;
         end
	endcase
			end
endmodule
