//! @file  rv32i_selector.v
//! @brief ALUの入力を選択するモジュール

/// @brief ALUの入力を選択するモジュール
module Selector (
    input [31:0] rs1,
    input [31:0] rs2,
    input [31:0] imm,
    input [31:0] pc,
    input [2:0] val_sel,
    output reg [31:0] out_a,
    output reg [31:0] out_b
);

    always @* begin
        case (val_sel)
            3'b001: begin
                out_a = rs1;
                out_b = imm;
            end
            3'b010: begin
                out_a = rs1;
                out_b = rs2;
            end
            3'b011: begin
                out_a = pc;
                out_b = imm;
            end
            3'b100: begin
                out_a = pc;
                out_b = imm;
            end
            3'b101: begin
                out_a = rs1;
                out_b = imm;
            end
            3'b110: begin
                out_a = rs1;
                out_b = imm;
            end
            default : out_b = 4'b0000;
        endcase
    end
    
endmodule
