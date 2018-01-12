`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 15:13:09
// Design Name: 
// Module Name: mem_wb
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
module mem_wb(
    input wire clk,
    input wire rst,
    input wire[`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire[`RegBus] mem_wdata,
    input wire[5:0] stall,
    
    output reg[`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg[`RegBus] wb_wdata
    );
    
    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriDis;
            wb_wdata <= `ZeroWord;
        end else if(stall[4] == `Stop && stall[5] == `NoStop)begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriDis;
            wb_wdata <= `ZeroWord;
        end else if(stall[4] == `NoStop) begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
        end
    end
endmodule
