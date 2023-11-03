`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
// module tb ();

//     // this part dumps the trace to a vcd file that can be viewed with GTKWave
//     initial begin
//         $dumpfile ("tb.vcd");
//         $dumpvars (0, tb);
//         #1;
//     end

//     // wire up the inputs and outputs
//     reg  clk;
//     reg  rst_n;
//     reg  ena;
//     reg  [7:0] ui_in;
//     reg  [7:0] uio_in;

//     wire [6:0] segments = uo_out[6:0];
//     wire [7:0] uo_out;
//     wire [7:0] uio_out;
//     wire [7:0] uio_oe;

//     tt_um_lif tt_um_lif (
//     // include power ports for the Gate Level test
//     `ifdef GL_TEST
//         .VPWR( 1'b1),
//         .VGND( 1'b0),
//     `endif
//         .ui_in      (ui_in),    // Dedicated inputs
//         .uo_out     (uo_out),   // Dedicated outputs
//         .uio_in     (uio_in),   // IOs: Input path
//         .uio_out    (uio_out),  // IOs: Output path
//         .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
//         .ena        (ena),      // enable - goes high when design is selected
//         .clk        (clk),      // clock
//         .rst_n      (rst_n)     // not reset
//         );

// endmodule

module tb ();

    // Dump the trace to a VCD file for waveform viewing
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        #1;
    end

    // Wire up the inputs and outputs for LIF neuron and top module
    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;

    wire spike;             // Spike output from LIF module
    wire [7:0] state;       // State output from LIF module

    wire [6:0] segments = uo_out[6:0];
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the LIF neuron
    lif lif1 (
        .current(ui_in),
        .clk(clk),
        .rst_n(rst_n),
        .spike(spike),
        .state(state)
    );

    // Instantiate the top module
    tt_um_lif tt_um_lif (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        $display("Time\tCurrent\tState\tSpike");
        $display("----------------------------");

        // Reset the system
        rst_n = 0;
        ena = 0;
        ui_in = 8'h00;
        uio_in = 8'h00;
        #10 rst_n = 1;
        ena = 1;

        // Test with different current values
        for (int i = 0; i <= 255; i = i + 1) begin
            ui_in = i;
            #10 $display("%d\t%h\t%h\t%d", $time, ui_in, state, spike);
        end

        // Finish simulation
        $finish;
    end

endmodule
