`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2018 09:30:27 PM
// Design Name: 
// Module Name: stimulus
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


module stimulus;
  reg [7:0]dataIn;        
  reg clk,enqueue,dequeue;
  wire [7:0]dataOut;       
  wire full,empty;
  FIFO uut (.dataIn(dataIn),    //Instantiate the unit under test       
  .enqueue(enqueue),.dequeue(dequeue),.clk(clk),
  .dataOut(dataOut),.full(full),.empty(empty));
 
  // Generate a clock of 100MHz
  always #5 clk = ~clk;           
 
  // Drive stimulus to the design
  initial begin
    clk = 0;
    enqueue = 1'b0;
    dequeue = 1'b0;
    dataIn = 8'd0;
    #20;
    enqueue = 1'b1;
    dataIn = 8'b11110000;
    #20;
    dataIn = 8'b00001111;
    #20;
    dataIn = 8'b00000001;
    #20;
    #100 $finish;

