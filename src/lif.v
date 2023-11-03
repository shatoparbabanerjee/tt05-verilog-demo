`default_nettype none

module lif (
    input wire [7:0] current,   // Input current, 8 bits wide
    input wire clk,             // Input clock signal
    input wire rst_n,           // Input reset signal (active low)
    output wire spike,          // Output spike signal
    output reg [7:0] state      // Output state register, 8 bits wide
);

    reg [7:0] threshold;        // Internal register for threshold value
    wire [7:0] next_state;      // Wire to compute the next state value

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;          // Reset the state to 0 when reset is active
            threshold <= 127;    // Set the threshold value to 127 during reset
        end else begin
            state <= next_state; // Update the state with the next_state value
        end
    end

    assign next_state = current + (state >> 1);   // Compute the next state as the sum of current and half of the current state
    assign spike = (state >= threshold);           // Determine if a spike should occur based on the state and threshold

endmodule