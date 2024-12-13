`timescale 1ns / 1ps


module register(
    input logic [7:0] data_in,
    input enable,clk,reset,     //1 bit
    output logic [7:0] data_out
    );
    
    always_ff @ (posedge clk or negedge reset)
    begin
    if (reset==1'b0)
    begin
        data_out <= 7'd0;
    end
    else if (enable==1'b1 && reset==1'b1)
    begin
        data_out <= data_in;
    end
    else
    begin
        data_out = data_out;
    end
  
    end
endmodule
