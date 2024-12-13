`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 11:59:04 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Top-level Module
module top;
  timeunit 1ns;
  timeprecision 1ns;

  bit         clk;
  wire        read;
  wire        write;
  wire [4:0]  addr;
  wire [7:0]  data_out;
  wire [7:0]  data_in;

  // Instantiate memory test and memory module
  mem_test test (.*);
  mem memory (.clk(clk), .read(read), .write(write), .addr(addr), .data_in(data_in), .data_out(data_out));

  // Clock generation
  always #5 clk = ~clk;
endmodule
