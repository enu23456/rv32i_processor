//! @file  rv32i_pmem.v
//! @brief プログラムデータの読み出しを行うモジュール

/// @brief プログラムデータの読み出しを行うモジュール

module ProgramMemory (
    input [31:0] address,
    output reg [31:0] data
    );
    localparam LENGTH = 256; //0x200
    reg [7: 0] mem[LENGTH-1: 0];
    
    always @(*) begin
        data = {mem[address+3], mem[address+2], mem[address+1], mem[address]};
    end

    integer i;
    initial begin
        for(i = 0; i < LENGTH; i = i + 1) begin
           mem[i] = 0;
        end
        mem[8'h00] = 8'h13; // write
        mem[8'h01] = 8'h05;
        mem[8'h02] = 8'h00;
        mem[8'h03] = 8'h20;
        mem[8'h04] = 8'h93; // write
        mem[8'h05] = 8'h05;
        mem[8'h06] = 8'h40;
        mem[8'h07] = 8'h00;
        mem[8'h08] = 8'h93; // write
        mem[8'h09] = 8'h06;
        mem[8'h0A] = 8'h40;
        mem[8'h0B] = 8'h20;
        mem[8'h0C] = 8'h13; // write
        mem[8'h0D] = 8'h07;
        mem[8'h0E] = 8'h10;
        mem[8'h0F] = 8'h00;
        mem[8'h10] = 8'h63; // write
        mem[8'h11] = 8'h64;
        mem[8'h12] = 8'hB7;
        mem[8'h13] = 8'h00;
        mem[8'h14] = 8'h6F; // write
        mem[8'h15] = 8'h00;
        mem[8'h16] = 8'h00;
        mem[8'h17] = 8'h04;
        mem[8'h18] = 8'h03; // write
        mem[8'h19] = 8'hA8;
        mem[8'h1A] = 8'h06;
        mem[8'h1B] = 8'h00;
        mem[8'h1C] = 8'h13; //
        mem[8'h1D] = 8'h86;
        mem[8'h1E] = 8'h06;
        mem[8'h1F] = 8'h00;
        mem[8'h20] = 8'h93; //
        mem[8'h21] = 8'h07;
        mem[8'h22] = 8'h07;
        mem[8'h23] = 8'h00;
        mem[8'h24] = 8'h83; //
        mem[8'h25] = 8'h28;
        mem[8'h26] = 8'hC6;
        mem[8'h27] = 8'hFF;
        mem[8'h28] = 8'h63; //
        mem[8'h29] = 8'h5A;
        mem[8'h2A] = 8'h18;
        mem[8'h2B] = 8'h01;
        mem[8'h2C] = 8'h23; //
        mem[8'h2D] = 8'h20;
        mem[8'h2E] = 8'h16;
        mem[8'h2F] = 8'h01;
        mem[8'h30] = 8'h93; //
        mem[8'h31] = 8'h87;
        mem[8'h32] = 8'hF7;
        mem[8'h33] = 8'hFF;
        mem[8'h34] = 8'h13; //
        mem[8'h35] = 8'h06;
        mem[8'h36] = 8'hC6;
        mem[8'h37] = 8'hFF;
        mem[8'h38] = 8'hE3; //
        mem[8'h39] = 8'h96;
        mem[8'h3A] = 8'h07;
        mem[8'h3B] = 8'hFE;
        mem[8'h3C] = 8'h93; // write
        mem[8'h3D] = 8'h97;
        mem[8'h3E] = 8'h27;
        mem[8'h3F] = 8'h00;
        mem[8'h40] = 8'hB3; //
        mem[8'h41] = 8'h07;
        mem[8'h42] = 8'hF5;
        mem[8'h43] = 8'h00;
        mem[8'h44] = 8'h23; //
        mem[8'h45] = 8'hA0;
        mem[8'h46] = 8'h07;
        mem[8'h47] = 8'h01;
        mem[8'h48] = 8'h13; //
        mem[8'h49] = 8'h07;
        mem[8'h4A] = 8'h17;
        mem[8'h4B] = 8'h00;
        mem[8'h4C] = 8'h93; //
        mem[8'h4D] = 8'h86;
        mem[8'h4E] = 8'h46;
        mem[8'h4F] = 8'h00;
        mem[8'h50] = 8'h6F; //
        mem[8'h51] = 8'hF0;
        mem[8'h52] = 8'h1F;
        mem[8'h53] = 8'hFC;
        mem[8'h54] = 8'h6F; //
        mem[8'h55] = 8'h00;
        mem[8'h56] = 8'h00;
        mem[8'h57] = 8'h00;
    end
endmodule
