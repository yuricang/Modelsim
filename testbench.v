
`timescale 1ns/1ps

module testbench;
    reg clk = 0;
    reg rst = 1;
    wire signed [15:0] sig1;
    wire signed [15:0] sig2;
    wire signed [16:0] dds_out;
    wire signed [31:0] fir_out;

    always #4.8828125 clk = ~clk; // 102.4 MHz

    top_module uut (
        .clk(clk),
        .rst(rst),
        .sig1(sig1),
        .sig2(sig2),
        .dds_out(dds_out),
        .fir_out(fir_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        #100;
        rst = 0;
        #10_000_000;
        $finish;
    end
endmodule
