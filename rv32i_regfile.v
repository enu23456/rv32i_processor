//! @file  rv32i_regfile.v
//! @brief 汎用レジスタのwrite/readモジュール

/// @brief 汎用レジスタのwrite/readモジュール
module RegisterFile(
    input clk,
    input rst,
    input [4:0] reg_r0,
    input [4:0] reg_r1,
    input [4:0] reg_w0,
    input [31:0] in,
    input write,
    output [31:0] out_0, 
    output [31:0] out_1
    );

    wire [31:0] x10 = regs[10];
    wire [31:0] x11 = regs[11];
    wire [31:0] x12 = regs[12];
    wire [31:0] x13 = regs[13];
    wire [31:0] x14 = regs[14];
    wire [31:0] x15 = regs[15];
    wire [31:0] x16 = regs[16];
    wire [31:0] x17 = regs[17];
    wire [31:0] x18 = regs[18];
    wire [31:0] x19 = regs[19];

    reg [31:0] regs[0:31];
    assign out_0 = regs[reg_r0];
    assign out_1 = regs[reg_r1];
    always @(posedge clk) begin
        if (!rst) begin
            regs[0] <= 32'b0;
            regs[1] <= 32'b0;
            regs[2] <= 32'b0;
            regs[3] <= 32'b0;
            regs[4] <= 32'b0;
            regs[5] <= 32'b0;
            regs[6] <= 32'b0;
            regs[7] <= 32'b0;
            regs[8] <= 32'b0;
            regs[9] <= 32'b0;
            regs[10] <= 32'b0;
            regs[11] <= 32'b0;
            regs[12] <= 32'b0;
            regs[13] <= 32'b0;
            regs[14] <= 32'b0;
            regs[15] <= 32'b0;
            regs[16] <= 32'b0;
            regs[17] <= 32'b0;
            regs[18] <= 32'b0;
            regs[19] <= 32'b0;
            regs[20] <= 32'b0;
            regs[21] <= 32'b0;
            regs[22] <= 32'b0;
            regs[23] <= 32'b0;
            regs[24] <= 32'b0;
            regs[25] <= 32'b0;
            regs[26] <= 32'b0;
            regs[27] <= 32'b0;
            regs[28] <= 32'b0;
            regs[29] <= 32'b0;
            regs[30] <= 32'b0;
            regs[31] <= 32'b0;
        end else begin
            if(write) begin
                regs[reg_w0] <= in;
                regs[0] <= 32'b0;
            end
        end
    end
endmodule
