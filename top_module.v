
module top_module(
    input clk,
    input rst,
    output signed [15:0] sig1,
    output signed [15:0] sig2,
    output reg signed [16:0] dds_out,
    output signed [31:0] fir_out
);
    wire signed [16:0] mixed;
    reg signed [16:0] mixed_reg;      // 新增寄存器
    
    dds_generator dds1(
        .clk(clk),
        .rst(rst),
        .delta_phase(32'd83886080),   // 2 MHz
        .sin_out(sig1)
    );

    dds_generator dds2(
        .clk(clk),
        .rst(rst),
        .delta_phase(32'd8388608),    // 200 kHz
        .sin_out(sig2)
    );

    assign mixed = sig1 + sig2;
    
    // 同步到时钟沿
    always @(posedge clk) begin
        if (rst) begin
            mixed_reg <= 17'd0;
            dds_out   <= 17'd0;
        end else begin
            mixed_reg <= mixed;
            dds_out   <= mixed_reg;   // 延迟一级，保持时序一致性
        end
    end

    fir_filter fir(
        .clk(clk),
        .rst(rst),
        .data_in(mixed_reg),         // 使用寄存器输出
        .data_out(fir_out)
    );
endmodule
