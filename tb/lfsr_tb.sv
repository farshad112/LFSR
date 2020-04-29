`timescale 1ns/1ps

module lfsr_tb;
    parameter LFSR_LENGTH = 4;
    parameter LFSR_SEED_VAL = 4'b1011;
    parameter LFSR_PRIM_POLY = 4'b1101;  // 1+x^3+x^4

    logic clk;
    logic resetn;
    logic lfsr_en;
    logic lfsr_out;
    logic [3:0] lfsr_out_buf;
    logic [3:0] lfsr_state_out;

    // clock generation
    initial begin
        clk = 0;
        forever begin
            #10ns clk = ~clk;
        end
    end

    // test block
    initial begin
        resetn = 0;
        lfsr_en = 0;

        repeat(2)
            @(posedge clk);
        resetn = 1;
        lfsr_en = 1;
    end

    // record lfsr internal states
    initial begin
        $monitor("lfsr:%0d", lfsr_state_out);
    end

    // finish simulation
    initial begin
        #1000ns;
        $finish();
    end

    // Instantiation of DUT
    lfsr #(
                // Parameters
                .LFSR_LENGTH(LFSR_LENGTH),
                .LFSR_PRIM_POLY(LFSR_PRIM_POLY),  // tap on 3 i.e. 1+x^3+x^4
                .LFSR_SEED_VAL(LFSR_SEED_VAL)
            )DUT (
                // IO ports
                .lfsr_clk(clk),                     // input
                .resetn(resetn),                    // input
                .lfsr_en(lfsr_en),                  // input
                .lfsr_state_out(lfsr_state_out),    // output
                .lfsr_out(lfsr_out)                 // output
            );
endmodule