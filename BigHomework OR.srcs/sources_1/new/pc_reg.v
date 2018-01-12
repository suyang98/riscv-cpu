`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 20:26:04
// Design Name: 
// Module Name: pc_reg
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
module pc_reg(
    input wire clk,
    input wire rst,
    input wire[5:0] stall,
    input wire branch_flag_i,
    input wire[`RegBus] branch_addr_i,
    output reg[`InstAddrBus] pc,
    output reg ce
    );
    always @ (*) begin
        if (rst == `RstEna) begin
            ce <= `ChipDis;
        end else begin
            ce <= `ChipEna;
        end
    end

    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            pc <= 32'h00000000;
        end else if (stall[0] == `NoStop) begin
            if (branch_flag_i ==  `Branch) begin
                pc <= branch_addr_i;
            end else pc <= pc + 4'h4;
        end
    end
endmodule
