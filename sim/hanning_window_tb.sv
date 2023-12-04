`timescale 1ns / 1ps
`default_nettype none

module hanning_window_tb;

  // Input logics
  logic clk_in, rst_in;
  logic [8:0] sample;
  logic audio_valid_in, audio_valid_out;

  logic signed [15:0] audio_data_in_0;

  logic signed [15:0] audio_data_out_0;

  hanning_window #(
    .SAMPLES(512),
    .CHANNELS(1)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .sample(sample),
    .audio_data_in(audio_data_in_0),
    .audio_valid_in(audio_valid_in),
    .audio_data_out(audio_data_out_0),
    .audio_valid_out(audio_valid_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/hanning_window.vcd");
    $dumpvars(0, hanning_window_tb);
    $display("Starting sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    audio_valid_in = 0;
    sample = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    audio_valid_in = 1;

    // Test case: sine wave
    for (int i = 0; i < 512; i = i + 1) begin
      sample = i;
      audio_data_in_0 = 16'h0F_FF * $sin(i / 5.0);

      #10;
    end

    audio_data_in_0 = 16'h0000;

    sample = 0;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire