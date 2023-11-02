`default_nettype none

module lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output wire spike,
    output wire [7:0] state
);

    reg [7:0] threshold; 
    reg [3:0] beta; 
    wire [7:0] next_state;
    // resting potential and threshold

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 127;
        end else begin
            state <= next_state;
        end
    end
    
    
    // next_state logic 
    assign next_state = current + ( spike ? 0 : (state >> 1));

    //spiking 
    assign spike = (state >= threshold);
    
endmodule

