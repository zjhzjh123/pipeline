`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:09 09/07/2013 
// Design Name: 
// Module Name:    ForwardCtr 
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
module ForwardCtr(
    input Ex_Mem_regWrite,
	 input Mem_Wb_regWrite,
    input [4:0] Ex_Mem_writeRegAdd,
    input [4:0] Mem_Wb_writeRegAdd,
    input [4:0] Id_Ex_readReg1,
    input [4:0] Id_Ex_readReg2,
	 
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
    );
	 //IMPORTANT MESSAGE:
	 //Data From EX/MEM will be 10 on ForwardA/B
	 //Data From MEM/WB will be 01 on ForwardA/B
	 always @ ( Ex_Mem_regWrite or Mem_Wb_regWrite or Ex_Mem_writeRegAdd or Mem_Wb_writeRegAdd or Id_Ex_readReg2 or Id_Ex_readReg2 )
	 begin
	   //Rs
	   if( Ex_Mem_regWrite == 1'b1 && Ex_Mem_writeRegAdd == Id_Ex_readReg1)//MEM level
		    ForwardA = 2'b10;
	   else if( Mem_Wb_regWrite == 1'b1 && Mem_Wb_writeRegAdd == Id_Ex_readReg1 )//WB level
		    ForwardA = 2'b01;
		else
		    ForwardA = 2'b00;
		//Rd
	   if( Ex_Mem_regWrite == 1'b1 && Ex_Mem_writeRegAdd == Id_Ex_readReg2)//MEM level
		    ForwardB = 2'b10;
	   else if( Mem_Wb_regWrite == 1'b1 && Mem_Wb_writeRegAdd == Id_Ex_readReg2 )//WB level
		    ForwardB = 2'b01;
		else
		    ForwardB = 2'b00;
	 
	 end
endmodule
