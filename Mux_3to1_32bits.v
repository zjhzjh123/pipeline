`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:57 09/07/2013 
// Design Name: 
// Module Name:    Mux_3to1_32bits 
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
module Mux_3to1_32bits(
    input [31:0] Input0,
    input [31:0] Input1,
    input [31:0] Input2,
    input [1:0] Select,
    output [31:0] Output
    );
    assign Output = ( Select[1] == 1'b1 ) ? ( Input2 ) : ((Select[0] == 1'b1)?Input1:Input0);
endmodule
