//`timescale 1ns / 1ps

//module name definition
module register_test;

//timescale defined
timeunit 1ns;
timeprecision 100ps;

//port define
logic [7:0] data_out;
logic [7:0] data_in;
logic enable;
logic clk=1'b1;
logic reset=1'b1;

`define PERIOD 10

always 
    #(`PERIOD/2)clk = ~clk;
    
 //defining the instance of the register
 register r1 (
    .enable (enable),
    .clk(clk),
    .data_out(data_out),
    .data_in(data_in),
    .reset(reset)
 );

//MONITORING THE SIGNAL

initial begin
$timeformat (-9,1,"ns",9); //it will start from 9, increment by 1, measure in nano sec, will stop at 9
$monitor ("time=%t enable=%b reset=%b data_out=%h data_in=%h",$time,enable,reset,data_in,data_out);


#(`PERIOD * 99)

$display ("REGISTER TEST TIMEOUT");
$finish;
end

//TASK is written here which is checking the value of data_out and expected value to Pass the test
//Verify Results
task expect_test (input[7:0] expects);
if(data_out !== expects)
    begin
        $display ( "data_out=%b, should be %b", data_out, expects );
        $display ( "REGISTER TEST FAILED" );
        $finish;
    end
endtask

//here TEST SCENERIOS are defined
initial begin
    @(negedge clk)
      { reset, enable, data_in } = 10'b1_X_XXXXXXXX; 
      @(negedge clk) 
        expect_test ( 8'hXX );
      
      { reset, enable, data_in } = 10'b0_X_XXXXXXXX; 
        @(negedge clk) 
          expect_test ( 8'h00 );
          
      { reset, enable, data_in } = 10'b1_0_XXXXXXXX;
         @(negedge clk) 
           expect_test ( 8'h00 );
           
      { reset, enable, data_in } = 10'b1_1_10101010;  
         @(negedge clk) 
           expect_test ( 8'hAA );
           
      { reset, enable, data_in } = 10'b1_0_01010101; 
         @(negedge clk) 
           expect_test ( 8'hAA );
           
      { reset, enable, data_in } = 10'b0_X_XXXXXXXX;
         @(negedge clk) 
            expect_test ( 8'h00 );
            
      { reset, enable, data_in } = 10'b1_0_XXXXXXXX;
         @(negedge clk)
            expect_test ( 8'h00 );
            
      { reset, enable, data_in } = 10'b1_1_01010101; 
         @(negedge clk) 
           expect_test ( 8'h55 );
             
      { reset, enable, data_in } = 10'b1_0_10101010; 
        @(negedge clk) 
            expect_test ( 8'h55 );
            
      $display ( "REGISTER TEST PASSED" );
      $finish;
end

endmodule
