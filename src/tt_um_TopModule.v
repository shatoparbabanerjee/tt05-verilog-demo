`default_nettype none

module tt_um_TopModule (
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

    wire [7:0] state_signals;
    wire [7:0] state_signals2;
    wire [7:0] state_signals3;

    assign uio_in[7:0] = state_signals[7:0];  

    // Instantiate the segment display module
    LIFNeuron lif1(.clk(clk), .rst_n(rst_n), .Isyn(state_signals), .spike(uio_out[7]));
    LIFNeuron lif2(.clk(clk), .rst_n(rst_n), .Isyn(state_signals2), .spike(uio_out[6]));
    LIFNeuron lif3(.clk(clk), .rst_n(rst_n), .Isyn(state_signals3), .spike(uio_out[5]));

endmodule