`default_nettype none

// module tt_um_lif (
//     input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
//     output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
//     input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
//     output wire [7:0] uio_out,  // IOs: Bidirectional Output path
//     output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
//     input  wire       ena,      // will go high when the design is enabled
//     input  wire       clk,      // clock
//     input  wire       rst_n     // reset_n - low to reset
// );

//     assign uio_oe = 8'b11111111;
//     assign uio_out[6:0] = 7'd0;


//     // instantiate segment display
//    lif lif1(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[7]), .state(uo_out));
//    //lif lif2(.current({uio_out[7], 7'b0000000}), .clk(clk), .rst_n(rst_n), .spike(uio_out[6]), .state(uo_out));

// endmodule


module tt_um_lif (
    input wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input wire ena,      // will go high when the design is enabled
    input wire clk,      // clock
    input wire rst_n     // reset_n - low to reset
);

    assign uio_oe = 8'b11111111;
    assign uio_out[6:0] = 7'd0;

    wire [7:0] spike [0:7];
    wire [7:0] state [0:7];

    lif tm_lif_inst[0:7](
        .current(ui_in),
        .clk(clk),
        .rst_n(rst_n),
        .spike(spike),
        .state(state)
    );

    assign uo_out = spike;
    assign uio_out[7] = ena;

endmodule
