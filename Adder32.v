`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 09:22:29 PM
// Design Name: 
// Module Name: Adder32
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

module Adder32(
input [31:0] A,
input [31:0] B,
output [31:0] Sum
);
reg [7:0] SumExp;
reg SumSign;
reg [24:0] SumMan;
reg [22:0] SumManFinal;
reg [7:0] AExp;
reg [7:0] BExp;
reg [7:0] aexp;
reg [7:0] bexp;
reg ASign;
reg BSign;
reg [23:0] AMan;
reg [23:0] BMan;
initial begin
SumManFinal = 0;
end
always @ (*) begin
//BREAK DOWN THE NUMBERS TO BE ADDED INTO THEIR THREE PARTS
AExp = A[30:23];
BExp = B[30:23];
aexp = A[30:23];
bexp = B[30:23];
ASign = A[31];
BSign = B[31];
AMan = A[23:0];
BMan = B[23:0];

//USE XOR TO GET THE CORRECT SIGN BIT FOR THE SUM
SumSign = 0;

//EQUALIZE THE EXPONENTS
if (AExp <= BExp) begin
    AExp = AExp + (bexp - aexp); end    
if (AExp > BExp) begin
    BExp = BExp + (aexp - bexp); end
    
if (AExp <= BExp) begin
    AMan = AMan >> (bexp - aexp); end 
if (AExp > BExp) begin
    BMan = BMan >> (aexp - bexp); end 

//GET THE SUM MANTISSA AND SUM EXPONENT AT THIS POINT
SumMan = AMan + BMan;
SumExp = AExp;

//NORMALIZE THE RESULT
if (SumMan[24] == 1'b1) begin 
    SumMan = SumMan >> 1;
    SumExp = SumExp + 25'd1; end
    
if ((SumMan[22] == 1'b1) & (SumMan[24:23] == 0)) begin
SumMan = SumMan << 24'd1;
SumExp = SumExp - 24'd1; end

if ((SumMan[21] == 1'b1) & (SumMan[24:22] == 0)) begin
SumMan = SumMan << 24'd2;
SumExp = SumExp - 24'd2; end

if ((SumMan[20] == 1'b1) & (SumMan[24:21] == 0)) begin
SumMan = SumMan << 24'd3;
SumExp = SumExp - 24'd3; end

if ((SumMan[19] == 1'b1) & (SumMan[24:20] == 0)) begin
SumMan = SumMan << 24'd4;
SumExp = SumExp - 24'd4; end

if ((SumMan[18] == 1'b1) & (SumMan[24:19] == 0)) begin
SumMan = SumMan << 24'd5;
SumExp = SumExp - 24'd5; end

if ((SumMan[17] == 1'b1) & (SumMan[24:18] == 0)) begin
SumMan = SumMan << 24'd6;
SumExp = SumExp - 24'd6; end

if ((SumMan[16] == 1'b1) & (SumMan[24:17] == 0)) begin
SumMan = SumMan << 24'd7;
SumExp = SumExp - 24'd7; end

if ((SumMan[15] == 1'b1) & (SumMan[24:16] == 0)) begin
SumMan = SumMan << 24'd8;
SumExp = SumExp - 24'd8; end
///////////////////////////////////////////////////
if ((SumMan[14] == 1'b1) & (SumMan[24:15] == 0)) begin
SumMan = SumMan << 24'd9;
SumExp = SumExp - 24'd9; end

if ((SumMan[13] == 1'b1) & (SumMan[24:14] == 0)) begin
SumMan = SumMan << 24'd10;
SumExp = SumExp - 24'd10; end

if ((SumMan[12] == 1'b1) & (SumMan[24:13] == 0)) begin
SumMan = SumMan << 24'd11;
SumExp = SumExp - 24'd11; end

if ((SumMan[11] == 1'b1) & (SumMan[24:12] == 0)) begin
SumMan = SumMan << 24'd12;
SumExp = SumExp - 24'd12; end

if ((SumMan[10] == 1'b1) & (SumMan[24:11] == 0)) begin
SumMan = SumMan << 24'd13;
SumExp = SumExp - 24'd13; end

if ((SumMan[9] == 1'b1) & (SumMan[24:10] == 0)) begin
SumMan = SumMan << 24'd14;
SumExp = SumExp - 24'd14; end

if ((SumMan[8] == 1'b1) & (SumMan[24:9] == 0)) begin
SumMan = SumMan << 24'd15;
SumExp = SumExp - 24'd15; end

if ((SumMan[7] == 1'b1) & (SumMan[24:8] == 0)) begin
SumMan = SumMan << 24'd16;
SumExp = SumExp - 24'd16; end

if ((SumMan[6] == 1'b1) & (SumMan[24:7] == 0)) begin
SumMan = SumMan << 24'd17;
SumExp = SumExp - 24'd17; end

if ((SumMan[5] == 1'b1) & (SumMan[24:6] == 0)) begin
SumMan = SumMan << 24'd18;
SumExp = SumExp - 24'd18; end

if ((SumMan[4] == 1'b1) & (SumMan[24:5] == 0)) begin
SumMan = SumMan << 24'd19;
SumExp = SumExp - 24'd19; end

if ((SumMan[3] == 1'b1) & (SumMan[24:4] == 0)) begin
SumMan = SumMan << 24'd20;
SumExp = SumExp - 24'd20; end

if ((SumMan[2] == 1'b1) & (SumMan[24:3] == 0)) begin
SumMan = SumMan << 24'd21;
SumExp = SumExp - 24'd21; end

if ((SumMan[1] == 1'b1) & (SumMan[24:2] == 0)) begin
SumMan = SumMan << 24'd22;
SumExp = SumExp - 24'd22; end

//DELETE EXCESS BIT ON THE LEFT
SumManFinal = SumMan[22:0];
end

//COMPOSE FINAL RESULT
assign Sum = {SumSign,SumExp,SumManFinal};
endmodule





















