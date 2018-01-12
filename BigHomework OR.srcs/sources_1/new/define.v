`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 20:29:55
// Design Name: 
// Module Name: define
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
`define RstEna 1'b1
`define RstDis 1'b0
`define ZeroWord 32'h00000000
`define WriEna 1'b1
`define WriDis 1'b0
`define ReadEna 1'b1
`define ReadDis 1'b0

`define OpCode 6:0
`define Funct3 2:0
`define Funct7 6:0
`define NoneOpcode 7'b1111111
`define NoneFun3 3'b000
`define NoneFun7 7'b0000000

`define InstValid 1'b0
`define InstInvalid 1'b1
`define True_v 1'b1
`define False_v 1'b0
`define ChipEna 1'b1
`define ChipDis 1'b0

`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 262143
`define InstMemNumLog2 22//?????????

`define RegAddrBus 4:0
`define RegBus 31:0
`define Regwidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000

`define Branch 1'b1
`define NotBranch 1'b0
`define Stop 1'b1
`define NoStop 1'b0

`define Mask 3:0
`define NoneMask 4'b0000

`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131071
`define DataMemNumLog2 17