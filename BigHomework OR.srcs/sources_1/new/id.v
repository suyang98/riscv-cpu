`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 13:38:56
// Design Name: 
// Module Name: id
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
module id(
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,
    
    input wire ex_wreg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    
    input wire mem_wreg_i,
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,
    
    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,
    input wire[`OpCode] opcode_i,
    
    output wire[`InstAddrBus] pc_o,
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,
    
    output reg[`OpCode] opcode_o,
    output reg[`Funct3] funct3_o,
    output reg[`Funct7] funct7_o,
    output reg[`RegBus] reg1_o,
    output reg[`RegBus] reg2_o,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output wire stallreq,
    output wire [`RegBus] inst_o,
    
    output reg branch_flag_o,
    output reg [`RegBus] branch_addr_o,
    output reg [`RegBus] link_addr_o
    );
    reg stallreq_for_reg1;
    reg stallreq_for_reg2;
    wire pre_inst_is_load;
    
    assign stallreq = stallreq_for_reg1 || stallreq_for_reg2;
    assign pre_inst_is_load = ((opcode_i == 7'b0001111)||
                               (opcode_i == 7'b0010000)||
                               (opcode_i == 7'b0010001)||
                               (opcode_i == 7'b0010010)||
                               (opcode_i == 7'b0010011));
    always @ (*) begin
        stallreq_for_reg1 <= `NoStop;
        if (rst == `RstEna) begin
            reg1_o <= `ZeroWord;
        end else if (pre_inst_is_load == 1'b1 && ex_wd_i == reg1_addr_o && reg1_read_o == 1'b1) begin
            stallreq_for_reg1 <= `Stop;
        end
    end
    
    always @ (*) begin
        stallreq_for_reg2 <= `NoStop;
        if (rst == `RstEna) begin
            reg1_o <= `ZeroWord;
        end else if (pre_inst_is_load == 1'b1 && ex_wd_i == reg2_addr_o && reg2_read_o == 1'b1) begin
            stallreq_for_reg2 <= `Stop;
        end
    end
    
    wire [6:0] op1 = inst_i[6:0];
    wire [2:0] op2 = inst_i[14:12];
    wire [6:0] op3 = inst_i[31:25];
    
    reg [31:0] imm;
    reg instvalid;
    wire [`RegBus] pc_plus_8;
    wire [`RegBus] pc_plus_4;
    wire [31:0] imm_jal;
    wire [31:0] imm_jalr;
    wire [31:0] imm_b1;
    assign pc_o = pc_i;
    assign imm_jal = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
    assign imm_jalr = {{20{inst_i[31]}}, inst_i[31:20]};
    assign imm_b1 = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
    assign pc_plus_8 = pc_i + 8;
    assign pc_plus_4 = pc_i + 4;
    
    assign inst_o = inst_i;
    
    always @ (*) begin
        if (rst == `RstEna) begin
            opcode_o <= 7'b0000000;
            funct3_o <= 3'b000;
            funct7_o <= 7'b0000000;
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriDis;
            instvalid <= `InstValid;
            reg1_read_o <= `ReadDis;
            reg2_read_o <= `ReadDis;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            imm <= 32'h0;
            
            link_addr_o <= `ZeroWord;
            branch_addr_o <= `ZeroWord;
            branch_flag_o <= `NotBranch;
        end else begin
            opcode_o <= op1;
            funct3_o <= op2;
            funct7_o <= op3;
            wd_o <= inst_i[11:7];
            wreg_o <= `WriDis;
            instvalid <= `InstInvalid;
            reg1_read_o <= `ReadDis;
            reg2_read_o <= `ReadDis;
            reg1_addr_o <= inst_i[19:15];
            reg2_addr_o <= inst_i[24:20];
            imm <= 32'h00000000;
            link_addr_o <= `ZeroWord;
            branch_addr_o <= `ZeroWord;
            branch_flag_o <= `NotBranch;
           
            case (op1)
            7'b0110011:begin//and,xor
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                case(op2)
                    3'b000:begin//+-
                        opcode_o <= (op3 == 7'b0000000) ? (7'b0000001):(7'b0000010);
                    end
                    3'b001:begin//sll,slli
                        opcode_o <= 7'b0000011;
                    end
                    3'b010:begin//slt,slti
                        opcode_o <= 7'b0000100;
                    end
                    3'b011:begin//sltu
                        opcode_o <= 7'b0000101;
                    end
                    3'b101:begin//srl,srli,sra,srai
                        opcode_o <= (op3 == 7'b0100000) ? 7'b0000111: 7'b0000110;
                    end
                    3'b100:begin//xor
                        opcode_o <= 7'b0001000;
                    end
                    3'b110:begin//or
                        opcode_o <= 7'b0001001;
                    end
                    3'b111:begin//and
                        opcode_o <= 7'b0001010;
                    end
                endcase
                funct3_o <= op2;
                funct7_o <= op3;
                reg1_read_o <= `ReadEna;
                reg2_read_o <= `ReadEna;
                reg2_read_o <= `ReadEna;
                instvalid <= `InstValid;
            end
            7'b0010011:begin//,andi,xori
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7]; 
                case(op2)
                    3'b000:begin//+-
                        opcode_o <= (op3 ==7'b0000000) ? (7'b0000001):(7'b0000010);
                    end
                    3'b001:begin//sll,slli
                        opcode_o <= 7'b0000011;
                    end
                    3'b010:begin//slt,slti
                        opcode_o <= 7'b0000100;
                    end
                    3'b011:begin//sltu
                        opcode_o <= 7'b0000101;
                    end
                    3'b101:begin//srl,srli,sra,srai
                        opcode_o <= (op3 == 7'b0100000) ? 7'b0000111: 7'b0000110;
                    end
                    3'b100:begin//xor
                        opcode_o <= 7'b0001000;
                    end
                    3'b110:begin//or
                        opcode_o <= 7'b0001001;
                    end
                    3'b111:begin//and
                        opcode_o <= 7'b0001010;
                    end
                endcase
                funct3_o <= op2;
                reg1_read_o <= `ReadEna;
                reg2_read_o <= `ReadDis;
                if (op2 == 3'b001 || op2 == 3'b101) begin
                    funct7_o <= op3;
                    imm <= {{26{inst_i[25]}}, inst_i[25:20]};
                    instvalid <= `InstValid; 
                end else begin
                    funct7_o <= `NoneFun7;
                    imm <= {{20{inst_i[31]}}, inst_i[31:20]};
                    instvalid <= `InstValid;
                end
            end
            7'b0110111:begin//lui
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                imm <= {inst_i[31:12], {12{1'b0}}};
                opcode_o <= 7'b0001011;
                funct3_o <= `NoneFun3;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadDis;
                reg2_read_o <= `ReadDis;
                instvalid <= `InstValid;                
            end
            7'b0010111:begin//auipc
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                imm <= {inst_i[31:12], {12{1'b0}}};
                opcode_o <= 7'b0001100;
                funct3_o <= `NoneFun3;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadDis;
                reg2_read_o <= `ReadDis;
                instvalid <= `InstValid;                
            end
            7'b1101111:begin//jal
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                opcode_o <= 7'b0001101;
                funct3_o <= `NoneFun3;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadDis;
                reg2_read_o <= `ReadDis;
                instvalid <= `InstValid;
                
                link_addr_o <= pc_plus_4 + imm_jal;
                branch_addr_o <= imm_jal + pc_i;
                branch_flag_o <= `Branch;
            end
            7'b1100111:begin//jalr
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                opcode_o <= 7'b0001101;
                funct3_o <= op2;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadEna;
                reg2_read_o <= `ReadDis;
                instvalid <= `InstValid;
                
                link_addr_o <= reg1_o  + imm_jalr + pc_plus_4;
                branch_addr_o <= reg1_o + imm_jalr + pc_i;
                branch_flag_o <= `Branch;
            end
            7'b1100011:begin//beq,bne,blt,bltu,bge,bgeu
                wreg_o <= `WriDis;
                wd_o <= `NOPRegAddr;
                opcode_o <= 7'b0001110;
                funct3_o <= op2;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadEna;
                reg2_read_o <= `ReadEna;
                instvalid <= `InstValid;
                
                case (op2)
                3'b000:begin
                    if (reg1_o == reg2_o) begin
                        branch_addr_o <= imm_b1 + pc_i;  
                        branch_flag_o <= `Branch;
                    end
                end
                3'b001:begin
                    if (reg1_o != reg2_o) begin
                        branch_addr_o <= imm_b1 + pc_i;  
                        branch_flag_o <= `Branch;
                    end
                end
                3'b010:begin
                    if (reg1_o < reg2_o) begin
                        branch_addr_o <= imm_b1 + pc_i;
                        branch_flag_o <= `Branch;
                    end
                end
                3'b101:begin
                    if (reg1_o >= reg2_o) begin
                        branch_addr_o <= imm_b1 + pc_i;
                        branch_flag_o <= `Branch;    
                    end
                end
                3'b110:begin
                    if ($unsigned(reg1_o) < $unsigned(reg2_o)) begin
                        branch_addr_o <= imm_b1 + pc_i;
                        branch_flag_o <= `Branch;
                    end
                end
                3'b110:begin
                    if ($unsigned(reg1_o) >= $unsigned(reg2_o)) begin
                        branch_addr_o <= imm_b1 + pc_i;
                        branch_flag_o <= `Branch;
                    end
                end
                endcase
            end
            7'b0000011:begin
                wreg_o <= `WriEna;
                wd_o <= inst_i[11:7];
                funct3_o <= op2;
                funct7_o <= `NoneFun7;
                reg1_read_o <= `ReadEna;
                reg2_read_o <= `ReadDis;
                instvalid <= `InstValid;  
                              
                case (op2)
                3'b000:begin//lb
                    opcode_o <= 7'b0001111;
                end
                3'b001:begin//lh
                    opcode_o <= 7'b0010000;
                end
                3'b010:begin//lw
                    opcode_o <= 7'b0010001;
                end
                3'b100:begin//lbu
                    opcode_o <= 7'b0010010;
                end
                3'b101:begin//lhu
                    opcode_o <= 7'b0010011;
                end
                endcase
            end
            7'b0100011:begin
                 wreg_o <= `WriDis;
                 wd_o <= inst_i[11:7];
                 funct3_o <= op2;
                 funct7_o <= `NoneFun7;
                 reg1_read_o <= `ReadEna;
                 reg2_read_o <= `ReadEna;
                 instvalid <= `InstValid;
                 
                 case (op2)
                 3'b000:begin//sb
                    opcode_o <= 7'b0010100;
                 end
                 3'b001:begin//sh
                    opcode_o <= 7'b0010101;
                    
                 end
                 3'b010:begin//sw
                    opcode_o <= 7'b0010110;
                 end
                 endcase
            end
                
            endcase
        end
    end
    
    always @ (*) begin
        if (rst == `RstEna) begin
            reg1_o <= `ZeroWord;
        end else if ((reg1_read_o == `ReadEna) && (ex_wreg_i == `ReadEna) && (ex_wd_i == reg1_addr_o) && (ex_wd_i != 5'b00000)) begin
            reg1_o <= ex_wdata_i;
        end else if ((reg1_read_o == `ReadEna) && (mem_wreg_i == `ReadEna) && (mem_wd_i == reg1_addr_o) && (mem_wd_i != 5'b00000)) begin
            reg1_o <= mem_wdata_i; 
        end else if (reg1_read_o == `ReadEna) begin
            reg1_o <= reg1_data_i;
        end else if (reg1_read_o == `ReadDis) begin
            reg1_o <= imm;
        end else begin 
            reg1_o <= 32'h00000000;
        end
    end
    
    always @ (*) begin
        if (rst == `RstEna) begin
            reg2_o <= `ZeroWord;
        end else if ((reg2_read_o == `ReadEna) && (ex_wreg_i == `ReadEna) && (ex_wd_i == reg2_addr_o) && (ex_wd_i != 5'b00000)) begin
            reg2_o <= ex_wdata_i;
        end else if ((reg2_read_o == `ReadEna) && (mem_wreg_i == `ReadEna) && (mem_wd_i == reg2_addr_o) && (mem_wd_i != 5'b00000)) begin
            reg2_o <= mem_wdata_i;
        end else if (reg2_read_o == `ReadEna) begin
            reg2_o <= reg2_data_i;
        end else if (reg2_read_o == `ReadDis) begin
            reg2_o <= imm;
        end else begin 
            reg2_o <= 32'h00000000;
        end
    end    
endmodule
