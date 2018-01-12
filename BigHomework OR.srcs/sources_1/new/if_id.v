`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 20:28:40
// Design Name: 
// Module Name: if_id
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
module if_id(
    input wire clk,
    input wire rst,
    input wire[5:0] stall,
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,
    input wire branch_flag_i,
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
    );
    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else if (stall[1] == `Stop && stall[2] == `NoStop) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else if (branch_flag_i == `Branch) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else if (stall[1] == `NoStop) begin
            id_pc <= if_pc;
            id_inst <= if_inst; 
        end
    end     
endmodule
