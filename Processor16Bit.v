`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
module ProgramCounterReg(
input Clk,
input Up,
input Clr,
input Ld,
input [15:0] Sum,
output reg [7:0] PCout);
//Code goes here
reg [15:0] SumIn;
initial begin
    PCout = 0;
end
always @ (posedge Clk) begin
    if (Clr) PCout = 0;
    else if (Up) PCout = PCout + 1'b1;
    else if (Ld) PCout = PCout + Sum;
   end
endmodule
//////////////////////////////////////////////////////////////////////////
//Triggered each time an instruction is loaded
module ControlReg(
input Clk,
input Ld,
input [15:0] Ir,
output reg [15:0] DataOut);
//Code goes here, a D-FF should work
initial begin
    DataOut = 0;
end
always @ (posedge Clk) begin
    if (Ld) DataOut = Ir;
end
endmodule
//////////////////////////////////////////////////////////////////////////
//Used to advance the PC only a jump instruction is loaded
module AdvanceProgramCounter(
input [7:0] FromPC,
input [7:0] FromControlReg,  //From IR
output [15:0] ToPcSum);
//Out = a + b - 1
assign ToPcSum = (FromPC + FromControlReg) - 1; 
endmodule
//////////////////////////////////////////////////////////////////////////
module Controller(
input Clk,
input [7:0] FromControlReg,
input [15:0] Instruction,
input IsZero,
output reg UpPC,                //PC_inc
output reg ClrPC,               //PC_clr
output reg LdPC,                //PC_ld
output reg SelDAddress,         //D_addr_sel
output reg [7:0] DAddress,      //D_addr
output reg ToCtrlReg,           //IR_ld
output reg RdDReg,              //D_rd
output reg WdDReg,              //D_wr
output reg [7:0] ToRFWriteData, //RF_W_data
output reg [3:0] ToWAddress,    // RF_W_addr
output reg [3:0] ToRpAddress,   //RF_Rp_addr
output reg [3:0] ToRqAddress,   //RF_Rq_addr
output reg ToWWrite,            //W_wr
output reg ToRpRead,            //Rp_rd
output reg ToRqRead,            //Rq_rd
output reg [2:0] SelALU,        //alu_s
output reg RFSelS0,             //RF_s0
output reg RFSelS1);            //RF_s1
//Code goes here
initial begin
    SelALU = 0;                       ToWAddress = 0; 
    ToRpAddress = 0;                  ToRqAddress = 0; 
    UpPC = 0;                         ClrPC = 0;                 
    LdPC = 0;                         ToWWrite = 0; 
    ToRpRead = 0;                     ToRqRead = 0;          
    SelDAddress = 0;                  DAddress = 0; 
    ToCtrlReg = 0;                    RFSelS0 = 0;
    RFSelS1 = 0;                      RdDReg = 0; 
    WdDReg = 0;                       ToRFWriteData = 0;   
end
always @ (posedge Clk) begin
    case (Instruction[15]) //Case zero applies to all ALU operations
    1'b0: begin SelALU = Instruction[14:12];      ToWAddress = Instruction[11:8]; 
                ToRpAddress = Instruction[7:4];   ToRqAddress = Instruction[3:0]; 
                UpPC = 1;                         ClrPC = 0;                 
                LdPC = 0;                         ToWWrite = 1; 
                ToRpRead = 1;                     ToRqRead = 1;          
                SelDAddress = 0;                  DAddress = 0; 
                ToCtrlReg = 1;                    RFSelS0 = 0;
                RFSelS1 = 0;                      RdDReg = 0; 
                WdDReg = 0;                       ToRFWriteData = 0; 
                end
    4'b1: case(Instruction[14:12])
          //LI
          3'b000: begin SelALU = 0;                       ToWAddress = Instruction[11:8]; 
                        ToRpAddress = 0;                  ToRqAddress = 0; 
                        UpPC = 1;                         ClrPC = 0;                 
                        LdPC = 0;                         ToWWrite = 1; 
                        ToRpRead = 0;                     ToRqRead = 0;          
                        SelDAddress = 1;                  DAddress = 0; 
                        ToCtrlReg = 1;                    RFSelS0 = 0;
                        RFSelS1 = 1;                      RdDReg = 0; 
                        WdDReg = 0;                       ToRFWriteData = Instruction[7:0]; 
                        end
          //LW
          3'b001: begin SelALU = 0;                       ToWAddress = Instruction[11:8]; 
                        ToRpAddress = 0;                  ToRqAddress = 0; 
                        UpPC = 1;                         ClrPC = 0;                 
                        LdPC = 0;                         ToWWrite = 1; 
                        ToRpRead = 0;                     ToRqRead = 0;          
                        SelDAddress = 1;                  DAddress = Instruction[7:0]; 
                        ToCtrlReg = 1;                    RFSelS0 = 1;
                        RFSelS1 = 0;                      RdDReg = 1; 
                        WdDReg = 0;                       ToRFWriteData = 0; 
                        end
          //SW
          3'b010: begin SelALU = 0;                       ToWAddress = 0; 
                        ToRpAddress = Instruction[11:8];  ToRqAddress = 0; 
                        UpPC = 1;                         ClrPC = 0;                 
                        LdPC = 0;                         ToWWrite = 0; 
                        ToRpRead = 1;                     ToRqRead = 0;          
                        SelDAddress = 1;                  DAddress = Instruction[7:0]; 
                        ToCtrlReg = 1;                    RFSelS0 = 1;
                        RFSelS1 = 0;                      RdDReg = 0; 
                        WdDReg = 1;                       ToRFWriteData = Instruction[7:0]; 
                        end
          endcase 
    endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////
module ControlUnit(
input Clk,
input [15:0] DataIn,
input [15:0] Instruction,
input IsZero,
output SelDAddress,
output [7:0] DAddress,
output RdDReg,
output WdDreg,
output [7:0] ToRFWriteData,
output [3:0] ToWAddress,
output [3:0] ToRpAddress,
output [3:0] ToRqAddress,
output ToWWrite,
output ToRpRead,
output ToRqRead,
output [2:0] SelALU,
output [7:0] PCOut,
output RFSelS0,
output RFSelS1);
wire [15:0] PCSum;
wire [7:0] PCout;
wire PCup;
wire PCclr;
wire PCld;
wire CtrlRegLd;
wire [15:0] CtrlRegToCtrl;
wire [7:0] CtrlRegToAdvPC;
assign CtrlRegToAdvPC = CtrlRegToCtrl [7:0];
assign PCOut = PCout;
//Instantiate Control Unit sub modules
ProgramCounterReg PC(.Clk(Clk),.Up(PCup),.Clr(PCclr),.Ld(PCld),.Sum(PCSum),.PCout(PCout));
AdvanceProgramCounter SUM(.FromPC(PCout),.FromControlReg(CtrlRegToAdvPC),.ToPcSum(PCSum));
ControlReg IR(.Clk(Clk),.Ld(CtrlRegLd),.Ir(DataIn),.DataOut(CtrlRegToCtrl));
Controller CONTROL(.Clk(Clk),.FromControlReg(CtrlRegToAdvPC),.IsZero(IsZero),.UpPC(PCup),.ClrPC(PCclr),.LdPC(PCld),.Instruction(Instruction),
 .SelDAddress(SelDAddress),.ToCtrlReg(CtrlRegLd),.RdDReg(RdDReg),.WdDReg(WdDreg),.ToRFWriteData(ToRFWriteData),.ToWAddress(ToWAddress),
 .ToRpAddress(ToRpAddress),.ToRqAddress(ToRqAddress),.ToWWrite(ToWWrite),.ToRpRead(ToRpRead),.ToRqRead(ToRqRead),.SelALU(SelALU),
 .RFSelS0(RFSelS0),.RFSelS1(RFSelS1),.DAddress(DAddress));
//Code goes here
endmodule
//////////////////////////////////////////////////////////////////////////
//Selects the source for the address in which to store data in the D reg
module Mux8Bit(
input Sel,
input [7:0] In0,
input [7:0] In1,
output reg [7:0] Out);
 //Code goes here
 initial begin
    Out = 0;
end
always @ (Sel or In0 or In1) begin
    case (Sel)
    1'b0: Out = In0;
    1'b1: Out = In1;
    endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////
module DRegister(
input Clk,
input [7:0] FromAddressSel,
input ReadEnable,
input WriteEnable,
input [15:0] WriteData,
output [15:0] ReadData);
//Code goes here 256 x 16 bit memory
reg  [15:0] RAM [255:0];
reg [15:0] Read;
assign ReadData = Read;
assign ReadData = RAM[FromAddressSel];
initial begin
    Read = 0;
end
always @(posedge Clk) begin       
    case ({ReadEnable,WriteEnable})
        2'b00: RAM[FromAddressSel] <= 0;
        2'b01: RAM[FromAddressSel] <= WriteData;
        2'b10: Read <= RAM[FromAddressSel];
    endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////
module Mux16Bit(
input Clk,
input S0,
input S1,
input [15:0] In0, 
input [15:0] In1, 
input [7:0] In2,
output reg [15:0] Out);
wire [7:0] UnSignedIn;
wire [15:0] SignedOut;
SignExtender SignExt(.Unextended(UnSignedIn),.Extended(SignedOut),.Clk(Clk));
assign UnSignedIn = In2;
//Code goes here
always @ (posedge Clk) begin
    case ({S1,S0}) 
        2'b00: Out = In0;
        2'b01: Out = In1;
        2'b10: Out = SignedOut;
        endcase
     end
endmodule
//////////////////////////////////////////////////////////////////////////
module RFRegister(
input Clk,
input [15:0] WriteData,
input [3:0] WAddress,
input [3:0] RpAddress,
input [3:0] RqAddress,
input WriteEnable,
input RpReadEnable,
input RqReadEnable,
output reg [15:0] ReadPData,
output reg [15:0] ReadQData,
output [15:0] InMemAtWAddress);
//Code goes here 16 x 16 bit memory
reg [15:0] RAM [15:0];
integer A, B, W;
assign InMemAtWAddress = RAM[WAddress]; 
initial begin
    ReadPData = 0;
    ReadQData = 0;
end
always @ (posedge Clk) begin
    A = RpAddress;
    B = RqAddress;
    W = WAddress;
    case ({WriteEnable,RpReadEnable,RqReadEnable})
        3'b000: begin RAM[W] = 0; RAM[A] = 0; RAM[B] = 0; end  //Reset 
        3'b100: RAM[W] = WriteData;
        3'b010: ReadPData = RAM[A][11:0];
        3'b011: begin ReadPData = RAM[A][11:0]; ReadQData = RAM[B][11:0]; end
        3'b111: begin RAM[W] = WriteData; ReadPData = RAM[A][11:0]; ReadQData = RAM[B][11:0]; end
        default: begin ReadPData = 0; ReadQData = 0; end
        endcase
          
    end
endmodule
//////////////////////////////////////////////////////////////////////////
module SignExtender(
  input [7:0] Unextended,
  input Clk,
  output reg [15:0] Extended 
);
always@(posedge Clk)
  begin 
    Extended <= $signed(Unextended);
  end
endmodule
//////////////////////////////////////////////////////////////////////////
module IsZero(
input [15:0] DataIn,
output reg DataIsZero);
 always @ (DataIn) begin
  if (DataIn == 0) DataIsZero = 1'b1;
  else DataIsZero = 1'b0;
 end
endmodule
//////////////////////////////////////////////////////////////////////////
//The excution unit is active for the first eight instructions only.
module ExecutionUnit(
input [15:0] A,  //Connects to P Data
input [15:0] B,  //Connects to Q Data
input [2:0] Sel,  //Sel is the last three bits of the opcode if the first bit is zero.
output reg [15:0] ALUOut);
//Code for ALU goes here
//Use case statement where case = Sel
initial begin
    ALUOut = 0;
end
always @ (Sel or A or B) begin
    case (Sel)
    3'b000: ALUOut = A + B;  //ADD
    3'b001: ALUOut = A - B;  //SUB
    3'b010: ALUOut = A & B;  //AND
    3'b011: ALUOut = A | B;  //OR
    3'b100: ALUOut = A ^ B;  //XOR
    3'b101: ALUOut = ~A;     //NOT
    3'b110: ALUOut = A << 1; //SLA
    3'b111: ALUOut = A >> 1; //SRA
    endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////
module Datapath(
input Clk,
input [15:0] FromDReg,
input [7:0] RFRegWriteData,
input RFs0,
input RFs1,
input [3:0] WAddress,
input [3:0] RpAddress,
input [3:0] RqAddress,
input WriteEnable,
input RpReadEnable,
input RqReadEnable,
input [2:0] ALUSel,
output [15:0] ReadPData,
output [15:0] ReadQData,
output RFRpIsZero,
output [15:0] ALUOut,
output [15:0] InMemAtWAddress,
output [15:0] Mux16BitOut);
wire [15:0] Wd;
wire [15:0] Rdp;
wire [15:0] Rdq;
wire [15:0] Zero;
wire [15:0] AluOut;
assign Mux16BitOut = Wd;
assign ALUOut = AluOut;
assign ReadPData = Rdp;
assign ReadQData = Rdq;
Mux16Bit RFWriteSelect(.S0(RFs0),.S1(RFs1),.In0(AluOut),.In1(FromDReg),.In2(RFRegWriteData),.Out(Wd),.Clk(Clk));
RFRegister RF(.Clk(Clk),.WriteData(Wd),.WAddress(WAddress),.RpAddress(RpAddress),.RqAddress(RqAddress),
 .WriteEnable(WriteEnable),.RpReadEnable(RpReadEnable),.RqReadEnable(RqReadEnable),.ReadPData(Rdp),.ReadQData(Rdq),
 .InMemAtWAddress(InMemAtWAddress));
ExecutionUnit ALU(.A(Rdp),.B(Rdq),.Sel(ALUSel),.ALUOut(AluOut));
IsZero ZeroCheck(.DataIn(Rdp),.DataIsZero(RFRpIsZero));
//Code is only required in sub modules
//This module is complete
endmodule
//////////////////////////////////////////////////////////////////////////
module Processor16Bit(
input CLK100MHZ,
input CENTER,
input [15:0] SW,
output [15:0] ALUOUT,
output [15:0] RFRPOUT,
output [15:0] RFRQOUT,
output [15:0] RDOUT,
output [7:0] DADDRESS,
output [3:0] RFWADDRESS,
output [3:0] RFRPADDRESS,
output [3:0] RFRQADDRESS,
output [15:0] InMemAtWAddress,
output [15:0] Mux16BitOut,
output [7:0] Immediate,
output WE,
output RPE,
output RQE,
output [7:0] AN,
output [6:0] a_to_g,
output [26:0] binary
//Add io for 7SegDisp
);
//This is the top module
wire [15:0] W7, W8;
wire [7:0] W1, W2, W4, W9;
wire [3:0] W12, W14, W16;
wire [2:0] W19;
wire W3, W5, W6, W10, W11, W13, W15, W17, W18;
reg [15:0] Command;
//Assign 7 seg disp to read the output of the RF register
assign binary = W7;
//Assign various outputs for simulation to be taken from the appropriate connection
assign Immediate = W9;
assign RFRPOUT = W7;
assign RDOUT = W8;
assign DADDRESS = W4;
assign RFWADDRESS = W12;
assign RFRPADDRESS = W14;
assign RFRQADDRESS = W16;
assign WE = W13;
assign RPE = W15;
assign RQE = W17;
wire [3:0] ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10;
wire [6:0] _ones, _tens, _hundreds, _thousand1, _thousand10, _thousand100, _million, _million10;
wire [55:0] disarray;
parameter width1 = 100000000;
parameter width2 = 10000; 
wire Clk_Slow, Clk_Multi, Clk_Slower;
wire [7:0]ANhold;
always @ (posedge Clk_Slower) begin
    if (CENTER) Command = SW;
end
//Instantiate the control unit, datapath, and other sub modules
ControlUnit ControlLogic(.Clk(CLK100MHZ),.DataIn(W8),.Instruction(Command),.IsZero(W18),.SelDAddress(W3),
 .RdDReg(W5),.WdDreg(W6),.ToRFWriteData(W9),.ToWAddress(W12),.ToRpAddress(W14),
 .ToRqAddress(W16),.ToWWrite(W13),.ToRpRead(W15),.ToRqRead(W17),.SelALU(W19),.PCOut(W1),
 .RFSelS0(W11),.RFSelS1(W10),.DAddress(W2));
Datapath CPULogic(.FromDReg(W8),.RFRegWriteData(W9),.RFs0(W11),.RFs1(W10),.WAddress(W12),.RpAddress(W14),.RqAddress(W16),
 .WriteEnable(W13),.RpReadEnable(W15),.RqReadEnable(W17),.ALUSel(W19),.ReadPData(W7),.RFRpIsZero(W18),.Clk(CLK100MHZ),
 .ALUOut(ALUOUT),.ReadQData(RFRQOUT),.InMemAtWAddress(InMemAtWAddress),.Mux16BitOut(Mux16BitOut));
DRegister D(.Clk(CLK100MHZ),.FromAddressSel(W4),.ReadEnable(W5),.WriteEnable(W6),.WriteData(W7),.ReadData(W8));
Mux8Bit DSel(.Sel(W3),.In0(W1),.In1(W2),.Out(W4));
//The only code needed here is that which allows input from the FPGA SW and BTN as well as desired read outs via
//LEDs and seven segment display  
//Call BCD to convert calculated # to binary coded decimal
BCD x1(binary, ones, tens, hundreds, thousand1, thousand10, thousand100, million, million10);
///call to convert binard coded decimal # to 7 segment code
conversion c1(ones, _ones); conversion c6(tens, _tens); conversion c2(hundreds, _hundreds); conversion c3(thousand1, _thousand1); conversion c4(thousand10, _thousand10); conversion c5(thousand100, _thousand100);
conversion c7(million, _million); conversion c8(million10, _million10); 
///combine all 7 segment codes into one array for easier handling
assign disarray = {_million10,_million,_thousand100,_thousand10,_thousand1,_hundreds,_tens,_ones};
assign AN = ANhold;
assign a_to_g = a_to_gohold;
//call to display module that multiplexes each digit changed with slower clock signal
display z1(Clk_Multi, disarray, a_to_gohold, ANhold);
//call to clock slow down module for multiplexed display clk pulse
Clk_Divide # (width1,width2) In1 (CLK100MHZ, Clk_Slow, Clk_Multi);
endmodule
//////////////////////////////////////////////////////////////////
//Used for integration with FPGA
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
