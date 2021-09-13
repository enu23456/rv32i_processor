//! @file  rv32i_alu.v
//! @brief 各種算術演算を行うモジュール

/// @brief 各種算術演算を行うモジュール
module Alu(
    input wire [3:0] sel,
    input wire [31:0] in_a,
    input wire [31:0] in_b,
    output reg [31:0] out
    );

    wire [31:0] a_signed;
    wire [31:0] b_signed;
    assign a_signed = $signed(in_a);
    assign b_signed = $signed(in_b);

    always @ (*) begin
        case (sel)
            4'b0000: out = in_a + in_b;  //add, addi
            4'b0010: out = a_signed < b_signed ? 1 : 0;  // slt, slti
            4'b0011: out = in_a < in_b ? 1 : 0;  // sltu, sltiu
            4'b0100: out = in_a ^ in_b;  // xor, xori
            4'b0110: out = in_a | in_b;  // or, ori
            4'b0111: out = in_a & in_b;  // and, andi
            4'b0001: out = in_a << in_b;  // sll, slli
            4'b0101: out = in_a >> in_b;  // srl, srli
            4'b1101: out = a_signed >> in_b;  // sra, srai
            4'b1000: out = in_a - in_b;  // sub
            default: out = 32'h00000000;
        endcase
    end
endmodule
