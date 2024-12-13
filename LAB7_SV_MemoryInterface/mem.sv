`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 12:22:46 PM
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


module mem (mem_interface io_bus);

  // Access WIDTH_ADDR and WIDTH_DATA from the interface parameters
  localparam WIDTH_ADDR = io_bus.WIDTH_ADDR;
  localparam WIDTH_DATA = io_bus.WIDTH_DATA;

  // Define the memory array based on the address width
  logic [WIDTH_DATA-1:0] memory [0:(1 << WIDTH_ADDR) - 1];

  always_ff @(posedge io_bus.clk) begin
    if (io_bus.write) begin
      memory[io_bus.addr] <= io_bus.data_in;  
    end
  end

  always_ff @(posedge io_bus.clk) begin
    if (io_bus.read) begin
      io_bus.data_out <= memory[io_bus.addr];
    end 
    else begin
      io_bus.data_out <= 8'b0;  // Set to zero when not reading
    end
  end

endmodule


module mem_test (mem_interface.mem_test io_bus);
    timeunit 1ns;
    timeprecision 1ns;

    logic [7:0] rdata;       // Stores data read from memory for checking
    int error_status;        // To track errors during testing
    bit debug = 1;           // Debug flag for displaying operations

    // Timeout to end simulation if it runs too long
    initial begin
        $timeformat(-20, 0, " ns", 20);
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
        io_bus.addr = addr_in;
        io_bus.data_in = data;
        io_bus.write = 1;
        io_bus.read = 0;
        @(negedge io_bus.clk); // Synchronize with clock edge
        io_bus.write = 0;
        if (debug) $display("Write: addr = %0d, data = %0h", addr_in, data);
    end
    endtask

    // Task to read from memory
    task read_mem(input [4:0] addr_in, output [7:0] data_out_R, input bit debug = 0);
    begin
        io_bus.addr = addr_in;
        io_bus.read = 1;
        io_bus.write = 0;
        @(negedge io_bus.clk); // Synchronize with clock edge
        data_out_R = io_bus.data_out; // Capture data from memory
        io_bus.read = 0;
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

