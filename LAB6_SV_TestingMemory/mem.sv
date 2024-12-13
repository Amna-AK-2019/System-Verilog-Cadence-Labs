`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 12:00:05 PM
// Design Name: 
// Module Name: mem
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

module mem #(
  parameter WIDTH_ADDR = 5,
  parameter WIDTH_DATA = 8
)(
  input logic clk,
  input logic read,
  input logic write,
  input logic [WIDTH_ADDR-1:0] addr,
  input logic [WIDTH_DATA-1:0] data_in,
  output logic [WIDTH_DATA-1:0] data_out
);

  logic [WIDTH_DATA-1:0] memory [0:(1 << WIDTH_ADDR) - 1];

  always_ff @(posedge clk) begin
    if (write) begin
      memory[addr] <= data_in;  
    end
  end

  always_ff @(posedge clk) begin
    if (read) begin
      data_out <= memory[addr];
    end 
    else begin
      data_out <= 8'h0;  
    end
  end

endmodule