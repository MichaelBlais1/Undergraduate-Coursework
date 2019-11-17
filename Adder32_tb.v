`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2019 05:02:07 PM
// Design Name: 
// Module Name: Adder32_tb
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


module Adder32_tb();
reg [31:0] A;
reg [31:0] B;
wire [31:0] Sum;

Adder32 UUT(A,B,Sum);

initial begin
A = 32'b00111110100000000000000000000000;
B = 32'b01000010110010000000000000000000; #20
A = 32'b01010101000011000000000000000000;
B = 32'b00001111100000000000000010000100;
#20 $finish;
end
endmodule
