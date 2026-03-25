`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // tie off unused pins
    assign uio_oe = 8'b00000000;
    
    // prevent yosys from optimizing away uio_in by tying it to uio_out logically
    assign uio_out = 8'b00000000 | (uio_in & 8'b00000000);

    // ground unused outputs
    assign uo_out[7:1] = 7'b0000000;

    // 8-bit register for the counter
    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'd0;
        end else if (ena) begin
            counter <= counter + 1;
        end
    end

    // combinational logic for pwm output
    assign uo_out[0] = (counter < ui_in) ? 1'b1 : 1'b0;

endmodule
