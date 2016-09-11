`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:20 09/03/2016
// Design Name: 
// Module Name:    register 
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
module register(
    input clk,
	 input reset,
    input [4:0] readRes1,
    input [4:0] readRes2,
    input [4:0] writeRes,
    input [31:0] writeData,
	 input regWrite,
	 
    output reg[31:0] readData1,
    output reg[31:0] readData2
    );
	 reg [31:0] resFile[31:0]; //32*32bits register_array
    //reg [31:0] readData1;
	 //reg [31:0] readData2;
	 integer i;
	 initial
	 begin
	    $readmemh("register.txt",resFile,8'h0);
	 end
	 
	 always @ ( /*posedge clk or*/ readRes1 or readRes2 )
	 begin
	   readData1 = resFile[readRes1];
		readData2 = resFile[readRes2];
	 end
	 
	 always @ (posedge clk)
	 begin
	/* if( reset == 1 )
	   begin
		  for(i = 0; i < 32; i = i+1 )
		     resFile[i] = 32'h00000000;
		end
	 else*/
	 if( regWrite == 1'b1 )
	   resFile[writeRes] = writeData;
	 end

endmodule
