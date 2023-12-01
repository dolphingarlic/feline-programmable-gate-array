`timescale 1ns / 1ps
`default_nettype none

module direction_calculator_tb;

  // Input logics
  logic clk_in;

  // INPUTS
  logic [31: 0] central_mic;
  logic [15:0] central_mic_location [2];
  logic [31: 0] peripheral_mics [2:0];
  logic [15: 0] mic_locations [2:0][2];
  // OUTPUTS
  logic signed [31:0] vector;
  logic signed [16:0] phase_differences [2:0];

  direction_calculator uut(
    .central_mic(central_mic),
    .central_mic_location(central_mic_location),
    .peripheral_mics(peripheral_mics),
    .mic_locations(mic_locations),
    .vector(vector),
    .phase_differences(phase_differences)
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

    central_mic = 32'h00_00_20_00;
    central_mic_location = {16'h00_00, 16'h00_00};
    peripheral_mics = {32'h10_00_00_00, 32'h00_00_f0_00, 32'h00_00_f0_00};
    mic_locations = {{16'h00_00, 16'h00_00}, {16'h00_00, 16'h00_00}, {16'h00_00, 16'h00_00}};

    #10;

    $display("data_out is %h", vector);

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
