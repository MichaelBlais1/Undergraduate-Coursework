`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2018 08:46:36 PM
// Design Name: 
// Module Name: BCDconverter
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


// Top Module
module bcd2bin
  (
    input [3:0]bcd2,bcd1,bcd0,
    input clk,start,
    output [9:0]bin
  );
  

  localparam [1:0]
  	idle = 2'b00,
  	conversion = 2'b01,
  	done = 2'b10;
  

  reg [3:0]counter,counterNext,bcd2Temp,bcd1Temp,bcd0Temp;
  reg [11:0]bcdReg,bcdRegNext;
  reg [9:0]binReg,binRegNext;
  reg [1:0]state,nextState;
  

  initial
    begin
      counter = 'd0;		
      counterNext = 'd0;	
      bcdReg = 'd0;
      bcdRegNext = 'd0;
      binReg = 'd0;
      binRegNext = 'd0;
      state = 'd0;
      nextState = 'd0;
    end
  

  always@(posedge clk)
    begin
      state <= nextState;
      bcdReg <= bcdRegNext;
      binReg <= binRegNext;
      counter <= counterNext;
    end
  
  always@*
    begin
      nextState = state;
      bcdRegNext = bcdReg;
      binRegNext = binReg;
      counterNext = counter;
    
      // A case-statement for our 3 states
      case(state)
        
        // Idle state, waits for start signal
        idle:
          begin
            if(start)
              begin
                bcdRegNext[11:0] = {bcd2[3:0],bcd1[3:0],bcd0[3:0]}; // Group the inputs
                counterNext = 4'b1010;	// Get counter ready
                nextState = conversion; // Get next state
              end
          end
        
        conversion:
          begin
            binRegNext=binRegNext>>1;
            binRegNext[9]=bcdRegNext[0];
            bcdRegNext=bcdRegNext>>1;
            

            if(bcdRegNext[11:8] >= 4'b1000)
              begin
                bcd2Temp[3:0]=bcdRegNext[11:8]-4'b0011;
                bcdRegNext={bcd2Temp[3:0],bcdRegNext[7:0]};

              end
            if(bcdRegNext[7:4] >= 4'b1000)
              begin
                bcd1Temp[3:0]=bcdRegNext[7:4]-4'b0011;
                bcdRegNext={bcdRegNext[11:8],bcd1Temp[3:0],bcdRegNext[3:0]};

              end
            if(bcdRegNext[3:0] >= 4'b1000)
              begin
                bcd0Temp[3:0]=bcdRegNext[3:0]-4'b0011;
                bcdRegNext={bcdRegNext[11:4],bcd0Temp[3:0]};
       
              end
            
            counterNext = counterNext - 1; // Decrement counterNext
            
            // When last conversion shift is encountered, 
            // go to the next state 
            if(counterNext == 0)
              begin
                nextState = done;
              end
          end
        
        // Finished state, go back to idle
        done:
          begin
            nextState = idle;
          end
      endcase
    end
  
  // This links the output "bin" to the value of the binReg register
  assign bin = binReg;
  
endmodule
