`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 04:33:07 PM
// Design Name: 
// Module Name: controller_test
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


import typedefs::*;

module controller_tb;

    // Inputs
    logic clk;
    logic rst_n;
    typedefs::opcode_t opcode;
    logic zero;

    // Outputs
    logic mem_rd;
    logic load_ir;
    logic halt;
    logic inc_pc;
    logic load_ac;
    logic load_pc;
    logic mem_wr;

    // Instantiate the controller module
    controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .opcode(opcode),
        .zero(zero),
        .mem_rd(mem_rd),
        .load_ir(load_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .load_ac(load_ac),
        .load_pc(load_pc),
        .mem_wr(mem_wr)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        opcode = typedefs::OP_HLT;
        zero = 0;

        // Apply reset
        #10;
        rst_n = 1;

        // Wait for a few clock cycles to observe behavior
        #20;
        
        // Test with different opcodes
        opcode = typedefs::OP_ADD;  // Test an ALU operation
        #20;
        
        opcode = typedefs::OP_STO;  // Test a store operation
        #20;

        opcode = typedefs::OP_JMP;  // Test a jump operation
        #20;
        
        opcode = typedefs::OP_SKZ;  // Test skip-if-zero
        zero = 1;               // Set zero flag for SKZ
        #20;
        
        opcode = typedefs::OP_HLT;  // Test halt operation
        #20;

        rst_n=0;
        
        #30;
        rst_n = 1;


        opcode = typedefs::OP_AND;  // Test an ALU operation
        #20;
        
        opcode = typedefs::OP_XOR;  // Test a store operation
        #20;

        opcode = typedefs::OP_LDA;  // Test a jump operation
        #20;
        
        // End of simulation
        $display("Basic test completed.");
        $finish;
    end

endmodule
