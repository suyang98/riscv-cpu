`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/25 21:18:45
// Design Name: 
// Module Name: ctrl
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
module ctrl(
    input wire rst,
    input wire stallreq_id,
    input wire stallreq_ex,
    output reg[5:0] stall
);
    
    always @ (*) begin
        if (rst == `RstEna) begin
            stall <= 6'b000000;
        end else if (stallreq_ex == `Stop) begin
            stall <= 6'b001111;
        end else if (stallreq_id == `Stop) begin
            stall <= 6'b000111;
        end else begin
            stall <= 6'b000000;
        end
    end
endmodule
