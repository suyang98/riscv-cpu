`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:49:37
// Design Name: 
// Module Name: openmips_min_sopc_tb
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
module openmips_min_sopc_tb();
    reg CLOCK_50;
    reg rst;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #2 CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        rst = `RstEna;
        #195 rst = `RstDis;
        #1000 $stop;
    end
    
    openmips_min_sopc openmips_min_sopc0(
        .clk(CLOCK_50),
        .rst(rst)
    );
endmodule
