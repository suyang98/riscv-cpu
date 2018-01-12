`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/19 15:12:50
// Design Name: 
// Module Name: mem
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


module mem(
    input wire rst,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`RegBus] wdata_i,
    input wire[`OpCode] opcode_i,
    input wire[`DataAddrBus] mem_addr_i,
    input wire[`DataBus] mem_data_i,
    input wire[`RegBus] reg2_i,
    input wire[`Mask] mask_i,
    
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,
    output reg[`RegBus] mem_addr_o,
    output reg[`RegBus] mem_data_o,
    output wire[`Mask] mask_o,
    output reg mem_we_o,
    output reg mem_ce_o
    );
    
    wire[`RegBus] zero32;
    
    assign mask_o = mask_i;
    assign zero32 = `ZeroWord; 
    
    always @  (*) begin
        if (rst == `RstEna) begin
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriDis;
            wdata_o <= `ZeroWord;
            mem_addr_o <= `ZeroWord;
            mem_we_o <= `WriDis;  
            mem_data_o <= `ZeroWord;
            mem_ce_o <= 1'b0;
        end
        else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
            mem_we_o <= `WriDis;
            mem_addr_o <= `ZeroWord;
            mem_ce_o <= 1'b0;
            case (opcode_i)
             7'b0001111:begin//lb
                mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriDis;
                mem_ce_o <= `ChipEna;
                if (mask_o[3] == 1'b1) wdata_o <= {{25{mem_data_i[31]}}, mem_data_i[30:24]};
                if (mask_o[2] == 1'b1) wdata_o <= {{25{mem_data_i[23]}}, mem_data_i[22:16]};
                if (mask_o[1] == 1'b1) wdata_o <= {{25{mem_data_i[15]}}, mem_data_i[14:8]};
                if (mask_o[0] == 1'b1) wdata_o <= {{25{mem_data_i[7]}}, mem_data_i[6:0]};
             end
             7'b0010000:begin//lh
                mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriDis;
                mem_ce_o <= `ChipEna;
                if (mask_o == 4'b1100) wdata_o <= {{17{mem_data_i[31]}}, mem_data_i[30:16]};
                if (mask_o == 4'b0011) wdata_o <= {{17{mem_data_i[15]}}, mem_data_i[14:0]};
             end
             7'b0010001:begin//lw
                mem_addr_o <={mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriDis;
                mem_ce_o <= `ChipEna;
                wdata_o <= mem_data_i;
             end
             7'b0010010:begin//lbu
                mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriDis;
                mem_ce_o <= `ChipEna;
                if (mask_o == 4'b1000) wdata_o <= {mem_data_i[31], {24{1'b0}}, mem_data_i[31:24]};
                if (mask_o == 4'b0100) wdata_o <= {mem_data_i[23], {24{1'b0}}, mem_data_i[22:16]};
                if (mask_o == 4'b0010) wdata_o <= {mem_data_i[15], {24{1'b0}}, mem_data_i[14:8]};
                if (mask_o == 4'b0100) wdata_o <= {mem_data_i[7], {24{1'b0}}, mem_data_i[6:0]};
             end
             7'b0010011:begin//lhu
                mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriDis;
                mem_ce_o <= `ChipEna;
                if (mask_o == 4'b1100) wdata_o <= {mem_data_i[31], {16{1'b0}}, mem_data_i[30:16]};
                if (mask_o == 4'b0011) wdata_o <= {mem_data_i[15], {16{1'b0}}, mem_data_i[14:0]};
             end
             7'b0010100:begin//sb
                mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriEna;
                mem_ce_o <= `ChipEna;
                mem_data_o <= reg2_i;                
             end
             7'b0010101:begin//sh
                mem_addr_o<= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriEna;
                mem_ce_o <= `ChipEna;
                mem_data_o <= reg2_i;
             end
             7'b0010110:begin//sw
                mem_addr_o<= {mem_addr_i[31:2], 2'b00};
                mem_we_o <= `WriEna;
                mem_ce_o <= `ChipEna;
                mem_data_o <= reg2_i;
             end
            endcase
        end
    end
endmodule
