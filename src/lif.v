`default_nettype none

module lif (
  input wire clk,         // Clock input
  input wire rst_n,       // Reset input
  input wire [7:0] Isyn,  // Synaptic current input (8-bit current)
  output wire spike       // Spike output
);

  reg [7:0] I_accumulator; // Current accumulator
  reg sp;              // Spike signal
  reg refractory_period = 8; // Refractory period in clock cycles
  //reg [7:0] I_accumulator_2;

  assign spike = sp;
  parameter I_threshold = 8'b100;  // Firing threshold
  parameter tau = 4'b0010;         // Time constant for current decay
  
  always @(posedge clk) begin
    if (rst_n) begin
      I_accumulator <= 8'b0;
      sp <= 1'b0;
    end else begin
      // Update the current accumulation
      if (I_accumulator > 8'b0) begin
        I_accumulator <= I_accumulator - (I_accumulator >> tau) + Isyn;
      end else begin
        I_accumulator <= I_accumulator + Isyn;
      end
      // Check for firing
      I_accumulator <= (sp) ? I_threshold : I_accumulator;
    //   if (I_accumulator_2 >= I_threshold) begin
    //     sp <= 1'b1;
    //     I_accumulator_2 <= 8'b0; // Reset the current accumulation
    //   end
    end
    
    // Refractory period countdown
    if (refractory_period > 0) begin
      if (sp) begin
        sp <= 1'b0;
        refractory_period <= refractory_period - 1;
      end
    end
  end

endmodule
