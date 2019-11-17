`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 11:42:12 PM
// Design Name: 
// Module Name: Testbench
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


module Testbench(
    );

 reg [15:0] SW;
 reg Center;
 wire [7:0] AN;
 wire [6:0] a_to_g;
 wire [3:0] LED;
 reg CLK100MHZ;
 wire [15:0] A, B;
 wire [26:0] C;
  
//Instantiate unit under test    
Subtractor UUT(SW,Center,AN,a_to_g,LED,CLK100MHZ,A,B,C);

initial begin
SW = 0;
Center = 0;
#100 SW = 16'b0000000000000010;
#5 Center = 1'b1;
#5 Center = 1'b0;
#100 SW = 16'b0000000011110000;
#5 Center = 1'b1;
#5 Center = 1'b0;
#100 SW = 16'b0000000000001111;
#5 Center = 1'b1;
#5 Center = 1'b0;



#500 $finish;
end

initial begin
    CLK100MHZ = 0;
    forever begin
    #1 CLK100MHZ = ~CLK100MHZ;
end
end

endmodule

