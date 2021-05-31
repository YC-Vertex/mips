`timescale 1ns/1ps
`define PERIOD 10

module TESTBENCH;

    reg clk;
    reg nrst;

    TOP mips(clk, nrst);

    initial begin
        clk = 1'b1;
        #(`PERIOD * 2.1) nrst = 1'b0;
        #(`PERIOD * 2) nrst <= 1'b1;
        #(`PERIOD * 2) nrst = 1'b0;
        #(`PERIOD * 2) nrst <= 1'b1;
    end

    always #(`PERIOD) clk = ~clk;

endmodule