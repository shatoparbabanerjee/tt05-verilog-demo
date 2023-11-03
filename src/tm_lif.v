`default_nettype none

module tm_lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output wire [7:0] spike,
    output wire [7:0] state
);

    reg [7:0] threshold [7:0];
    wire [7:0] next_state [7:0];
    reg [2:0] tm_counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 127;
            tm_counter <= 0;
        end else begin
            for (int i = 0; i < 8; i = i + 1) begin
                if (tm_counter == i) begin
                    state <= next_state[i];
                    spike[i] <= (state >= threshold[i]);
                end
            end
            tm_counter <= tm_counter + 1;
        end
    end

    assign next_state[0] = current + (state >> 1);
    assign spike[0] = (state >= threshold[0]);
    assign next_state[1] = current + (state >> 1);
    assign spike[1] = (state >= threshold[1]);
    assign next_state[2] = current + (state >> 1);
    assign spike[2] = (state >= threshold[2]);
    assign next_state[3] = current + (state >> 1);
    assign spike[3] = (state >= threshold[3]);
    assign next_state[4] = current + (state >> 1);
    assign spike[4] = (state >= threshold[4]);
    assign next_state[5] = current + (state >> 1);
    assign spike[5] = (state >= threshold[5]);
    assign next_state[6] = current + (state >> 1);
    assign spike[6] = (state >= threshold[6]);
    assign next_state[7] = current + (state >> 1);
    assign spike[7] = (state >= threshold[7]);

endmodule