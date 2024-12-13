`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 04:31:48 PM
// Design Name: 
// Module Name: controller
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

module controller (
    input logic clk,
    input logic rst_n,
    input opcode_t opcode,
    input logic zero,
    
    output logic mem_rd,
    output logic load_ir,
    output logic halt,
    output logic inc_pc,
    output logic load_ac,
    output logic load_pc,
    output logic mem_wr
);

    // Define states
    state_t current_state, next_state;
    logic aluop;
    
    // ALU operation condition
    always_comb begin
        aluop = (opcode == OP_AND) || (opcode == OP_ADD) || (opcode == OP_XOR) || (opcode == OP_LDA);
    end
    
    // State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= INST_ADDR;
        else
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (current_state)
            INST_ADDR: next_state = INST_FETCH;
            INST_FETCH: next_state = INST_LOAD;
            INST_LOAD: next_state = IDLE;
            IDLE: next_state = OP_ADDR;
            OP_ADDR: next_state = OP_FETCH;
            OP_FETCH: next_state = ALU_OP;
            ALU_OP: next_state = STORE;
            STORE: next_state = INST_ADDR;
            default: next_state = INST_ADDR;
        endcase
    end

    // Output logic based on the current state
    always_comb begin
        // Default output values
        mem_rd = 0;
        load_ir = 0;
        halt = 0;
        inc_pc = 0;
        load_ac = 0;
        load_pc = 0;
        mem_wr = 0;

        // Output assignments based on state
        case (current_state)
            INST_ADDR: begin
                // No specific outputs set for INST_ADDR, all default
            end

            INST_FETCH: begin
                mem_rd = 1;
            end

            INST_LOAD: begin
                mem_rd = 1;
                load_ir = 1;
            end

            IDLE: begin
                mem_rd = 1;
                load_ir = 1;
            end

            OP_ADDR: begin
                if (opcode == OP_HLT) begin
                    halt = 1;
                end
                    inc_pc = 1;
               
            end

            OP_FETCH: begin
                mem_rd = aluop;
            end

            ALU_OP: begin
                mem_rd = aluop;
                load_ac = aluop;
                if (opcode == OP_SKZ && zero) begin
                    inc_pc = 1;
                end
                if (opcode == OP_JMP) begin
                    load_pc = 1;
                end
            end

            STORE: begin
                if (opcode == OP_STO) begin
                    mem_wr = 1;
                end
                if (opcode == OP_JMP) begin
                    inc_pc = 1;
                    load_pc = 1;
                end
            end
        endcase
    end

endmodule
