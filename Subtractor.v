`timescale 1ns / 1ps
/////////////////////////////////////////////////////////
///////////ALU control top module////////////////////////
/////////////////////////////////////////////////////////  
module Subtractor(
    input [15:0] SW,
    input Center,
    output [7:0] AN,
    output [6:0] a_to_g,
    output [3:0] LED,
    input CLK100MHZ
    //output [15:0] A, //testbench only
    //output [15:0] B, //testbench only
    //output [26:0] binary //testbench only
);
parameter width1 = 100000000;
parameter width2 = 10000; 
wire Clk_Slow, Clk_Multi, Clk_Slower;
wire [7:0]ANhold;
wire [6:0]a_to_gohold;
wire clk = CLK100MHZ;
reg [26:0] binary;
///BCD into decimal places
wire [3:0] ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10;
wire [6:0] _ones, _tens, _hundreds, _thousand1, _thousand10, _thousand100, _million, _million10;
wire [55:0] disarray;
reg [15:0] A,B; //reenable
reg [3:0] led;
reg [1:0] Sel;

integer x;
wire [26:0] addition_total;
wire [26:0] subtraction_total;
wire [15:0] shift_total;

initial begin
//A = 16'b0101001100100011; //21283
//B = 16'b0001000011011000; //4312
A = 0; //testbenchonly
B = 0; //testbenchonly
binary = 0;
ABSRes = 2'b00;
end
reg [1:0] ABSRes;
always @ (posedge Clk_Slow) begin
case (ABSRes)
2'b00: begin if (Center) begin Sel[1:0] = SW[1:0]; end ABSRes = 2'b01; end
2'b01: begin if (Center) begin A[15:0] = SW[15:0]; end ABSRes = 2'b10; end
2'b10: begin if (Center) begin B[15:0] = SW[15:0]; end ABSRes = 2'b11; end
2'b11: begin if (Center) begin Sel[1:0] = 0; A[15:0] = 0; B[15:0] = 0; end ABSRes = 2'b00; end
endcase
end

always @ (Sel) begin
case (Sel)
2'b00: begin
binary = addition_total;
led [3:0] = 4'b0001;
end
2'b01: begin
binary = subtraction_total;
led [3:0] = 4'b0010;
end
2'b10: begin
binary = A*B;
led [3:0] = 4'b0100;
end
2'b11: begin
binary = shift_total;
led [3:0] = 4'b1000;
end
default: binary = A+B;
endcase
end

Adder_16 add1(A,B,1'b0,addition_total);
Adder_16 sub1(A,~B+1,1'b0,subtraction_total);
Right_Shift RS1(A,shift_total);


///call BCD to convert calculated # to binary coded decimal
BCD x1(binary, ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10);
///call to convert binard coded decimal # to 7 segment code
conversion c1(ones, _ones); conversion c6(tens, _tens); conversion c2(hundreds, _hundreds); conversion c3(thousand1, _thousand1); conversion c4(thousand10, _thousand10); conversion c5(thousand100, _thousand100);
conversion c7(million, _million); conversion c8(million10, _million10); 
///combine all 7 segment codes into one array for easier handling
assign disarray = {_million10,_million,_thousand100,_thousand10,_thousand1,_hundreds,_tens,_ones};

assign LED = led;
assign AN = ANhold;
assign a_to_g = a_to_gohold;

//call to display module that multiplexes each digit changed with slower clock signal
display z1(Clk_Multi, disarray, a_to_gohold, ANhold);

//call to clock slow down module for multiplexed display clk pulse
Clk_Divide # (width1,width2) In1 (CLK100MHZ, Clk_Slow, Clk_Multi);

endmodule  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///module to take array of 7seg coded array, multiplex using slow clock, and display on 7segment displays/////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module display(input Clk_multi,
input [55:0] disarray,
output reg [6:0] a_to_g,
output reg [7:0] cathode
);
reg [3:0]count;

always @ (posedge Clk_multi) begin
case (count)

4'b0000: begin
a_to_g = disarray [6:0];
cathode = 8'b11111110;
count = count + 1;
end

4'b0001: begin
a_to_g = disarray [13:7];
cathode = 8'b11111101;
count = count + 1;
end

4'b0010: begin
a_to_g = disarray [20:14];
cathode = 8'b11111011;
count = count + 1;
end

4'b0011: begin
a_to_g = disarray [27:21];
cathode = 8'b11110111;
count = count + 1;
end

4'b0100: begin
a_to_g = disarray [34:28];
cathode = 8'b11101111;
count = count + 1;
end

4'b0101: begin
a_to_g = disarray [41:35];
cathode = 8'b11011111;
count = count + 1;
end

4'b0110: begin
a_to_g = disarray [48:42];
cathode = 8'b10111111;
count = count + 1;
end

4'b0111: begin
a_to_g = disarray [55:49];
cathode = 8'b01111111;
count = count + 1;
end

default: count = 4'b0000;
endcase
end

endmodule
///////////////////////////////////////////////////////////////////////////////////////////////
//////////////////Convert binary to Binary Coded Decimal///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
module BCD(
input [26:0] binary,
output reg [3:0] ones,
output reg [3:0] tens,
output reg [3:0] hundreds,
output reg [3:0] thousand1,
output reg [3:0] thousand10,
output reg [3:0] thousand100,
output reg [3:0] million,
output reg [3:0] million10
);

integer i;

always @ (binary) begin

ones = 4'b0000; tens = 4'b0000; hundreds = 4'b0000; thousand1 = 4'b0000; thousand10 = 4'b0000; thousand100 = 4'b0000; million = 4'b0000; million10 = 4'b0000;

for (i=26;i>=0;i=i-1) begin
if (million10 >= 4'b0101)
    million10 = million10 + 3;
if (million >= 4'b0101)
        million = million + 3;
if (thousand100 >= 4'b0101)
        thousand100 = thousand100 + 3;
if (thousand10 >= 4'b0101)
        thousand10 = thousand10 + 3;
if (thousand1 >= 4'b0101)
        thousand1 = thousand1 + 3;
if (hundreds >= 4'b0101)
        hundreds = hundreds + 3;
if (tens >= 4'b0101)
        tens = tens + 3;
if (ones >= 4'b0101)
        ones = ones + 3;

million10 = million10 << 1;
million10[0] = million[3];

million = million << 1;
million[0] = thousand100[3];

thousand100 = thousand100 << 1;
thousand100[0] = thousand10[3];

thousand10 = thousand10 << 1;
thousand10[0] = thousand1[3];

thousand1 = thousand1 << 1;
thousand1[0] = hundreds[3];

hundreds = hundreds << 1;
hundreds[0] = tens[3];

tens = tens << 1;
tens[0] = ones[3];

ones = ones << 1;
ones[0] = binary[i];
end
//this section gets rid of leading zeros
if (million10 == 4'b0000) begin million10 = 4'b1111;
    if (million == 4'b0000) begin million = 4'b1111;
        if (thousand100 == 4'b0000) begin thousand100 = 4'b1111;
            if (thousand10 == 4'b0000) begin thousand10 = 4'b1111;
                if (thousand1 == 4'b0000) begin thousand1 = 4'b1111;
                    if (hundreds == 4'b0000) begin hundreds = 4'b1111;
                        if (tens == 4'b0000) begin tens = 4'b1111;
                            if (ones == 4'b0000) begin ones = 4'b1111;
end
    end
        end
            end
                end
                    end
                        end
                            end
end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////
//////Module to convert BCD # to LED coded number////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
module conversion(
    input [3:0]number,
    output reg [6:0]led
    );   
    
    always @(number[3:0]) begin
        case (number[3:0])
            4'b0000: led = ~(7'b0111111);
            4'b0001: led = ~(7'b0000110);
            4'b0010: led = ~(7'b1011011);
            4'b0011: led = ~(7'b1001111);
            4'b0100: led = ~(7'b1100110);
            4'b0101: led = ~(7'b1101101);
            4'b0110: led = ~(7'b1111101);
            4'b0111: led = ~(7'b0000111);
            4'b1000: led = ~(7'b1111111);
            4'b1001: led = ~(7'b1101111);
            4'b1111: led = ~(7'b0000000);
        endcase
    end   
       
endmodule
////////////////////////////////////////////////////////////////////////
///module to create slower clock signal for display multiplex///////////
////////////////////////////////////////////////////////////////////////
module Clk_Divide (Clk, Clk_Slow, Clk_multi,Clk_Slower);
input Clk;
output Clk_Slow,Clk_multi,Clk_Slower;
reg Clk_Slow;
reg Clk_multi;
reg Clk_Slower;

parameter size1 = 100000000;
parameter size2 = 10000;
reg [31:0] counter_out1, counter_out2, counter_out3;
	initial begin	//Note this will synthesize because we are using an FPGA and not making an IC
	counter_out1<= 32'h00000000;
	counter_out2<= 32'h00000000;
	counter_out3<= 32'h00000000;
	Clk_Slow  <= 1'b0;
	Clk_multi <= 1'b0;
    Clk_Slower <= 1'b0;
	end
always @(posedge Clk) begin
	counter_out1<=    counter_out1 + 32'h00000016;
	counter_out2<=    counter_out2 + 32'h00000001;
	counter_out3<=    counter_out3 + 32'h00000002;
	if (counter_out1  > size1) begin
		counter_out1<= 32'h00000000;
		Clk_Slow <= !Clk_Slow;
	end
    if (counter_out2  > size2) begin
       counter_out2<= 32'h00000000;
       Clk_multi <= !Clk_multi;
    end
        if (counter_out3  > size1) begin
       counter_out3<= 32'h00000000;
       Clk_Slower <= !Clk_Slower;
    end
end
endmodule
//////////////////////////////////////////////////////////////////
/////Module for addition and subtraction//////////////////////////
//////////////////////////////////////////////////////////////////
module Adder_16 (input  [15:0] a, b, input cin,
                 output [15:0] sum, output cout);
  wire [16:0] c;	    // carry bits
  assign c[0] = cin;	// carry input
  assign cout = c[16];	// carry output
  Full_Adder adder [15:0] (a[15:0], b[15:0], c[15:0], c[16:1], sum[15:0]);
endmodule
module Full_Adder(input a, b, c, output cout, sum);
  wire w1, w2, w3;
  and (w1, a, b);
  xor (w2, a, b);
  and (w3, w2, c);
  xor (sum, w2, c);
  or  (cout, w1, w3);
endmodule
////////////////////////////////////////////////////////////////
////Module to right shift input number//////////////////////////
////////////////////////////////////////////////////////////////
module Right_Shift(input [15:0] a, output [15:0] c);
reg [15:0] c_1;

always @ (a) begin
c_1 <= a;
c_1 [0] <= a [1];
c_1 [1] <= a [2];
c_1 [2] <= a [3];
c_1 [3] <= a [4];
c_1 [4] <= a [5];
c_1 [5] <= a [6];
c_1 [6] <= a [7];
c_1 [7] <= a [8];
c_1 [8] <= a [9];
c_1 [9] <= a [10];
c_1 [10] <= a [11];
c_1 [11] <= a [12];
c_1 [12] <= a [13];
c_1 [13] <= a [14];
c_1 [14] <= a [15];
c_1 [15] <= 1'b0; 
end

assign c = c_1;

endmodule


