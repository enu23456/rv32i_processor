//! @file  rv32i.v
//! @brief トップモジュール。ProgramMemoryに書かれている内容に応じて処理を行う

`include "rv32i_pc.v"
`include "rv32i_pmem.v"
`include "rv32i_dmem.v"
`include "rv32i_decoder.v"
`include "rv32i_regfile.v"
`include "rv32i_selector.v"
`include "rv32i_alu.v"
`include "rv32i_comparator.v"

/// @brief トップモジュール。ProgramMemoryに書かれている内容に応じて処理を行う
module RV32I(
    input clk,
    input reset,
    output [31: 0] alu_out
    );
    wire [31:0] adder;
    wire [31:0] inst;
    wire [3:0] alu_sel;
    wire [2:0] val_sel;
    wire [1:0] regw_type;
    wire [2:0] funct3;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [31:0] imm;
    wire [31:0] out_0;
    wire [31:0] out_1;
    wire [31:0] alu_in1;
    wire [31:0] alu_in2;
    wire  ld;
    wire [31:0] loaded;

    ProgramCounter pc(.clk(clk), .reset(reset), .in(alu_out), .ld(ld), .out(adder));
    ProgramMemory pmem(.address(adder), .data(inst));
    DataMemory dmem(.clk(clk), .addr(alu_out), .in(out_1), .mode(funct3), .write(val_sel == 3'b110 ? 1'b1 : 1'b0), .out(loaded));
    Decoder dec(.inst(inst), .alu_sel(alu_sel), .val_sel(val_sel), .regw_type(regw_type), .funct3(funct3), .imm(imm), .rd(rd), .rs1(rs1), .rs2(rs2));
    RegisterFile rf(.clk(clk), .rst(reset), .reg_r0(rs1), .reg_r1(rs2), .reg_w0(rd), .in((regw_type != 2'b10) ? ((regw_type == 2'b01) ? loaded : alu_out) : adder+4), .write(1'b1), .out_0(out_0), .out_1(out_1));
    Selector selector(.rs1(out_0), .rs2(out_1), .imm(imm), .pc(adder), .val_sel(val_sel), .out_a(alu_in1), .out_b(alu_in2));
    Alu alu(.sel(alu_sel), .in_a(alu_in1), .in_b(alu_in2), .out(alu_out));
    Comparator comparator(.in_a(out_0), .in_b(out_1), .type(funct3), .val_type(val_sel), .ld(ld));
endmodule

`timescale 1ns/1ns
/// @brief RV32Iのテストベンチ
module RV32I_tb();
    reg [9: 0] cnt;
    reg clk;
    reg reset;
    wire [31: 0] alu_out;
    RV32I rv32i(clk, reset, alu_out);

    initial begin
        $monitor("cnt: %d .. clk: %b, reset: %b .. alu_out = %x", cnt, clk, reset, alu_out);
        $dumpfile("rv32i.vcd");
        $dumpvars(0, rv32i);
    end

    always begin
        #1 clk = ~clk;
        cnt += (clk == 1) ? 1 : 0;
    end

    initial begin
        cnt = 0;
        clk = 0;
        reset = 0;
        #4
        reset = 1;
        #150
        $finish;
    end
endmodule