`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:15 09/03/2016 
// Design Name: 
// Module Name:    AluCtr 
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
module AluCtr(
    input [5:0] funct,
    input [2:0] aluOp,
    output [3:0] aluCtr
    );
	 reg [3:0] aluCtr;
	 always @ (aluOp or funct)
	 casex({aluOp,funct})
	   9'b000xxxxxx: aluCtr = 4'b0010;//add
		9'b001xxxxxx: aluCtr = 4'b0110;//sub
		9'b011xxxxxx: aluCtr = 4'b0000;//and
		9'b100xxxxxx: aluCtr = 4'b0001;//or
		9'b101xxxxxx: aluCtr = 4'b0111;//slt
		9'b111xxxxxx: aluCtr = 4'b1111;//bne
		
		9'b010xx0000: aluCtr = 4'b0010;//R-add
		9'b010xx0010: aluCtr = 4'b0110;//R-sub
		9'b010xx0100: aluCtr = 4'b0000;//R-and
		9'b010xx0101: aluCtr = 4'b0001;//R-or
		9'b010xx1010: aluCtr = 4'b0111;//R-slt
	 endcase


endmodule
