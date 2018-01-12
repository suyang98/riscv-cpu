`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 14:56:31
// Design Name: 
// Module Name: id_ex
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
module id_ex(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] id_pc,
    input wire[`OpCode] id_opcode,
    input wire[`Funct3] id_funct3,
    input wire[`Funct7] id_funct7,
    input wire[`RegBus] id_reg1,
    input wire[`RegBus] id_reg2,
    input wire[`RegAddrBus] id_wd,
    input wire id_wreg,
    input wire[5:0] stall,
    input wire[`RegBus] id_inst,
    input wire[`RegBus] id_link_addr,
    
    output reg[`InstAddrBus] ex_pc,
    output reg[`OpCode] ex_opcode,
    output reg[`Funct3] ex_funct3,
    output reg[`Funct7] ex_funct7,
    output reg[`RegBus] ex_reg1,
    output reg[`RegBus] ex_reg2,
    output reg[`RegAddrBus] ex_wd,
    output reg ex_wreg,
    output reg[`RegBus] ex_link_addr,
    output reg[`RegBus] ex_inst
    );
    
    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            ex_opcode <= 7'b0000000;
            ex_funct3 <= 3'b000;
            ex_funct7 <= 7'b0000000;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= 1'b0;
            ex_pc <= 32'h00000000;
            ex_link_addr <= `ZeroWord; 
            ex_inst <= `ZeroWord;
        end else if (stall[2] == `Stop && stall[3] == `NoStop)begin
            ex_opcode <= 7'b0000000;
            ex_funct3 <= 3'b000;
            ex_funct7 <= 7'b0000000;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= 1'b0;
            ex_pc <= 32'h00000000;     
            ex_link_addr<=`ZeroWord;
            ex_inst <= `ZeroWord;
        end else if (stall[2] == `NoStop) begin
            ex_opcode <= id_opcode;
            ex_funct3 <= id_funct3;
            ex_funct7 <= id_funct7;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;   
            ex_pc <= id_pc;         
            ex_link_addr <= id_link_addr;
            ex_inst <= id_inst;
        end
    end
endmodule
