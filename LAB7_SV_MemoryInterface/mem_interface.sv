`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 12:30:48 PM
// Design Name: 
// Module Name: mem_interface
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


interface mem_interface #
(
    parameter WIDTH_ADDR = 5,
    parameter WIDTH_DATA = 8
);
    // Define signals
    logic clk;
    logic read, write;
    logic [WIDTH_ADDR-1:0] addr;
    logic [WIDTH_DATA-1:0] data_in;
    logic [WIDTH_DATA-1:0] data_out;
    
    // Define modports for mem
    modport mem (
        input  clk,
        input  read,
        input  write,
        input  addr,
        input  data_in,
        output data_out
    );
    
    // Define modports for mem_test
    modport mem_test (
        input  clk,
        output read,
        output write,
        output addr,
        output data_in,
        input  data_out
    );

endinterface
