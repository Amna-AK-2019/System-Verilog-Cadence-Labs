`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 12:23:11 PM
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


module top;
    timeunit 1ns;
    timeprecision 1ns;

    // Declare the interface and modports
    mem_interface io_bus();  // Instantiate the interface
    
    // Declare signals
    logic clk;               // Clock signal
    
    // Instantiate the memory and memory test modules
    mem memory (
        .io_bus(io_bus.mem)   // Connect the mem modport to io_bus
    );
    
    mem_test test (
        .io_bus(io_bus.mem_test)  // Connect the mem_test modport to io_bus
    );

    // Clock generation
    always #5 clk = ~clk;  // Generate clock signal with a period of 10ns
endmodule
