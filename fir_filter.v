
module fir_filter #(parameter N = 128)(
    input clk,
    input rst,
    input signed [16:0] data_in,
    output reg signed [31:0] data_out
);
    reg signed [16:0] shift_reg [0:N-1];
    reg signed [16:0] coeff [0:N-1];
    reg signed [31:0] acc;
    integer i;
    initial $readmemh("fir_coeff.hex", coeff);
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) shift_reg[i] <= 0;
            data_out <= 0;
        end else begin
            for (i = N-1; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= data_in;

            acc = 0;
            for (i = 0; i < N; i = i + 1)
                acc = acc + shift_reg[i] * coeff[i];
            data_out <= acc;
        end
    end

endmodule
