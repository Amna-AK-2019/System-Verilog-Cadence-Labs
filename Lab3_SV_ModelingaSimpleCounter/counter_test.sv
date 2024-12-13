//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/10/2024 09:07:00 PM
// Design Name: COUNTER RTL
// Module Name: counter_test
// Project Name: MODLEING OF THE COUNTER 
// Target Devices: 
// Tool Versions: 
// Description: 
//Wrting the system verilog code for the Counter and writing its test bench for the verifying its functionality.
//////////////////////////////////////////////////////////////////////////////////

module counter_test;

    timeunit 1ns;
    timeprecision 100ps;
    
    parameter WIDTH = 5; 
    logic [WIDTH-1:0] data;
    logic [WIDTH-1:0] count;
    logic clk, reset, load, enable;

    `define PERIOD 10

    
    counter #(WIDTH) counter_inst (
        .data(data),
        .load(load),
        .enable(enable),
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation
    always #(`PERIOD/2) clk = ~clk;

    initial begin
        $timeformat(-9, 1, "ns", 9);
        $monitor("time=%tns clk=%b rst_=%b load=%b enable=%b data=%h count=%h", 
                 $time, clk, reset, load, enable, data, count);
        #(`PERIOD * 99)  // 99*10nsec=990nsec  cycles timeout
        $display("COUNTER TEST PASSED");
        $finish;
    end

    //TEST CASES
    initial begin
        
        clk = 0;
        reset = 1;
        load = 0;
        enable = 0;
        data = 5'b00000;

        //CHECKING THE RESET FUNCTIONALITY
        $display("RESET");
        @(negedge clk)
        reset = 0; 
        @(negedge clk)
        reset = 1;  
        $display("RESET CHECK DONE");
        
        //When enable 1 start the counting
        $display("START THE COUNTING");
        @(negedge clk)
        enable = 1;
        load = 0;

        //keep on counting for the 20 cycles
        repeat (20) @(negedge clk);
        $display("COUTING DONE");
        
        // when load 1 it should load the value
        $display("LOAD THE VALUE");
        @(negedge clk)
        load = 1;
        enable = 0;
        data = 5'b10101;
        $display("LOAD DONE");
        
        @(negedge clk)
        load = 0;
        enable = 1;
        $display("START COUNTING FROM THE LOAD VALUE");
        //it should start counting from the loaded value
        repeat (10) @(negedge clk);

        $display("COUNTER TEST PASSED");
        $finish;
    end
endmodule
