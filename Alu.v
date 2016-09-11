`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:12 09/03/2016 
// Design Name: 
// Module Name:    Alu 
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
module Alu(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr,
    output reg zero,
    output reg [31:0] aluRes
    );
    //reg zero;
	 //reg [31:0] aluRes;
	 
	 always @ ( input1 or input2 or aluCtr )
	 begin
	     case( aluCtr )
		  4'b0010://add
		      aluRes = input1 + input2;
		  4'b0110: //sub
		     begin
			  aluRes = input1 - input2;
			  if(aluRes == 0 ) zero = 1;
			  else zero = 0;
			  end
		  4'b0000: //and
		       aluRes = input1&input2;
		  4'b0001: //or
		       aluRes = input1|input2;
		  4'b0111: //sltu(without signed) 
		       begin
				 if(input1 < input2 ) aluRes = 1;
				 else aluRes = 0;
				 end
			4'b1100: //nor
			    aluRes = ~(input1|input2);
			4'b1111: //bne
				 begin 
				 aluRes = input1 + input2;
				 if(aluRes == 0) zero = 0;
				 else zero = 1;
				 end
			endcase
	  end
		  

endmodule
