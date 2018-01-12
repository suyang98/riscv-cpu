`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/04 09:39:22
// Design Name: 
// Module Name: data_ram
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
module data_ram(
    input wire clk,
    input wire ce,
    input wire we,
    input wire[`DataAddrBus] addr,
    input wire[`Mask] mask,
    input wire[`DataBus] data_i,
    output reg[`DataBus] data_o
    );
    reg[7:0] data_mem0[0:`DataMemNum-1];
    reg[7:0] data_mem1[0:`DataMemNum-1];
    reg[7:0] data_mem2[0:`DataMemNum-1];
    reg[7:0] data_mem3[0:`DataMemNum-1];
    integer k;
    initial begin
        for (k = 0; k < `DataMemNum; k= k+1) begin
            data_mem0[k] = 8'b00000000;
            data_mem1[k] = 8'b00000000;
            data_mem2[k] = 8'b00000000;
            data_mem3[k] = 8'b00000000;
        end
    end
    
    always @ (posedge clk) begin//write
        if (ce == `ChipDis) begin
            data_o <= `ZeroWord;
        end else if (we == `WriEna) begin
            if (mask == 4'b1000) begin
                data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
            end
            if (mask == 4'b0100) begin
                data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];           
            end
            if (mask == 4'b0010) begin
                data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
            end
            if (mask == 4'b0001) begin
               data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];            
            end
            if (mask == 4'b1100) begin
                data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
                data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
            end
            if (mask == 4'b0011) begin
                data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
                data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
            end 
            if (mask == 4'b1111) begin
                data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[31:24];
                data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[23:16];
                data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
                data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
            end
        end
    end
    
    always @ (*) begin//read
        if (ce == `ChipDis) begin
            data_o <= `ZeroWord;
        end else if (we == `WriDis) begin
            data_o <= {data_mem3[addr[`DataMemNumLog2+1:2]], data_mem2[addr[`DataMemNumLog2+1:2]], data_mem1[addr[`DataMemNumLog2+1:2]], data_mem0[addr[`DataMemNumLog2+1:2]]};
        end else begin
            data_o <= `ZeroWord;
        end
    end
endmodule
