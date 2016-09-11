`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:57:50 09/07/2016
// Design Name: 
// Module Name:    HazardCtr 
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
module HazardCtr(
    //Data Hazard
    input [4:0] If_Id_readReg1,
    input [4:0] If_Id_readReg2,
    input Id_Ex_memRead,
    input [4:0] Id_Ex_regdst,
	 //Ctr Hazard
	 input jump,
	 input PCsource,
	 
    output reg PCWrite,
    output reg If_Id_write,
	 output reg Ex_Mem_stall,
    output reg Id_Ex_stall,
	 output reg If_Id_flush
    );
    always @ ( If_Id_readReg1 or If_Id_readReg2 or Id_Ex_memRead or Id_Ex_regdst or jump or PCsource )
	 begin
	 //Control hazard beq (It should be the first)
	 if( PCsource == 1 )
	     begin
	     PCWrite = 1;
		  If_Id_write = 1;
		  Ex_Mem_stall = 1;
		  Id_Ex_stall = 1;
		  If_Id_flush = 1;
	     end
	 //LW data hazard (The next two won't happen together )
	 else if( Id_Ex_memRead == 1 && (Id_Ex_regdst == If_Id_readReg1 || Id_Ex_regdst == If_Id_readReg2))
	     begin
		  PCWrite = 0;
		  If_Id_write = 0;
		  Ex_Mem_stall = 0;
		  Id_Ex_stall = 1;
		  If_Id_flush = 0;
		  end
	 //Control hazard jump
	 else if( jump == 1 )
	     begin
		  PCWrite = 1;
		  If_Id_write = 1;
		  Ex_Mem_stall = 0;
		  Id_Ex_stall = 0;
		  If_Id_flush = 1;
		  end
	 //Deafault
	 else
	     begin
		  PCWrite = 1;
		  If_Id_write = 1;
		  Ex_Mem_stall = 0;
		  Id_Ex_stall = 0;
		  If_Id_flush = 0;
		  end
	 end

endmodule
