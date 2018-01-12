`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 01:16:50
// Design Name: 
// Module Name: openmips
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
module openmips(
    input wire clk,
    input wire rst,
    input wire[`RegBus] rom_data_i,
    input wire[`RegBus] ram_data_i,
    
    output wire[`RegBus] rom_addr_o,
    output wire rom_ce_o,
    output wire[`RegBus] ram_addr_o,
    output wire[`RegBus] ram_data_o,
    output wire[`Mask] ram_mask_o,
    output wire ram_ce_o,
    output wire ram_we_o  
    );
    wire[`InstAddrBus] pc;
    wire[`InstAddrBus] id_pc_i;
    wire[`InstBus] id_inst_i;
    
    wire reg1_read;
    wire reg2_read;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;    
    
    wire[`OpCode] id_opcode_o;
    wire[`Funct3] id_funct3_o;
    wire[`Funct7] id_funct7_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire[`InstAddrBus] id_pc_o;
    wire id_wreg_o;
    wire[`RegAddrBus] id_wd_o;
    wire[`InstBus] id_inst_o;
    
    wire[`OpCode] ex_opcode_i;
    wire[`Funct3] ex_funct3_i;
    wire[`Funct7] ex_funct7_i;
    wire[`RegBus] ex_reg1_i;
    wire[`RegBus] ex_reg2_i;
    wire[`RegBus] ex_inst_i;
    wire[`InstAddrBus] ex_pc_i;
    wire ex_wreg_i;    
    wire[`RegAddrBus] ex_wd_i;
    
    wire ex_wreg_o;
    wire[`RegAddrBus] ex_wd_o;
    wire[`RegBus] ex_wdata_o;
    wire[`OpCode] ex_opcode_o;
    wire[`RegBus] ex_mem_addr_o;
    wire[`RegBus] ex_reg2_o;
    wire[`Mask] ex_mask_o;
    
    wire mem_wreg_i;
    wire[`RegAddrBus] mem_wd_i;
    wire[`RegBus] mem_wdata_i; 
    wire[`OpCode] mem_opcode_i;
    wire[`RegBus] mem_mem_addr_i;
    wire[`RegBus] mem_reg2_i;   
    wire[`Mask] mem_mask_i;
    
    wire mem_wreg_o;
    wire[`RegAddrBus] mem_wd_o;
    wire[`RegBus] mem_wdata_o;
    
    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wd_i;
    wire[`RegBus] wb_wdata_i;   
    
    wire branch_flag;
    wire[`RegBus] branch_addr;
    wire [`RegBus] id_link_addr_o;
    wire [`RegBus] ex_link_addr_i;
    wire stallreq_id;
    wire stallreq_ex;
    wire[5:0] stall_i;
    
    pc_reg pc_reg0(
        .clk(clk), 
        .rst(rst), 
        .stall(stall_i), 
        .branch_flag_i(branch_flag), 
        .branch_addr_i(branch_addr), 
        .pc(pc), 
        .ce(rom_ce_o)
    );
    
    assign rom_addr_o = pc;
    
    if_id if_id0(
        .clk(clk), 
        .rst(rst), 
        .stall(stall_i),
        .if_pc(pc), 
        .if_inst(rom_data_i), 
        .branch_flag_i(branch_flag),
        .id_pc(id_pc_i), 
        .id_inst(id_inst_i)
    );
    
    regfile regfile0(
        .clk(clk), 
        .rst(rst),
        .we(wb_wreg_i), 
        .waddr(wb_wd_i), 
        .wdata(wb_wdata_i),    
        .re1(reg1_read), 
        .raddr1(reg1_addr), 
        .rdata1(reg1_data),
        .re2(reg2_read), 
        .raddr2(reg2_addr), 
        .rdata2(reg2_data)
    );
    
    id id0(
        .rst(rst),  
        .pc_i(id_pc_i), 
        .inst_i(id_inst_i), 
        .ex_wreg_i(ex_wreg_o), 
        .ex_wdata_i(ex_wdata_o), 
        .ex_wd_i(ex_wd_o),
        .mem_wreg_i(mem_wreg_o), 
        .mem_wdata_i(mem_wdata_o), 
        .mem_wd_i(mem_wd_i),
        .reg1_data_i(reg1_data),  
        .reg2_data_i(reg2_data),
        .opcode_i(ex_opcode_o),
        .pc_o(id_pc_o),
        .reg1_read_o(reg1_read), 
        .reg2_read_o(reg2_read), 
        .reg1_addr_o(reg1_addr), 
        .reg2_addr_o(reg2_addr),
        .opcode_o(id_opcode_o), 
        .funct3_o(id_funct3_o), 
        .funct7_o(id_funct7_o),
        .reg1_o(id_reg1_o), 
        .reg2_o(id_reg2_o),
        .wd_o(id_wd_o), 
        .wreg_o(id_wreg_o),
        .stallreq(stallreq_id), 
        .inst_o(id_inst_o),
        .branch_flag_o(branch_flag), 
        .branch_addr_o(branch_addr), 
        .link_addr_o(id_link_addr_o)
    );
    
    id_ex id_ex0(
        .clk(clk), 
        .rst(rst), 
        .id_pc(id_pc_o),
        .id_opcode(id_opcode_o), 
        .id_funct3(id_funct3_o), 
        .id_funct7(id_funct7_o),
        .id_reg1(id_reg1_o),
        .id_reg2(id_reg2_o),
        .id_wd(id_wd_o),
        .id_wreg(id_wreg_o), 
        .stall(stall_i),
        .id_inst(id_inst_o),
        .id_link_addr(id_link_addr_o),
        .ex_pc(ex_pc_i),
        .ex_opcode(ex_opcode_i), 
        .ex_funct3(ex_funct3_i), 
        .ex_funct7(ex_funct7_i),
        .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i),
        .ex_wd(ex_wd_i),
        .ex_wreg(ex_wreg_i),
        .ex_link_addr(ex_link_addr_i),
        .ex_inst(ex_inst_i)
    );
    
    ex ex0(
        .rst(rst),
        .inst_i(ex_inst_i),
        .opcode_i(ex_opcode_i), 
        .funct3_i(ex_funct3_i), 
        .funct7_i(ex_funct7_i),
        .reg1_i(ex_reg1_i), 
        .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i), 
        .wreg_i(ex_wreg_i), 
        .pc_i(ex_pc_i), 
        .stallreq(stallreq_ex),
        .link_addr_i(ex_link_addr_i),
        .wd_o(ex_wd_o), 
        .wreg_o(ex_wreg_o), 
        .wdata_o(ex_wdata_o),
        .opcode_o(ex_opcode_o),
        .mem_addr_o(ex_mem_addr_o),
        .reg2_o(ex_reg2_o),
        .mask_o(ex_mask_o)
    );
    
    ex_mem ex_mem0(
        .clk(clk), 
        .rst(rst),
        .ex_wd(ex_wd_o), 
        .ex_wreg(ex_wreg_o), 
        .ex_wdata(ex_wdata_o),
        .stall(stall_i),
        .ex_opcode(ex_opcode_o),
        .ex_mem_addr(ex_mem_addr_o),
        .ex_reg2(ex_reg2_o),
        .ex_mask(ex_mask_o),
        .mem_wd(mem_wd_i), 
        .mem_wreg(mem_wreg_i), 
        .mem_wdata(mem_wdata_i),
        .mem_opcode(mem_opcode_i),
        .mem_mem_addr(mem_mem_addr_i),
        .mem_reg2(mem_reg2_i),
        .mem_mask(mem_mask_i)
    );
    
    mem mem0(
        .rst(rst), 
        .wd_i(mem_wd_i), 
        .wreg_i(mem_wreg_i), 
        .wdata_i(mem_wdata_i),
        .opcode_i(mem_opcode_i),
        .mem_addr_i(mem_mem_addr_i),
        .mem_data_i(ram_data_i),
        .reg2_i(mem_reg2_i),
        .mask_i(mem_mask_i),
        
        .wd_o(mem_wd_o), 
        .wreg_o(mem_wreg_o), 
        .wdata_o(mem_wdata_o),
        .mem_addr_o(ram_addr_o),
        .mem_data_o(ram_data_o),
        .mask_o(ram_mask_o),
        .mem_we_o(ram_we_o),
        .mem_ce_o(ram_ce_o)
    );
    
    mem_wb mem_wb0(
        .clk(clk), 
        .rst(rst), 
        .stall(stall_i),
        .mem_wd(mem_wd_o), 
        .mem_wreg(mem_wreg_o), 
        .mem_wdata(mem_wdata_o),
        .wb_wd(wb_wd_i), 
        .wb_wreg(wb_wreg_i), 
        .wb_wdata(wb_wdata_i)
    );
    
    ctrl ctrl0(
        .rst(rst), 
        .stallreq_id(stallreq_id), 
        .stallreq_ex(stallreq_ex),
        .stall(stall_i)
    );
endmodule
