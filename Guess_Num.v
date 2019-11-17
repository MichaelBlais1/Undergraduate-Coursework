//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2018 05:17:33 PM
// Design Name: 
// Module Name: Guess_Num
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



`timescale 1ms/1ns
//Main module
module Guess_Num(
	input Center, Down, CLK,
	input [15:0]SW,
	output reg [15:0]LED,
	output [7:0]SSEG_CA,
	output [7:0]SSEG_AN
	);
	
	wire CLK_1K;
	Clock_1k CLK1K(CLK, CLK_1K);  //Instantiate 1k clock
	
	wire [7:0] randSSEG[3:0]; //Converted random numbers to SSEG compatible, so they can be displayed
	convert converter0(randstore[0], randSSEG[0]);  //Instantiate the convert module once per random number digit
	convert converter1(randstore[1], randSSEG[1]);
	convert converter2(randstore[2], randSSEG[2]);
	convert converter3(randstore[3], randSSEG[3]);
	
	wire CLK_Slow;
	Clock_Slow CLKSLOW(CLK_1K, CLK_Slow);  //Instantiate slow clock
	
	wire CLK_Scroll;
	Clock_Scroll ClockScroll(CLK, CLK_Scroll);  //Instantiate scroll clock
	
	wire [3:0] randgen[3:0]; //Grabs the output from random generator
	reg [3:0] randstore[3:0]; //Holds the output from the random generator for a game
	Random RANDOM(CLK_Slow, CLK, randgen[3], randgen[2], randgen[1], randgen[0]);  //Instantiate random number generator

	reg [7:0] dig[7:0];
	Display_7seg display(dig[0], dig[1], dig[2], dig[3], dig[4], dig[5], dig[6], dig[7], CLK_1K, SSEG_CA, SSEG_AN);  //Array of digits
	
	reg [2:0] state;  //For state machine
	
	reg [2:0] guessNum; //Increments after each guess
	reg [3:0] guessDig; //The number pulled from the switches used for guessing
    reg [3:0] last_guessDig; //The previous guess
	wire [7:0] guessSSEG; //guessDig in cathode form
	convert guessconvert(guessDig, guessSSEG);
	reg [2:0] randNum;  //current random number being guessed
	
	reg [4:0] i;  //Holds switch flipped for guess
	reg [3:0] x;  //Position of random number, used for scrolling
	reg [3:0] x2; //Used to point to x in case statement
	reg [3:0] y;  //Position of guess, used for scrolling
	reg [3:0] y2; //Used to point to y in case statement
	
	reg [7:0] digScroll [7:0];  //Register for scrolling the random number  
	reg [7:0] digGuess [7:0];   //Register for scrolling the guesses	
	reg scrollSig;
	reg [31:0]counterScroll;
    reg fastScroll, delayLED, scrollCorrect;
	
    initial begin  //Initialize the inputs
	state = 3'b000;
  
    scrollCorrect = 1'b0;
    scrollSig = 1'b0;	
	x2 = 4'b0000;
	y2 = 4'b0000;
	
    guessNum = 3'b000;
    randNum = 3'b000;
    
    dig[0] = 8'b11111111;  //Blank out the SSEG display
    dig[1] = 8'b11111111;
    dig[2] = 8'b11111111;
    dig[3] = 8'b11111111;
    dig[4] = 8'b11111111;
    dig[5] = 8'b11111111;
    dig[6] = 8'b11111111;
    dig[7] = 8'b11111111;
    
    digGuess[0] = 8'b11111111;
    digGuess[1] = 8'b11111111;
    digGuess[2] = 8'b11111111;
    digGuess[3] = 8'b11111111;
    digGuess[4] = 8'b11111111;
    digGuess[5] = 8'b11111111;
    digGuess[6] = 8'b11111111;
    digGuess[7] = 8'b11111111;
    end
	
	
	always @ (posedge CLK) begin
        counterScroll <= counterScroll + 32'h00000001;
        fastScroll <= counterScroll[28];  
        delayLED <= counterScroll[30];  //Set up LED delay
    end
    
    	always @ (posedge CLK_Slow) begin  //Set up displayed guesses to scroll from left to right
        if(!scrollCorrect)
            y = 4'b0000;
        if(scrollCorrect) begin
            digGuess[y-4'b0111] = 8'b11111111;
            digGuess[y-4'b0110] = 8'b11111111;  
            digGuess[y-4'b0101] = 8'b11111111;                        
            digGuess[y-4'b0100] = 8'b11111111;
            digGuess[y-4'b0011] = 8'b11111111;
            digGuess[y-4'b0010] = 8'b11111111;  
            digGuess[y-4'b0001] = 8'b11111111;
            digGuess[y]         = guessSSEG;            
            y = y + 4'b0001;
        end
    end    
    
    	always @ (posedge CLK_Scroll) begin
        if (!scrollSig)
            x = 4'b0000;    
        if(scrollSig) begin
            //Scroll the random number
            digScroll[x-4'b1000] = 8'b11111111;  //Scroll blank segments
            digScroll[x-4'b0111] = 8'b11111111;
            digScroll[x-4'b0110] = 8'b11111111;  
            digScroll[x-4'b0101] = 8'b11111111;                        
            
            digScroll[x-4'b0100] = randSSEG[0];  //Scroll random number 
            digScroll[x-4'b0011] = randSSEG[1];
            digScroll[x-4'b0010] = randSSEG[2];  
            digScroll[x-4'b0001] = randSSEG[3];
                                  
            digScroll[x]         = 8'b11111111;  //Then scroll blank segments in as the random number scrolls off the display
            digScroll[x+4'b0001] = 8'b11111111;
            digScroll[x+4'b0010] = 8'b11111111;
            digScroll[x+4'b0011] = 8'b11111111;                          
            digScroll[x+4'b0100] = 8'b11111111;
            digScroll[x+4'b0101] = 8'b11111111;
            digScroll[x+4'b0110] = 8'b11111111;  
            digScroll[x+4'b0111] = 8'b11111111;         
            x = x + 4'b0001;
                        
        end
    end
    
    
	always @ (posedge CLK) begin
		case (state)
		
			3'b000: begin //Initial state, wait for button, scroll and proceed once pressed
				if(!scrollSig) begin
				randstore[0] = randgen[0];
				randstore[1] = randgen[1];
				randstore[2] = randgen[2];
				randstore[3] = randgen[3];
				end
				
				if (Center) begin
					scrollSig = 1'b1;
					x2 = 4'b0000;
				end
				if (scrollSig) begin

					   dig[0] = digScroll[0];
					   dig[1] = digScroll[1];
					   dig[2] = digScroll[2];
					   dig[3] = digScroll[3];
					   dig[4] = digScroll[4];
					   dig[5] = digScroll[5];
					   dig[6] = digScroll[6];
					   dig[7] = digScroll[7];

                       x2 = x;    
					   if (x2 ==  4'b1101) begin
                          guessNum = 3'b000;
                          randNum = 3'b000;
                          
                          LED = 16'b0000000000000000;
                          
                          state = 3'b001;
					end
				end	
			end
			
			3'b001: begin //Waiting for player guesses
				scrollSig = 1'b0;
				scrollCorrect = 1'b0;
				last_guessDig = guessDig;
				
				if (Down) begin
					for (i = 5'b00000 ; i < 5'b10000 ; i = i + 5'b00001) begin
						if(SW[i]) 
						  guessDig = i[3:0];
					end
				
					if (guessDig == randstore[randNum])
						state = 3'b100;
					else if (guessDig != last_guessDig) //Fix problem with false positives
						state = 3'b010;
				end
			end
			
			3'b010: begin //Incorrect guess
			
			    guessNum = guessNum + 3'b001;
				//Scroll value to next empty space using guessNum
				dig[4-guessNum] = guessSSEG;
				
				// led for higher or lower
				if (guessDig < randstore[randNum]) begin
					LED = 16'b0000000000000001;  //If guess is lower, flash right LED
				end
				else begin
					LED = 16'b1000000000000000;  //If guess is higher, flash left LED
				end //end higher or lower

				if (guessNum == 3'b100) 
					state = 3'b011;  //If guess is correct, go to state 4 for correct guess
				else
					state = 3'b001;  //If guess is wrong, go to state 1 to receive another guess
					
			end
			
			3'b011: begin //4 incorrect guesses	
				//SHOW ACTUAL RANDOM NUMBERS IN LOWER 4//
				//WAIT 3 SECONDS AND CHANGE UPPER 4 TO F000//
				
                dig[4] = randSSEG[0];
                dig[5] = randSSEG[1];
                dig[6] = randSSEG[2];
                dig[7] = randSSEG[3];
            
                // after 3 sec show F000 in upper display
                if (delayLED) begin
                dig[0] = 8'b10001110;
                dig[1] = 8'b11000000;
                dig[2] = 8'b11000000;
                dig[3] = 8'b11000000;
				end
				
				if (Center)
				    state = 3'b000;
			end
			
			3'b100: begin //Correct guess

				LED = 16'b1111111111111111;
			    				
			    //Reset guess digits
			    if(!scrollCorrect) begin
                dig[0] = 8'b11111111;
                dig[1] = 8'b11111111;
                dig[2] = 8'b11111111;
                dig[3] = 8'b11111111;
                end
                scrollCorrect = 1'b1;
				//Scroll the value to the correct slot
				if (scrollCorrect) begin

                dig[0] = digGuess[0];
                dig[1] = digGuess[1];
                dig[2] = digGuess[2];
                dig[3] = digGuess[3];
                dig[4] = digGuess[4];
                dig[5] = digGuess[5];
                dig[6] = digGuess[6];
                dig[7] = digGuess[7];

                y2 = y;
                if (randNum == 3'b001)
                    dig[4] = randSSEG[0];
                if (randNum == 3'b010) begin
                    dig[4] = randSSEG[0];   
                    dig[5] = randSSEG[1];
                end
                if (randNum == 3'b011) begin
                    dig[4] = randSSEG[0];   
                    dig[5] = randSSEG[1];    
                    dig[6] = randSSEG[2];
                end    
                
                if(y2 == (randNum + 4'b0101)) begin
                y2 = 4'b0000;
                if (guessDig != last_guessDig) 
                    randNum = randNum + 3'b001;
                guessNum = 3'b000;   
                if (randNum == 3'b100) begin
                    dig[4] = randSSEG[0];
                    dig[5] = randSSEG[1];   
                    dig[6] = randSSEG[2];    
                    dig[7] = randSSEG[3];
                    state = 3'b101;
                    end
                else
                    state = 3'b001;
                end            
                end
			end
			
			3'b101: begin //4 correct guesses
				          //Flash all LED if win
				scrollCorrect = 1'b0;
				if (CLK_Slow)
                    LED = 16'b1111111111111111;
                else
                    LED = 16'b0000000000000000;
                
				if (Center)
					state = 3'b000;
			end			
		endcase
	end		
endmodule 

module convert(  //This module converts the random numbers to SSEG display compatible                 
	input [3:0]value,
	output reg [7:0]out
	);
	
	always @ (value) begin
	
	   case (value)
	       4'b0000 : out = 8'b11000000;
	       4'b0001 : out = 8'b11111001;
	       4'b0010 : out = 8'b10100100;
	       4'b0011 : out = 8'b10110000;
	       4'b0100 : out = 8'b10011001;
	       4'b0101 : out = 8'b10010010;
	       4'b0110 : out = 8'b10000010;
	       4'b0111 : out = 8'b11111000;
	       4'b1000 : out = 8'b10000000;
	       4'b1001 : out = 8'b10011000;
	       4'b1010 : out = 8'b10001000;
	       4'b1011 : out = 8'b10000011;
	       4'b1100 : out = 8'b11000110;
	       4'b1101 : out = 8'b10100001;
	       4'b1110 : out = 8'b10000110;
	       4'b1111 : out = 8'b10001110;
	   endcase             
    end	
endmodule

module Random (
  input CLK_Slow, CLK,
  output reg [3:0]Rand0,
  output reg [3:0]Rand1,
  output reg [3:0]Rand2,
  output reg [3:0]Rand3
  );
  reg [31:0] counter;
  reg [15:0]Rand;
  always@(posedge CLK_Slow)
    begin
      counter = counter + 32'h000012FC;
      Rand = counter[15:0];
      Rand0 = Rand[3:0];
      Rand1 = Rand[7:4];
      Rand2 = Rand[11:8];
      Rand3 = Rand[15:12];   
    end
endmodule


//7-segment display
module Display_7seg(
    input [7:0] digit1, //Leftmost digit
	input [7:0] digit2, 
	input [7:0] digit3,
	input [7:0] digit4,
	input [7:0] digit5,
	input [7:0] digit6,
	input [7:0] digit7,
	input [7:0] digit8, //Rightmost digit
    input clock,
    output reg [7:0] ca,
    output reg [7:0] an);
    
    always @ (posedge clock) begin
		case(an) //scroll through 7-seg digits
			8'b01111111 : an = 8'b10111111;
			8'b10111111 : an = 8'b11011111;
			8'b11011111 : an = 8'b11101111;
			8'b11101111 : an = 8'b11110111;
			8'b11110111 : an = 8'b11111011;
			8'b11111011 : an = 8'b11111101;
			8'b11111101 : an = 8'b11111110;
			8'b11111110 : an = 8'b01111111;
			default : an = 8'b01111111;
		endcase

		//Set non-blank digits
		if (an == 8'b01111111)
			ca = digit1;
		if (an == 8'b10111111)
			ca = digit2;
		if (an == 8'b11011111)
			ca = digit3;
		if (an == 8'b11101111)
			ca = digit4;
		if (an == 8'b11110111)
			ca = digit5;
		if (an == 8'b11111011)
			ca = digit6;
		if (an == 8'b11111101)
			ca = digit7;
		if (an == 8'b11111110)
			ca = digit8;		
	end	
endmodule 


//1K Clock
module Clock_1k(
    input clock,
    output reg CLK_1k);

        reg [31:0] counter_out, count;
        initial begin
                counter_out<= 32'h00000000;
                count<= 32'h00000000;
        end

        always @(posedge clock) begin
                counter_out<=    counter_out + 32'h00000001;
                if(counter_out > 32'h000186A0)
                begin
                        counter_out<= 32'h00000000;
                        CLK_1k <= !CLK_1k;
                        end
                end
endmodule 


//Slow clock
module Clock_Slow(
	input CLK_1k,
	output reg CLK_Slow);
	
reg [31:0] counter_out, count;
initial begin
	counter_out<= 32'h00000000;
	count<= 32'h00000000;
	CLK_Slow <=0;
end
	
always @(posedge CLK_1k) begin
	count = count + 32'h00000001;
	if( count > 32'h000000E8) begin
		count <= 32'h00000000;
		CLK_Slow <= ! CLK_Slow;
	end
end

endmodule 

//Scroll clock
module Clock_Scroll(
    input clock,
    output reg CLK_Scroll);

        reg [31:0] countout,count;
        initial begin
                countout<= 32'h00000000;
                count<= 32'h00000000;
        end

        always @(posedge clock) begin
                countout<=    countout + 32'h00000001;
                if(countout > 32'h0010FFFF)
                begin
                countout<= 32'h00000000;
                CLK_Scroll <= !CLK_Scroll;
                end
                end
endmodule




























