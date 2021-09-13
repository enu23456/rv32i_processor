//! @file  rv32i_comparator.v
//! @brief 分岐命令のための、２つの値の比較を行うモジュール

/// @brief 分岐命令のための、２つの値の比較を行うモジュール
module Comparator(
    input [31:0] in_a,
    input [31:0] in_b,
    input [2:0] type,
    input [2:0] val_type,
    output reg ld
    );
    wire  [31:0] a_signed;
    wire  [31:0] b_signed;
    assign a_signed = $signed(in_a);
    assign b_signed = $signed(in_b);

    always @ (*) begin
        if (val_type == 3'b011) begin
            case (type)
            3'b000: ld = (in_a == in_b) ? 1'b1 : 1'b0;
            3'b001: ld = (in_a != in_b) ? 1'b1 : 1'b0;
            3'b100: ld = (a_signed < b_signed) ? 1'b1 : 1'b0;
            3'b101: ld = (a_signed >= b_signed) ? 1'b1 : 1'b0;
            3'b110: ld = (in_a < in_b) ? 1'b1 : 1'b0;
            3'b111: ld = (in_a >= in_b) ? 1'b1 : 1'b0;
            endcase
        end else if (val_type == 3'b100) begin
            ld = 1;
        end else begin
            ld = 0;
        end
    end
endmodule
