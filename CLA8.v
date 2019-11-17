`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2018 10:07:41 PM
// Design Name: 
// Module Name: CLA8
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

//Partial full adder
module PFA(
    input A, B, C,
    output G, P, S
    );
    assign G = A & B; //Generate
    assign P = A ^ B; //Propagate
    assign S = P ^ C;  //Sum
endmodule
//CLA Logic
module CLALogic(
    input [3:0] P, G, 
    input Cin,
    output [3:0] Cout,
    output PG, GG
    );
    assign PG = P[3] & P[2] & P[1] & P[0];  //Group propagate for 4 bit
    assign GG = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);  //Group generate for 4 bit
    assign Cout[0] = G[0] | P[0] & Cin;
    assign Cout[1] = G[1] | P[1] & G[0] | P[1] & P[0] & Cin;
    assign Cout[2] = G[2] | P[2] & G[1] | P[2] & P[1] & G[0] | P[2] & P[1] & P[0] & Cin;
    assign Cout[3] = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0] | P[3] & P[2] & P[1] & Cin;
endmodule
//4 bit CLA
module CLA4(
    input [3:0] A, B,
    input Cin,
    output [3:0] S,
    output PG, GG, Cout
    );
    wire [3:0] WG, WP, C;
    assign Cout = C[3];
    //Instantiate partial full adders and 4 bit CLA logic
    PFA PFA0(.C(Cin),.A(A[0]),.B(B[0]),.G(WG[0]),.P(WP[0]),.S(S[0]));
    PFA PFA1(.C(C[0]),.A(A[1]),.B(B[1]),.G(WG[1]),.P(WP[1]),.S(S[1]));
    PFA PFA2(.C(C[1]),.A(A[2]),.B(B[2]),.G(WG[2]),.P(WP[2]),.S(S[2]));
    PFA PFA3(.C(C[2]),.A(A[3]),.B(B[3]),.G(WG[3]),.P(WP[3]),.S(S[3]));
    CLALogic CarryLookaheadLogic(.P(WP),.G(WG),.Cin(Cin),.Cout(C),.PG(PG),.GG(GG));
    endmodule
//8 bit CLA
module CLA8(
    input [7:0] A, B,
    input Cin,
    output [7:0] S,
    output PG, GG, Cout
    );
    wire carryPipe;
    CLA4 CLA4_0(.Cin(Cin),.A(A[3:0]),.B(B[3:0]),.PG(PG),.GG(GG),.S(S[3:0]),.Cout(carryPipe));  //First 4 bit CLA
    CLA4 CLA4_1(.Cin(carryPipe),.A(A[7:4]),.B(B[7:4]),.PG(PG),.GG(GG),.S(S[7:4]),.Cout(Cout));  //Second 4 bit CLA
    endmodule
    
/*
//4 bit CLA
module CLA4(J,K,Cin,Sum,Cout,GP,GG);
    output [3:0] Sum;
    output Cout,GP,GG;
    input [3:0] J,K;
    input Cin;
    wire [3:0] G,P,C;
    //Partial full adders and 4-bit CLA logic
    assign G = J & K; //Generate
    assign P = J ^ K; //Propagate
    assign S = P ^ C;  //Sum
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout1 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) |(P[3] & P[2] & P[1] & P[0] & C[0]);
    //Group propogate and group generate equations
    assign GP = P[3] & P[2] & P[1] & P[0];  //Group propagate for 4 bit
    assign GG = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);  //Group generate for 4 bit

endmodule

//8 bit CLA; this is the top module if doing an 8 bit
module CLA8(A,B,Cin0,S,Cout2,GP,GG);
    output [7:0] S;
    output Cout2, GP, GG;
    input [7:0] A,B;
    input Cin0;
    wire [7:0] G,P,C;
         //CLA logic combining the 4-bit logic into 8-bit logic
         assign C[0] = Cin;
         assign C[4] = G[0] | (P[0] & C[0]);
         assign Cout2 = G[4] | (G[0] & P[4]) | (C[0] & P[0] & C[0]);
         //Takes in the first bit of P and G from block 1 and the fifth from block 2
         assign GP = P[0] & P[4];  //Group propogate for 8 bit
         assign GG = G[4] | (P[4] & G[0]); //Group generate for 8 bit     
    //Two 4 bit CLAs instantiated 
    CLA4 block1         (A[3:0], B[3:0], Cin0, S[3:0], C[4], P[0], G[0]);  //First 4 bit CLA
    CLA4 block2         (A[7:4], B[7:4], C[4], S[7:4], Cin, P[4], G[4]);  //Second 4 bit CLA
endmodule
*/
  

