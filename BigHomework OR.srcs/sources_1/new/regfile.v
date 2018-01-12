`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 10:40:49
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
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

module regfile(
    input wire clk,
    input wire rst,
    input wire we,
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus] wdata,
    input wire re1,
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus] rdata1,
    input wire re2,
    input wire[`RegAddrBus] raddr2,
    output reg[`RegBus] rdata2
    );
    reg [`RegBus] regs[0:`RegNum-1];
    integer i;
    always @ (posedge clk) begin
        if (rst == `RstEna) begin
            for (i = 0; i <= 31;i = i + 1) regs[i] <= 0;
        end else begin
            if ((we == `WriEna) && (waddr != `RegNumLog2'h0)) begin
                regs[waddr] <= wdata;
            end
        end
    end
    always @ (*) begin
        if (rst == `RstEna) begin
            rdata1 <= `ZeroWord; 
        end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end else if ((raddr1 ==  waddr) && (we == `WriEna) && (re1 == `ReadEna)) begin
            rdata1 <= wdata;
        end else if (re1 == `ReadEna) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end
    always @ (*) begin
        if (rst == 1'b1) begin
            rdata2 <= 32'h00000000; 
        end else if (raddr2 == 5'h0) begin
            rdata2 <= 32'h00000000;
        end else if ((raddr2 ==  waddr) && (we == 1'b1) && (re2 == 1'b1)) begin
            rdata2 <= wdata;
        end else if (re2 == 1'b1) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= 8'h00000000;
        end
    end    
endmodule
