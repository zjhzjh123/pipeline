`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:15:46 09/07/2016
// Design Name:   top_pipeline
// Module Name:   C:/lab6_version2/test_for_top.v
// Project Name:  lab6_version2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_for_top;

	// Inputs
	reg Clock;
	reg Reset;

	// Instantiate the Unit Under Test (UUT)
	top_pipeline uut (
		.Clock(Clock), 
		.Reset(Reset)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 1;
		
		// Wait 100 ns for global reset to finish
 	   #70;
      Reset = 0;	
		// Add stimulus here

	end
 always
      #50 Clock = ~Clock;
      
endmodule

