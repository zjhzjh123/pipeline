`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:16 09/07/2016
// Design Name: 
// Module Name:    data_memory 
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
module data_memory(
    input clk,
    input [31:0] address,
    input [31:0] writeData,
	 input memWrite,
    input memRead,
	 
    output reg [31:0] readData
    );
    reg [7:0] memFile[0:127]; //memory_array 127byte = 32 words
	 //reg [31:0] readData;
	 initial	 	  
	 begin
	    $readmemh("data.txt",memFile,2'h0);
     end	 	 always @ (/* posedge clk or */address or memRead )
	 begin
	   if( memRead == 1'b1 && memWrite == 1'b0 )
		  readData = {memFile[address],memFile[address+1],memFile[address+2],memFile[address+3]};
	 end
	 
	 always @ ( negedge clk )
	 begin
	   if( memRead == 1'b0 && memWrite == 1'b1 )
		  {memFile[address],memFile[address+1],memFile[address+2],memFile[address+3]} = writeData;
	 end

endmodule
