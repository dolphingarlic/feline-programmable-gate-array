`timescale 1ns / 1ps
`default_nettype none

module direction_calculator_tb;

  // Input logics
  logic clk_in;

  // INPUTS
  logic [31: 0] central_mic;
  logic [31: 0] peripheral_mics [2:0];
  logic [15: 0] mic_locations [2:0][2];
  // OUTPUTS
  logic signed [31:0] vector;

  direction_calculator uut(
    .central_mic(central_mic),
    .peripheral_mics(peripheral_mics),
    .vector(vector)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  initial begin
    // $dumpfile("vcd/direction_calculator_tb.vcd");
    // $dumpvars(0, direction_calculator_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;

    #10;

    central_mic = 32'h00_00_40_00;
    peripheral_mics = {32'h10_00_00_00, 32'hf0_00_00_00, 32'hf0_00_00_00};

    #10;

    $display("x_out is %b, y_out is %b", vector[31:16], vector[15:0]);
    $display("scaled_location_x is %b, scaled_location_y is %b", summed_locations[0], summed_locations[1]);

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
