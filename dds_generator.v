
module dds_generator #(
    parameter PHASE_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input wire clk,
    input wire rst,
    input wire [PHASE_WIDTH-1:0] delta_phase,
    output reg signed [15:0] sin_out
);
    reg [PHASE_WIDTH-1:0] phase_acc = 0;
    wire [ADDR_WIDTH-1:0] rom_addr = phase_acc[PHASE_WIDTH-1:PHASE_WIDTH-ADDR_WIDTH];

always @(posedge clk) begin
    if (rst) begin
        phase_acc <= 0;      
        sin_out    <= 16'd0;  
    end else begin
        phase_acc <= phase_acc + delta_phase;
    end
end

    reg signed [15:0] sin_rom [0:(1<<ADDR_WIDTH)-1];
    initial $readmemh("sin1024.hex", sin_rom);

    always @(posedge clk) begin
        sin_out <= sin_rom[rom_addr];
    end
endmodule
