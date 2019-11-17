`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2019 06:15:47 PM
// Design Name: 
// Module Name: GCD
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


module GCD(
    input [15:0] SW,
    input Center, CLK100MHZ,
    output [7:0] AN,
    output [6:0] a_to_g,
    output [1:0] LED,
    output [15:0] A, B,  //Testbench only
    output [15:0] Gcd    //Testbench only
    );
    parameter width1 = 100000000;
    parameter width2 = 10000;
    wire Clk_Slow, Clk_Multi, Clk_Slower;
    wire clk = CLK100MHZ;
    wire [7:0]ANhold;
    wire [6:0]a_to_gohold;
    reg [15:0] Gcd;
    ///BCD into decimal places
    wire [3:0] ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10;
    wire [6:0] _ones, _tens, _hundreds, _thousand1, _thousand10, _thousand100, _million, _million10;
    wire [55:0] disarray;
    reg [15:0] A, B, Temp, Rem, Quo; //reenable
    reg [1:0] led;
    reg [1:0] state;
    reg [2:0] STATE, NSTATE;
    Clk_Divide # (width1,width2) In1 (CLK100MHZ, Clk_Slow, Clk_Multi);
    conversion c1(ones, _ones); conversion c6(tens, _tens); conversion c2(hundreds, _hundreds); conversion c3(thousand1, _thousand1); conversion c4(thousand10, _thousand10); conversion c5(thousand100, _thousand100);
    BCD BcdConversion(Gcd, ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10);
    conversion c7(million, _million); conversion c8(million10, _million10); 
    display z1(Clk_Multi, disarray, a_to_gohold, ANhold);
    
    assign disarray = {_million10,_million,_thousand100,_thousand10,_thousand1,_hundreds,_tens,_ones};
    assign LED = led;
    assign AN = ANhold;
    assign a_to_g = a_to_gohold;
    assign gcd = Gcd; //Testbench only
    
    initial begin
    assign led = 0;
    assign A = 16'd270;
    assign B = 16'd192;
    assign state = 0;
    assign STATE = 0;
    assign NSTATE = 0;
    assign Gcd = 15'd0;
    end
    
    /*always @ (posedge Clk_Slow) begin
        case (state[1:0]) 
            2'b00: begin if (Center) begin A [15:0] = SW; end state [1:0] = 2'b01; led [1:0] = state [1:0]; end
            2'b01: begin if (Center) begin B [15:0] = SW; end state [1:0] = 2'b10; led [1:0] = state [1:0]; end
            2'b10: begin if (Center) begin A [15:0] = 0; B = 0; end state [1:0] = 2'b00; led [1:0] = state [1:0]; end
        endcase
    end*/

always @ (posedge Clk_Multi) begin 
STATE = NSTATE;
            case (STATE)
            3'd0:    begin Quo = A / B; NSTATE = 1; end
            3'd1:    begin Rem = A % B; NSTATE = 2; end
            3'd2:    begin Temp = B; NSTATE = 3; end
            3'd3:    begin A = Temp; NSTATE = 4; end
            3'd4:    begin B = Rem; NSTATE = 5; end 
            3'd5:    begin Temp = B; NSTATE =6; end  
            3'd6:    begin if (B)
                     NSTATE = 0; 
                     else NSTATE = 7; end
            3'd7:    Gcd[15:0] = B;
            default: STATE = 7;
            endcase
end
                    
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    
