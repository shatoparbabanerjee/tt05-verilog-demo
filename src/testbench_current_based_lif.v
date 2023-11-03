`default_nettype none
`timescale 1ns/1ns

module testbench_current_based_lif;

    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg ena;
    reg clk;
    reg rst_n;

    // Instantiate the DUT (Design Under Test)
    current_based_lif dut (
        .synaptic_current(ui_in),
        .clk(clk),
        .rst_n(rst_n),
        .spike(uo_out[7]),
        .membrane_potential(uo_out[6:0])
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Reset generation and initialization
    initial begin
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        #10 rst_n = 1;
        #10 ena = 1;
    end

    // Test stimulus generation
    initial begin
        // Case 1: No spike expected
        ui_in = 0;
        #100;
        if (uo_out[7] === 1) $display("Error: Spike detected when not expected (Case 1)");

        // Case 2: Spike expected
        ui_in = 127;
        #100;
        if (uo_out[7] === 0) $display("Error: Spike not detected when expected (Case 2)");

        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end

endmodule
