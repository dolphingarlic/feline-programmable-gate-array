`timescale 1ns / 1ps
`default_nettype none

module power_spectrum_tb;

  // Input logics
  logic clk_in, rst_in;
  logic signed [15:0] real_in, imag_in;
  logic fft_valid_in, power_ready_in;
  // Output logics
  logic power_valid_out, fft_ready_out;
  logic [31:0] power_out;

  power_spectrum uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .fft_data_in({real_in, imag_in}),
    .fft_valid_in(fft_valid_in),
    .fft_ready_out(fft_ready_out),
    
    .power_ready_in(power_ready_in),
    .power_valid_out(power_valid_out),
    .power_data_out(power_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("power_spectrum.vcd");
    $dumpvars(0, power_spectrum_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    real_in = 0;
    imag_in = 0;
    fft_valid_in = 0;
    power_ready_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: purely real
    fft_valid_in = 1;
    power_ready_in = 1;
    for (int i = -16384; i < 16383; i = i + 64) begin
      real_in = i;
      #10;
    end
    fft_valid_in = 0;
    real_in = 0;
    #10;
    power_ready_in = 0;
    #50;

    // Test case 2: purely imaginary
    fft_valid_in = 1;
    power_ready_in = 1;
    for (int i = -16384; i < 16383; i = i + 64) begin
      imag_in = i;
      #10;
    end
    fft_valid_in = 0;
    imag_in = 0;
    #10;
    power_ready_in = 0;
    #50;

    // Test case 3: both real and imaginary
    fft_valid_in = 1;
    power_ready_in = 1;
    for (int i = 0; i < 512; i = i + 1) begin
      real_in = 3 * i;
      imag_in = 4 * i;
      #10;
    end
    fft_valid_in = 0;
    imag_in = 0;
    real_in = 0;
    #10;
    power_ready_in = 0;
    #50;

    // Test case 4: timing signals
    real_in = -8192;
    imag_in = 8191;
    fft_valid_in = 1;
    #100;
    power_ready_in = 1;
    #10;
    power_ready_in = 0;
    #10;
    power_ready_in = 1;
    #20;
    power_ready_in = 0;
    #50;
    fft_valid_in = 0;
    #50;
    power_ready_in = 1;
    #100;
    fft_valid_in = 1;
    #10;
    fft_valid_in = 0;
    #10;
    fft_valid_in = 1;
    #20;
    fft_valid_in = 0;
    #50;
    power_ready_in = 0;
    #50;
    fft_valid_in = 1;
    power_ready_in = 1;
    #10;
    fft_valid_in = 0;
    power_ready_in = 0;
    #10
    fft_valid_in = 1;
    power_ready_in = 1;
    #10;
    fft_valid_in = 0;
    power_ready_in = 0;
    #50;

    $display("Finishing Sim");
    $finish;
  end
endmodule

`default_nettype wire
