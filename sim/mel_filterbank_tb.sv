`timescale 1ns / 1ps
`default_nettype none

module mel_filterbank_tb;

  // Input logics
  logic clk_in, rst_in;
  logic [31:0] power_data_in;
  logic power_valid_in, power_last_in, filtered_ready_in;
  // Output logics
  logic [31:0] filtered_data_out [25:0];
  // TODO

  mel_filterbank #(
    .NUM_FILTERS(26),
    .N_FFT(512),
    .FREQ_LOWERBOUND_HZ(20),
    .FREQ_UPPERBOUND_HZ(3_000),
    .SAMPLE_RATE_HZ(6_000)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .power_data_in(power_data_in),
    .power_valid_in(power_valid_in),
    .power_last_in(power_last_in),
    .power_ready_out(),

    .filtered_ready_in(filtered_ready_in),
    .filtered_valid_out(),
    .filtered_data_out(filtered_data_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("mel_filterbank.vcd");
    $dumpvars(0, mel_filterbank_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    power_data_in = 0;
    power_valid_in = 0;
    power_last_in = 0;
    filtered_ready_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: flat signal
    power_data_in = 32'hDEADBEEF;
    power_valid_in = 1;
    filtered_ready_in = 1;
    #5110;
    power_last_in = 1;
    #10;
    power_last_in = 0;
    power_data_in = 0;
    power_valid_in = 0;
    filtered_ready_in = 0;
    #100;

    // Test case 2: sine wave
    power_valid_in = 1;
    filtered_ready_in = 1;
    for (int i = 0; i < 512; i = i + 1) begin
      power_data_in = 32'hDEADBEEF * $sin(i);
      power_last_in = (i == 511);
      #10;
    end
    power_last_in = 0;
    power_data_in = 0;
    power_valid_in = 0;
    filtered_ready_in = 0;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
