`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 11:58:33 AM
// Design Name: 
// Module Name: mem_test
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

module mem_test (
  input logic clk, 
  output logic read, 
  output logic write, 
  output logic [4:0] addr, 
  output logic [7:0] data_in,     // data to memory
  input logic [7:0] data_out       // data from memory
);
  timeunit 1ns;
  timeprecision 1ns;

  logic [7:0] rdata;          // stores data read from memory for checking
  int error_status;           // to track errors during testing
  bit debug = 1;              // debug flag for displaying operations

  // Timeout to end simulation if it runs too long
  initial begin
    $timeformat(-20, 0, " ns",20);
    #40000ns $display("MEMORY TEST TIMEOUT");
    $finish;
  end

  // Memory test sequence
  initial begin: memtest
    error_status = 0;

    // Clear Memory Test
    $display("Starting Clear Memory Test");
    for (int i = 0; i < 32; i++) begin
      write_mem(i, 8'h00, debug); // Write zero to each address
    end

    for (int i = 0; i < 32; i++) begin
      read_mem(i, rdata, debug); // Read each address and check
      if (rdata !== 8'h00) begin
        $display("Error at address %0d: expected 0x00, got 0x%h", i, rdata);
        error_status++;
      end
    end
    print_result("Clear Memory Test", error_status);

    // Data = Address Test
    error_status = 0;
    $display("Starting Data = Address Test");
    for (int i = 0; i < 32; i++) begin
      write_mem(i, i[7:0], debug); // Write data equal to address value
    end

    for (int i = 0; i < 32; i++) begin
      read_mem(i, rdata, debug); // Read and verify each address
      if (rdata !== i[7:0]) begin
        $display("Error at address %0d: expected 0x%h, got 0x%h", i, i[7:0], rdata);
        error_status++;
      end
    end
    print_result("Data = Address Test", error_status);

    $finish;
  end

  // Task to write to memory
  task write_mem(input [4:0] addr_in, input [7:0] data, input bit debug = 0);
    begin
      addr = addr_in;
      data_in = data;
      write = 1;
      read = 0;
      @(negedge clk); // Synchronize with clock edge
      write = 0;
      if (debug) $display("Write: addr = %0d, data = %0h", addr_in, data);
    end
  endtask

  // Task to read from memory
  task read_mem(input [4:0] addr_in, output [7:0] data_out_R, input bit debug = 0);
    begin
      addr = addr_in;
      read = 1;
      write = 0;
      @(negedge clk); // Synchronize with clock edge
      data_out_R = data_out; // Capture data from memory
      read = 0;
      if (debug) $display("Read: addr = %0d, data_out_R = %0h", addr_in, data_out_R);
    end
  endtask

  // Function to print test results
  function void print_result(input string test_name, input int errors);
    if (errors == 0) begin
      $display("%s PASSED", test_name);
    end else begin
      $display("%s FAILED with %0d errors", test_name, errors);
    end
  endfunction

endmodule
