//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/10/2024 07:38:09 PM
// Design Name: LAB2 Modeling of MUX in SV---testing
// Module Name: scale_mux_test
// Project Name: SIMPLE MULTIPLEXER TESTING
// Target Devices: 
// Tool Versions: System Verilog
// Description: 
//***This is the lab2 of Cadence lab where we are writing the system verilog code of 2x1 mux and testing it by giving the test cases.**
//////////////////////////////////////////////////////////////////////////////////

module scale_mux_test;

timeunit 1ns;
timeprecision 100ps;

parameter WIDTH = 2; // Define WIDTH parameter
logic [WIDTH-1:0] in_a;
logic [WIDTH-1:0] in_b;
logic [WIDTH-1:0] out;
logic sel;

`define PERIOD 10

// INSTANCE of MUX
scale_mux #(WIDTH) mux_inst (
    .in_a(in_a),
    .in_b(in_b),
    .sel(sel),
    .out(out)
);

// Monitor the results
initial begin
    $timeformat(-9, 1, "ns", 9);
    $monitor("time=%t in_a=%b in_b=%b sel=%b out=%b", $time, in_a, in_b, sel, out);
    #(`PERIOD * 99)  //delay 99*10ns=990nsec
    $display("MUX TIMEOUT");
    $finish;
end

// Verify the Results
task expect_test(input [WIDTH-1:0] expects);
    if(out != expects) begin
        $display("out=%b, should be %b", out, expects);
        $display("MUX TEST FAILED");
        $finish; 
    end
endtask

// Apply test cases
initial begin
    // Test case 1: in_a = 00, in_b = 00, sel = 0 -> out = in_b = 00
    {in_a, in_b, sel} = 5'b11_00_0;
    #`PERIOD;
    expect_test(in_b);
    
    // Test case 2: in_a = 00, in_b = 11, sel = 1 -> out = in_a = 11
    {in_a, in_b, sel} = 5'b01_01_1;
    #`PERIOD;
    expect_test(in_a);
    
    // Test case 3: in_a = 01, in_b = 00, sel = 0 -> out = in_b = 00
    {in_a, in_b, sel} = 5'b01_11_0;
    #`PERIOD;
    expect_test(in_b);
    
    // Test case 4: in_a = 00, in_b = 10, sel = 1 -> out = in_a = 10
    {in_a, in_b, sel} = 5'b01_10_1;
    #`PERIOD;
    expect_test(in_a);
    
    $display("MUX TEST PASSED");
    $finish;
end

endmodule
