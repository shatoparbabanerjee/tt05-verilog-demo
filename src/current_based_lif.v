`default_nettype none

module current_based_lif (
    input wire [7:0] synaptic_current,
    input wire clk,
    input wire rst_n,
    output wire spike,
    output reg [7:0] membrane_potential
);

    reg [7:0] threshold;  
    wire [7:0] next_membrane_potential;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            membrane_potential <= 8'b0;
            threshold <= 8'h7F; // Threshold value (adjust as needed)
        end else begin
            membrane_potential <= next_membrane_potential;
        end
    end

    // Leaky integration
    assign next_membrane_potential = membrane_potential + (synaptic_current >> 1);

    // Check for spike generation
    assign spike = (membrane_potential >= threshold);

endmodule