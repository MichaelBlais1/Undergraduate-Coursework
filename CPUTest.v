`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module CPUTest();
reg CLK100MHZ;
reg CENTER;
reg [15:0] SW;
wire [15:0] ALUOUT;
wire [15:0] RFRPOUT;
wire [15:0] RFRQOUT;
wire [15:0] RDOUT;
wire [7:0] DADDRESS;
wire [3:0] RFWADDRESS;
wire [3:0] RFRPADDRESS;
wire [3:0] RFRQADDRESS;
wire [15:0] InMemAtWAddress;
wire [15:0] Mux16BitOut;
wire [7:0] Immediate;
wire WE;
wire RPE;
wire RQE;

Processor16Bit UUT(.CLK100MHZ(CLK100MHZ),.CENTER(CENTER),.SW(SW),.ALUOUT(ALUOUT),
.RFRPOUT(RFRPOUT),.RFRQOUT(RFRQOUT),.RDOUT(RDOUT),.DADDRESS(DADDRESS),
.RFWADDRESS(RFWADDRESS),.RFRPADDRESS(RFRPADDRESS),.RFRQADDRESS(RFRQADDRESS),
.InMemAtWAddress(InMemAtWAddress),.Mux16BitOut(Mux16BitOut),.Immediate(Immediate),
.WE(WE),.RPE(RPE),.RQE(RQE));

initial begin
SW = 0;
CENTER = 0;
#10 SW = 16'b1000000000001000;  //Load immediate 8 to RF address 0
#10 CENTER = 1'b1;
#2 CENTER = 1'b0;
#10 SW = 16'b1000000100000100;  //Load immediate 4 to RF address 1
#10 CENTER = 1'b1;
#2 CENTER = 1'b0;
#10 SW = 16'b0000001000000001;  //Add values in RF address 0 and RF address 1
#10 CENTER = 1'b1;              //Store the result in RF address 2
#2 CENTER = 1'b0;
#10 SW = 16'b1010001000000000;  //Store value in RF address 2 to D address 0
#10 CENTER = 1'b1;
#2 CENTER = 1'b0;
#10 SW = 16'b1001001100000000;  //Load value in D address 0 to RF address 3
#10 CENTER = 1'b1;
#2 CENTER = 1'b0;
#100 $finish;
end

initial begin
    CLK100MHZ = 0;
    forever begin
    #1 CLK100MHZ = ~CLK100MHZ;
end
end
endmodule
