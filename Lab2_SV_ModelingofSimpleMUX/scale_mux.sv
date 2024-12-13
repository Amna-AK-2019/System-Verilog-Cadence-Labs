`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/10/2024 07:38:09 PM
// Design Name: LAB2 Modeling of MUX in SV
// Module Name: scale_mux
// Project Name: SIMPLE MULTIPLEXER
// Target Devices: 
// Tool Versions: System Verilog
// Description: 
//***This is the lab2 of Cadence lab where we are writing the system verilog code of 2x1 mux.***
//////////////////////////////////////////////////////////////////////////////////


module scale_mux #(
    parameter WIDTH = 2
)(
    input logic [WIDTH-1:0] in_a,
    input logic [WIDTH-1:0] in_b,
    input logic sel,
    output logic [WIDTH-1:0] out
);

//sel=1'b1 ---> out= in_a;
//sel=1'b0 ---> out=in_b;

    always_comb begin
        if (sel == 1'b1) 
            out = in_a;
        else 
            out = in_b;
    end

endmodule
