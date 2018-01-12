`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 15:12:22
// Design Name: 
// Module Name: ex_mem
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

`include "define.v"
module ex_mem(
    input wire clk,
    input wire rst,
    input wire[`RegAddrBus] ex_wd,
    input wire ex_wreg,
    input wire[`RegBus] ex_wdata,
    input wire[5:0] stall,
    input wire[`OpCode] ex_opcode,
    input wire[`RegBus] ex_mem_addr,
    input wire[`RegBus] ex_reg2,
    input wire[`Mask] ex_mask,
    
    output reg[`RegAddrBus] mem_wd,
    output reg mem_wreg,
    output reg[`RegBus] mem_wdata,
    output reg[`OpCode] mem_opcode,
    output reg[`RegBus] mem_mem_addr,
    output reg[`RegBus] mem_reg2,
    output reg[`Mask] mem_mask
    );
    
    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `WriDis;
            mem_wdata <= `ZeroWord;
            mem_opcode <= `NoneOpcode;
            mem_mem_addr <= `ZeroWord;
            mem_reg2 <= `ZeroWord;
            mem_mask <= `NoneMask;
        end else if(stall[3] == `Stop && stall[4] == `NoStop) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `WriDis;
            mem_wdata <= `ZeroWord;
            mem_opcode <= `NoneOpcode;
            mem_mem_addr <= `ZeroWord;
            mem_reg2 <= `ZeroWord;
            mem_mask <= `NoneMask;
        end else if(stall[3] == `NoStop) begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_opcode <= ex_opcode;
            mem_mem_addr <= ex_mem_addr;
            mem_reg2 <= ex_reg2;
            mem_mask <= ex_mask;
        end
    end
endmodule
