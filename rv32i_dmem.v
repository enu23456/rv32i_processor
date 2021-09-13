//! @file  rv32i_dmem.v
//! @brief データの読み書きを行うモジュール

/// @brief データの読み書きを行うモジュール
module DataMemory(
    input clk,
    input [31:0] addr,
    input [31:0] in,
    input [2:0] mode,
    input write,
    output [31:0] out
    );
    localparam LENGTH = 1024;
    reg [7:0] data[LENGTH-1:0];
    wire [9:0] addr_valid = addr[9:0];

    wire [7:0] data_addr = data[addr_valid];  // for Debug
    wire [7:0] data_addr512 = data[512];  // for Debug
    wire [7:0] data_addr516 = data[516];  // for Debug
    wire [7:0] data_addr520 = data[520];  // for Debug
    wire [7:0] data_addr524 = data[524];  // for Debug

    wire [31:0] out8s = {(data[addr_valid][7] == 1) ? 24'hFFFFFF : 24'h000000, data[addr_valid]};
    wire [31:0] out16s = {(data[addr_valid+1][7] == 1) ? 16'hFFFF : 16'h0000, data[addr_valid + 1], data[addr_valid]};
    wire [31:0] out32 =  {data[addr_valid + 3], data[addr_valid + 2], data[addr_valid + 1], data[addr_valid]};
    wire [31:0] out8u = {24'h000000, data[addr_valid]};
    wire [31:0] out16u = {16'h0000, data[addr_valid + 1], data[addr_valid]};
    assign out = (mode == 3'b000) ? out8s : (mode == 3'b001) ? out16s : (mode == 3'b010) ? out32 : (mode == 3'b100) ? out8u : out16u;

    always @(posedge clk) begin
        if(write) begin
            if (mode == 3'b000) begin
                data[addr_valid] <= in[7:0];
            end else if (mode == 3'b001) begin
                data[addr_valid + 1] <= in[15:8];
                data[addr_valid] <= in[7:0];
            end else if (mode == 3'b010) begin
                data[addr_valid + 3] <= in[31:24];
                data[addr_valid + 2] <= in[23:16];
                data[addr_valid + 1] <= in[15:8];
                data[addr_valid] = in[7:0];
            end else begin
            end
        end
    end

    integer i;
    initial begin
        for(i = 0; i < LENGTH; i = i + 1) begin
           data[i] = 0;
        end
        data[10'd512] = 6;
        data[10'd516] = 4;
        data[10'd520] = 7;
        data[10'd524] = 1;
    end
endmodule
