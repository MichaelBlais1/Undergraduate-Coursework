`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2018 04:07:13 PM
// Design Name: 
// Module Name: Stimulus
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


//Testbench
module Stimulus;
  reg [3:0]bcd2,bcd1,bcd0;        
  reg clk,start;        
  wire [9:0]bin;
  bcd2bin uut (.bcd2(bcd2),    //Instantiate the unit under test       
  .bcd1(bcd1),.bcd0(bcd0),.clk(clk),
  .start(start),.bin(bin));
 
  // Generate a clock of 100MHz
  always #5 clk = ~clk;           
 
  // Drive stimulus to the design
  initial begin
    clk = 0;
    start = 0;
    #20;
        start = 1;
        bcd2 = 4'b0001;
        bcd1 = 4'b0011;
        bcd0 = 4'b0001;
    #20 start = 1;
    #20 start = 0;
    #100 $finish;
  end  
endmodule

