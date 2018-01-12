`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 19:33:18
// Design Name: 
// Module Name: inst_rom
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
module inst_rom(
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
    );
    reg[`InstBus] inst_mem [0:`InstMemNum-1];
    wire[`InstBus] inst_tmp = inst_mem[addr[`InstMemNumLog2+1:2]];
    initial $readmemh("C:/Users/user/Desktop/BigHomework OR/inst_rom.txt",inst_mem);
    
    always @ (*) begin
        if (ce == `ChipDis) begin
            inst <= `ZeroWord;
        end else begin
            inst <= {inst_tmp[7:0], inst_tmp[15:8], inst_tmp[23:16], inst_tmp[31:24]};
        end
    end
endmodule
