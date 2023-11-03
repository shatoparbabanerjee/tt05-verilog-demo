`default_nettype none

module tm_lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output wire [7:0] spike,
    output wire [7:0] state
);

    reg [7:0] threshold;
    reg [7:0] next_state;
    reg [2:0] tm_counter;
    
    integer i; // Declare i outside the loop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                state[i] <= 0;
                threshold[i] <= 8'b01111111; // Correct threshold initialization
                next_state[i] <= 0;
            end
            tm_counter <= 0;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                if (tm_counter == i) begin
                    next_state[i] <= state[i] + (current >> 1); // Fixed state update equation
                end
                spike[i] <= (next_state[i] >= threshold[i]);
            end
            tm_counter <= (tm_counter + 1) % 8; // Updated counter
        end
    end

endmodule
