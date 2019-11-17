`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2018 02:01:17 PM
// Design Name: 
// Module Name: FIFO
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

module FIFO
  (
    input [7:0]dataIn,
    input clk,enqueue,dequeue,
    output reg full,empty,
    output [7:0]dataOut
  );
  
  // enqueue = "place" and dequeue = "remove"
  
  // Declare State Constants...
  localparam [1:0]
  	EMPTY = 2'b00,
  	USED = 2'b01,
  	FULL = 2'b10;
  
  // Declare Circular Queue...
  reg [7:0]buffer[7:0];
  
  // Declare Registers...
  reg [2:0]head,headNext,tail,tailNext;
  reg [1:0]state,stateNext;
  reg emptyNext,fullNext;
  
  initial
    begin
      head = 'd0;
      tail = 'd0;
      headNext = 'd0;
      tailNext = 'd0;
      state = 'd0;
      stateNext = 'd0;
      full = 0;
      fullNext = 0;
      empty = 1;
      emptyNext = 1;
    end
  
  // Current State Logic...
  always@(posedge clk)
    begin
      state <= stateNext;
      head <= headNext;
      tail <= tailNext;
      full <= fullNext;
      empty <= emptyNext;
    end
  
  // Next State Logic...
  always@*
    begin
      stateNext = state;
      headNext = head;
      tailNext = tail;
      emptyNext = empty;
      fullNext = full;
      
      case(stateNext)
        EMPTY:
          begin
            if(enqueue)
              begin
                tail = (tail[0]+1);
                buffer[head] = dataIn;
                // Finish writing code here...
              end
            else
              stateNext = EMPTY;
          end
        USED:
          begin
            if(enqueue)
              begin
                tail = (tail[0]+1);
                buffer[head] = dataIn;
                // Finish writing code here...
              end
            else if(dequeue)
              begin
                tailNext[1] = buffer[head[0]];
                head = (head[0]+1);
                // Finish writing code here...
              end
            else
                stateNext = USED;
          end
        FULL:
          begin
            if(enqueue)
              stateNext = FULL;
            else if(dequeue)
              begin
                tail = -1;
                head = tailNext;
                // Finish writing code here...
              end
            else
              stateNext = FULL;
          end
      endcase
    end
  
  assign dataOut = buffer[head];
  
endmodule
