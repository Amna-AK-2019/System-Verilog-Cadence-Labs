`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/10/2024 09:07:00 PM
// Design Name: COUNTER RTL
// Module Name: COUNTER
// Project Name: MODLEING OF THE COUNTER 
// Target Devices: 
// Tool Versions: 
// Description: 
//Wrting the system verilog code for the Counter.
//////////////////////////////////////////////////////////////////////////////////

module counter #(parameter WIDTH = 5)(
   input logic [WIDTH-1:0] data,
   input logic clk,
   input logic reset,
   input logic load,
   input logic enable,
   output logic [WIDTH-1:0] count
);

    always_ff @ (posedge clk or negedge reset)
    begin
        if (reset == 1'b0)  // Active-low reset
            count <= 0;  
        else if (load == 1'b1 && enable == 1'b0)  
            count <= data;
        else if (load == 1'b0 && enable == 1'b1) 
            count <= count + 1;
    end

endmodule
