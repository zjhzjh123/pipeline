`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:21 09/03/2016
// Design Name: 
// Module Name:    inst_memory 
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
/*module inst_memory(
    input [31:0] address,
    output reg [31:0] instruction
    );
    reg [7:0] instFile[0:127];
	 initial
	   $readmemb("inst8.txt",instFile);
	 always @ ( address )
		  instruction = {instFile[address],instFile[address+1],instFile[address+2],instFile[address+3]};
endmodule
*/
module inst_memory(
    input [31:0] address,
    output reg [31:0] instruction
    );
    reg [31:0] instFile[0:63];
	 initial
	   $readmemb("inst32_2.txt",instFile);
	 always @ ( address )
		  instruction = instFile[address >> 2];
endmodule
