`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 19:41:51
// Design Name: 
// Module Name: openmips_min_sopc
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
module openmips_min_sopc(
    input wire clk,
    input wire rst
    );
    
    wire[`InstAddrBus] inst_addr;
    wire[`InstBus] inst;
    wire[`DataBus] data;
    wire[`DataBus] ram_data;
    wire[`DataAddrBus] addr;
    wire[`Mask] mask;
    
    
    wire rom_ce;
    wire ram_ce;
    wire we;
    
    openmips openmips0(
        .clk(clk), 
        .rst(rst),
        .rom_data_i(inst),
        .ram_data_i(data),
        
        .rom_addr_o(inst_addr), 
        .rom_ce_o(rom_ce),
        .ram_addr_o(addr),
        .ram_data_o(ram_data),
        .ram_mask_o(mask),
        .ram_ce_o(ram_ce),
        .ram_we_o(we)
    );
    
    inst_rom inst_rom0(
        .ce(rom_ce),
        .addr(inst_addr), 
        .inst(inst)
    );
    
    data_ram data_ram0(
        .clk(clk),
        .ce(ram_ce),
        .we(we),
        .addr(addr),
        .mask(mask),
        .data_i(ram_data),
        .data_o(data)
    );
endmodule
