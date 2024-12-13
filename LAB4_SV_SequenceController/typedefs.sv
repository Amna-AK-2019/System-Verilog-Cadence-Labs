`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 04:28:09 PM
// Design Name: 
// Module Name: typedefs
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

package typedefs;

typedef enum logic [2:0] {
    OP_HLT  = 3'b000,
    OP_SKZ  = 3'b001,
    OP_ADD  = 3'b010,
    OP_AND  = 3'b011,
    OP_XOR  = 3'b100,
    OP_LDA  = 3'b101,
    OP_STO  = 3'b110,
    OP_JMP  = 3'b111
} opcode_t;

typedef enum logic [2:0] {
    IDLE,
    INST_ADDR,
    INST_FETCH,
    INST_LOAD,
    OP_ADDR,
    OP_FETCH,
    ALU_OP,
    STORE
} state_t;

endpackage:typedefs