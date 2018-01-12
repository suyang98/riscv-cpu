`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 15:12:03
// Design Name: 
// Module Name: ex
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
module ex(
    input wire rst,
    input wire[`RegBus] inst_i,
    input wire[`OpCode] opcode_i,
    input wire[`Funct3] funct3_i,
    input wire[`Funct7] funct7_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`RegBus] link_addr_i,
    input wire[`InstAddrBus] pc_i,
    
    output wire stallreq,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,
    output wire[`OpCode] opcode_o,
    output reg[`RegBus] mem_addr_o,
    output wire[`RegBus] reg2_o,
    output reg[`Mask] mask_o
    );
    wire[`RegBus] imm_l;
    wire[`RegBus] imm_s;

    assign stallreq = `NoStop;
    assign opcode_o = opcode_i;
    assign reg2_o = reg2_i;
    assign imm_l = {{21{inst_i[31]}}, inst_i[30:20]};
    assign imm_s = {{21{inst_i[31]}}, inst_i[29:25], inst_i[11:7]};
    
    always @ (*) begin
        if (rst == `RstEna) begin
            wdata_o <= `ZeroWord;
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriDis;
            mem_addr_o <= `ZeroWord;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mask_o <= 4'b0000;
            case (opcode_i)
                7'b0000001:begin//add
                    wdata_o <= reg1_i + reg2_i;
                end
                7'b0000010:begin//sub
                    wdata_o <= reg1_i - reg2_i;
                end
                7'b0000011:begin//sll,slli
                    wdata_o <= reg1_i << reg2_i;
                end
                7'b0000100:begin//slt,slti
                    wdata_o <= ($signed(reg1_i) < $signed(reg2_i)) ? 1'b1: 1'b0;
                end
                7'b0000101:begin//sltu
                    wdata_o <= (reg1_i < reg2_i) ? 1'b1 : 1'b0;
                end
                7'b0000110:begin//srl,srli
                    wdata_o <= reg1_i >> reg2_i;
                end
                7'b0000111:begin//sra,srai
                    wdata_o <= $signed(reg1_i) >>> reg2_i[4:0];
                end 
                7'b0001000:begin//xor,xori
                    wdata_o <= reg1_i ^ reg2_i;
                end
                7'b0001001:begin//or.ori
                    wdata_o <= reg1_i | reg2_i;
                end
                7'b0001010:begin//add.addi
                    wdata_o <= reg1_i & reg2_i;
                end
                7'b0001011:begin//lui
                    wdata_o <= reg1_i;
                end
                7'b0001100:begin//auipc
                    wdata_o <= reg1_i + pc_i;
                end
                7'b0001101:begin//jal,jalr
                    wdata_o <= link_addr_i;
                end
                7'b0001111:begin//lb
                    mem_addr_o <= reg1_i + imm_l;
                    mask_o[(reg1_i + imm_l) % 4] <= 1'b1;
                end
                7'b0010000:begin//lh
                    mem_addr_o <= reg1_i + imm_l;
                    mask_o[(reg1_i + imm_l) % 4] <= 1'b1;
                    mask_o[(reg1_i + imm_l + 1) % 4] <= 1'b1;
                end
                7'b0010001:begin//lw
                    mem_addr_o <= reg1_i + imm_l;
                    mask_o <= 4'b1111;
                end
                7'b0010010:begin//lbu
                    mem_addr_o <= reg1_i + imm_l;
                    mask_o[(reg1_i + imm_l) % 4] <= 1'b1;
                end
                7'b0010011:begin//lwu
                    mem_addr_o <= reg1_i + imm_l;
                    mask_o[(reg1_i + imm_l) % 4] <= 1'b1;
                    mask_o[(reg1_i + imm_l + 1) % 4] <= 1'b1;
                end
                7'b0010100:begin//sb
                    mem_addr_o <= reg1_i + imm_s;
                    mask_o[(reg1_i + imm_s) % 4] <= 1'b1;
                end
                7'b0010101:begin//sh
                    mem_addr_o <= reg1_i + imm_s;
                    mask_o[(reg1_i + imm_s) % 4] <= 1'b1;
                    mask_o[(reg1_i + imm_s + 1) % 4] <= 1'b1;
                end
                7'b0010110:begin//sw
                    mem_addr_o <= reg1_i + imm_s;
                    mask_o <= 4'b1111;
                end
            endcase
        end    
    end
endmodule
