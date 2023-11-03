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
                if (tm_counter == 2'b11) begin
                    state <= next_state[0];
                    spike[0] <= (state >= threshold[0]);
                end
            end
            tm_counter <= tm_counter + 1;
        end
    end

    generate
        for(int i = 0; i < 8; i = i + 1) begin : neuron_instances
            assign next_state[i] = current + (state >> 1);
            assign spike[i] = (state >= threshold[i]);
        end
    endgenerate

endmodule