`default_nettype none

module current_based_lif (
    input wire [7:0] input_current, // Input current, 8 bits wide
    input wire clk,                // Input clock signal
    input wire rst_n,              // Input reset signal (active low)
    output wire spike,             // Output spike signal
    output reg [7:0] state         // Internal state register
);

    parameter I_thresh = 8'h80;    // Threshold current, adjust as needed

    wire [7:0] next_state;   // next_state signal, 8 bits wide

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 8'h00;          // Reset the state to 0 when reset is active
        end else begin
            state <= next_state;     // Update the state with the next_state value
        end
    end

    // Add logic to increment or decrement the state based on input_current
    always @(*) begin
        if (input_current >= I_thresh) begin
            next_state = state - 8'h01; // Decrement the state
        end else begin
            next_state = state + input_current; // Increment the state based on input_current
        end
    end

    // Determine if a spike should occur based on the state and threshold
    assign spike = (state >= I_thresh);

endmodule