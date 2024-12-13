//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/11/2024 11:12:33 AM
// Design Name: 
// Module Name: alu_test
// Project Name: alu
// Target Devices: 
// Tool Versions: 
// Description: 
// This is the system verilog code of the alu and here in this file I have written the test case to verify the design.
//////////////////////////////////////////////////////////////////////////////////


module alu_test;
  timeunit 1ns;
  timeprecision 100ps;

  logic [7:0] a, b, out;
  opcode_t opcode;  // Use enum type for opcode
  logic clk, zero;

  `define PERIOD 10

  // Clock generation
  always #(`PERIOD / 2) clk = ~clk;

  // ALU instance
  alu alu_inst (
    .a(a),
    .b(b),
    .out(out),
    .clk(clk),
    .opcode(opcode),
    .zero(zero)
  );

  // Monitor the results
  initial begin
    $timeformat(-9, 1, " ns", 9);
    $monitor("time=%t opcode=%b a=%b b=%b out=%h zero=%h",
              $time, opcode, a, b, out, zero);
    #(`PERIOD * 99)
    $display("ALU TEST TIMEOUT");
    $finish;
  end

  // Task to verify expected result
  task expect_test(input [7:0] expects);
    if (out !== expects) begin
      $display("out=%b, should be %b", out, expects);
      $display("ALU TEST FAILED");
      $finish;
    end
  endtask

  // Apply test cases
  initial begin
    clk = 0;  // Initialize clock

    @(negedge clk);
    {opcode, a, b} = {ADD, 8'h03, 8'h02}; @(negedge clk); expect_test(8'h05); // ADD
    {opcode, a, b} = {SUB, 8'h06, 8'h03}; @(negedge clk); expect_test(8'h03); // SUB
    {opcode, a, b} = {MUL, 8'h02, 8'h01}; @(negedge clk); expect_test(8'h02); // MUL
    {opcode, a, b} = {OR,  8'h01, 8'h02}; @(negedge clk); expect_test(8'h03); // OR
    {opcode, a, b} = {AND, 8'h03, 8'h2C}; @(negedge clk); expect_test(8'h00); // AND
    {opcode, a, b} = {XOR, 8'h4A, 8'h05}; @(negedge clk); expect_test(8'h4F); // XOR
    {opcode, a, b} = {SLL, 8'h03, 8'h02}; @(negedge clk); expect_test(8'h0C); // SLL (Shift Left)
    {opcode, a, b} = {SRL, 8'h06, 8'h02}; @(negedge clk); expect_test(8'h01); // SRL (Shift Right)
    
    $display("ALU TEST PASSED");
    $finish;
  end
endmodule