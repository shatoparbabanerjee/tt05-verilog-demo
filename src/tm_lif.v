`default_nettype none

module tm_lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output wire [7:0] spike,
    output wire [7:0] state
);

    wire [7:0] threshold [7:0];
    wire [7:0] next_state [7:0];
    reg [2:0] tm_counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            for (int i = 0; i < 8; i = i + 1) begin
                state[i] <= 0;
                threshold[i] <= 127;
                next_state[i] <= 0;
            end
            tm_counter <= 0;
        end else begin
            for (int i = 0; i < 8; i = i + 1) begin
                if (tm_counter == i) begin
                    next_state[i] <= state[i]; 
                end
                spike[i] <= (next_state[i] >= threshold[i]);
            end
            tm_counter <= tm_counter + 1;
        end
    end

    always @* begin
        for (int i = 0; i < 8; i = i + 1) begin
            next_state[i] = current + (state[i] >> 1);
        end
    end

endmodule
