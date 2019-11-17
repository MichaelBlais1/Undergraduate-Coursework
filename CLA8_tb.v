`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2018 10:52:01 PM
// Design Name: 
// Module Name: CLA8_tb
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


module CLA8_tb;
    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;

    // Outputs
    wire [3:0] S;
    wire Cout;
    wire PG;
    wire GG;

    // Instantiate the Unit Under Test (UUT)
    CLA8_tb uut (
    .s(s), 
    .co(co), 
    .pg(pg), 
    .gg(gg), 
    .a(a), 
    .b(b), 
    .cin(cin)
    );

    initial begin
    // Initialize Inputs
    a = 0;  b = 0;  cin = 0;
    // Wait 100 ns for global reset to finish
    #100;
        
    // Add stimulus here
    a=8'b00010000;b=8'b11000000;cin=1'b0;
   
    end 
 
    initial begin
 $monitor("time=",$time,, "A=%b B=%b Cin=%b : Sum=%b Cout=%b PG=%b GG=%b",A,B,Cin,S,Cout,PG,GG);
    end      
endmodule

