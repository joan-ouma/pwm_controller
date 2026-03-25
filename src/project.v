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

    // we have to trick yosys into keeping uio_in so it doesnt fail precheck
    // passing it directly to uio_out forces the synthesizer to keep the wires
    assign uio_out = uio_in;
    
    // disable the bidirectional pins since we aren't using them
    assign uio_oe  = 8'b00000000;

    // we only need uo_out[0] for our pwm signal. ground the rest.
    assign uo_out[7:1] = 7'b0000000;

    // --- pwm logic ---

    // 8-bit register to hold our current count
    reg [7:0] counter;

    // sequential logic: this block only runs on the rising edge of the clock
    always @(posedge clk or negedge rst_n) begin
        // if the reset button is pressed (active low), clear the counter
        if (!rst_n) begin
            counter <= 8'd0;
        end else if (ena) begin
            // otherwise, increment the counter by 1
            counter <= counter + 1;
        end
    end

    // combinational logic: this happens instantly, all the time
    // we use the 8 input switches (ui_in) to set our requested duty cycle
    assign uo_out[0] = (counter < ui_in) ? 1'b1 : 1'b0;

endmodule
