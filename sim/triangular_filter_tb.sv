`timescale 1ns / 1ps
`default_nettype none

module triangular_filter_tb;
  
  // Input logics
  logic clk_in, rst_in;
  logic [31:0] power_in;
  logic [8:0] k_in;
  // Output logics
  logic [31:0] filtered_out;

  triangular_filter #(
    .N_FFT(512),
    .START(165),
    .PEAK(206),
    .STOP(256)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .power_in(power_in),
    .k_in(k_in),
    .filtered_out(filtered_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/triangular_filter.vcd");
    $dumpvars(0, triangular_filter_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    power_in = 0;
    k_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: flat signal
    power_in = 32'hDEADBEEF;
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    // Test case 2: sine wave
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      power_in = 32'hDEADBEEF * $sin(i / 5.0) * $sin(i / 5.0);
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
