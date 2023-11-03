`default_nettype none

module tt_um_lif (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7-segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Input enable signal, active high
    input  wire       clk,      // Input clock signal
    input  wire       rst_n     // Input reset signal (active low)
);

    assign uio_oe = 8'b11111111;      // Set all bits of the bidirectional enable path to 1, indicating they are in output mode
    assign uio_out[4:0] = 5'd0;       // Initialize the 7-segment display output to all zeros

    wire state_signals[7:0]; // another array
    assign state_signals [4:0] = 5'b00000;

    // Instantiate the segment display module
    lif lif1(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[7]), .state(state_signals[7]));
    lif lif2(.current({uio_out[7], 7'b0000000}), .clk(clk), .rst_n(rst_n), .spike(uio_out[6]), .state(state_signals[6]));
    lif lif3(.current({uio_out[6], 7'b0000000}), .clk(clk), .rst_n(rst_n), .spike(uio_out[5]), .state(state_signals[5]));


    assign uo_out [7:0] = state_signals [7:0];

endmodule