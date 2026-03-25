`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Prevent linter warnings about unused input pins
    wire _unused = &{uio_in, 1'b0};

    // Disable the bidirectional pins since we aren't using them
    assign uio_oe  = 8'b00000000;
    assign uio_out = 8'b00000000;

    // We only need uo_out[0] for our PWM signal. Ground the rest.
    assign uo_out[7:1] = 7'b0000000;

    // --- PWM Logic ---

    // 8-bit register to hold our current count
    reg [7:0] counter;

    // Sequential logic: this block only runs on the rising edge of the clock
    always @(posedge clk or negedge rst_n) begin
        // If the reset button is pressed (active low), clear the counter
        if (!rst_n) begin
            counter <= 8'd0;
        end else if (ena) begin
            // Otherwise, increment the counter by 1
            counter <= counter + 1;
        end
    end

    // Combinational logic: this happens instantly, all the time
    // We use the 8 input switches (ui_in) to set our requested duty cycle
    assign uo_out[0] = (counter < ui_in) ? 1'b1 : 1'b0;

endmodule
