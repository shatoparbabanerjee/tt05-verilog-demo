module lif (
    input wire [7:0] current,
    output wire [7:0] state,
    output wire spike,
    input wire clk,
    input wire rst_n
);

    reg [7:0] next_state, threshold;
    // resting potential and threshold
    assign next_state = current + (state >> 1);
    assign spike = (state >= threshold);

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 127;
        end else begin
            state <= next_state;
        end
    
    // next_state logic 
    assign next_state = current + (state >> 1); 

    //spiking 
    assign spike = (state >= threshold);
    

endmodule

