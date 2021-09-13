//! @file  rv32i_decoder.v
//! @brief instructionをopcodeやimmなどに分解するモジュール

/// @brief instructionをopcodeやimmなどに分解するモジュール
module Decoder(
    input [31:0] inst,
    output reg [3:0] alu_sel,
    output reg [2:0] val_sel,
    output reg [1:0] regw_type,
    output [2:0]funct3,
    output reg [31:0] imm,
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2
    );
    wire [6:0] opcode;
    wire [6:0] funct7;

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = (opcode == 7'b1101100) ? inst[31:25] : 0;

    always @(*) begin
        case(opcode)
            // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
            7'b0010011: begin
                rd = inst[11:7];
                rs1 = inst[19:15];
                val_sel = 3'b001;
                case(funct3)
                    3'bx01: begin
                        imm = {27'b0, inst[24:20]};
                        alu_sel = {inst[30], funct3};
                    end
                    3'b011: begin
                        imm = {20'b0, inst[31:20]};
                        alu_sel = {1'b0, funct3};
                    end
                    default: begin
                        imm = inst[31] == 0 ? {20'h00000, inst[31:20]} : {20'hFFFFF, inst[31:20]};
                        alu_sel = {1'b0, funct3};
                    end
                endcase
                regw_type = 2'b00; // rdにalu_outを書き込む
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            // add, sub, sll, slt, sltu, xor, srl, sra, or, and
            7'b0110011: begin
                rd = inst[11:7];
                rs1 = inst[19:15];
                rs2 = inst[24:20];
                alu_sel = {inst[30], funct3};
                val_sel = 3'b010;
                regw_type = 2'b00; // rdにalu_outを書き込む
                imm = 0;  // 使わないものをゼロにセットしておく
            end
            // beq, bne, blt, bltu, bge, bgeu
            7'b1100011: begin
                rs1 = inst[19:15];
                rs2 = inst[24:20];
                imm = {inst[31] == 0 ? 20'h00000 : 20'hFFFFF, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
                alu_sel = 4'b0000; // pcとimmを加算できるようにalu_selを設定。
                val_sel = 3'b011;
                regw_type = 2'b00; // rdにalu_outを書き込む
                rd = 0;  // 使わないものをゼロにセットしておく
            end
            // lui
            7'b0110111: begin
                rd = inst[11:7];
                imm = inst[31:12] << 12;
                rs1 = 0;  // imm + x[0]として実現する
                alu_sel = 4'b0000; // rs1(x[0]とimmを加算できるようにalu_selを設定。
                val_sel = 3'b001; // rs1(x[0]とimmを選択するようにval_selを設定。
                regw_type = 2'b00; // rdにalu_outを書き込む
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            // auipc
            7'b0010111: begin
                rd = inst[11:7];
                imm = inst[31:12] << 12;
                alu_sel = 4'b0000;  // pcとimmを加算できるようにalu_selを設定。
                val_sel = 3'b100; // pcとimmを選択するようにval_selを設定。
                regw_type = 2'b00; // rdにalu_outを書き込む
                rs1 = 0;  // 使わないものをゼロにセットしておく
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            // jal
            7'b1101111: begin
                rd = inst[11:7];
                imm = {inst[31] == 0 ? 12'h000 : 12'hFFF, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
                alu_sel = 4'b0000; // pcとimmを加算できるようにalu_selを設定。
                val_sel = 3'b100; // pcとimmを選択するようにval_selを設定。
                regw_type = 2'b10; // rdにpc+4を書き込む
                rs1 = 0;  // 使わないものをゼロにセットしておく
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            
            // jalr
            7'b1100111: begin
                rd = inst[11:7];
                rs1 = inst[19:15];
                imm = {inst[31] == 0 ? 20'h000 : 20'hFFF, inst[31:20]};
                alu_sel = 4'b0000; // pcとimmを加算できるようにalu_selを設定。
                val_sel = 3'b001; // rs1とimmを選択するようにval_selを設定。
                regw_type = 2'b10; // rdにpc+4を書き込む
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            
            // lb, lh, lw, lbu, lhu
            7'b0000011: begin
                rd = inst[11:7];
                rs1 = inst[19:15];
                imm = {inst[31] == 0 ? 20'h000 : 20'hFFFFF, inst[31:20]};
                alu_sel = 4'b0000; // rs1とimmを加算できるようにalu_selを設定。
                val_sel = 3'b101;
                regw_type = 2'b01; // rd にdmemからloadしたものを書き込む
                rs2 = 0;  // 使わないものをゼロにセットしておく
            end
            // sb, sh, sw
            7'b0100011: begin
                rs1 = inst[19:15];
                rs2 = inst[24:20];
                imm = {inst[31] == 0 ? 20'h000 : 20'hFFFFF, inst[31:25], inst[11:7]};
                alu_sel = 4'b0000; // rs1とimmを加算できるようにalu_selを設定。
                val_sel = 3'b110;
                regw_type = 0;  // 使わないものをゼロにセットしておく
                rd = 0;  // 使わないものをゼロにセットしておく
            end
            default: begin
                rd = 0;  // 使わないものをゼロにセットしておく
                rs1 = 0;  // 使わないものをゼロにセットしておく
                rs2 = 0;  // 使わないものをゼロにセットしておく
                val_sel = 0;  // 使わないものをゼロにセットしておく
                regw_type = 2'b00;  // 使わないものをゼロにセットしておく
                imm = 0;  // 使わないものをゼロにセットしておく
            end
        endcase
    end
endmodule
