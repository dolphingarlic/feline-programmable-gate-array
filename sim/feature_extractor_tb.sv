`timescale 1ns / 1ps
`default_nettype none

module feature_extractor_tb;

  // Input logics
  logic clk_in, rst_in;
  logic [15:0] audio_data_in;
  logic audio_valid_in, audio_last_in, feature_ready_in;
  // Intermediate logics
  logic [31:0] fft_data;
  logic fft_valid, fft_last, fft_ready;
  // Output logics
  logic signed [15:0] feature_data_out;
  logic feature_valid_out, feature_last_out, audio_ready_out;

  xfft_512 xfft_512 (
    .aclk(clk_in),

    .s_axis_data_tdata({audio_data_in, 16'b0}),
    .s_axis_data_tvalid(audio_valid_in),
    .s_axis_data_tlast(audio_last_in),
    .s_axis_data_tready(audio_ready_out),

    .s_axis_config_tdata(16'b0),
    .s_axis_config_tvalid(1'b0),
    .s_axis_config_tready(),

    .m_axis_data_tdata(fft_data),
    .m_axis_data_tvalid(fft_valid),
    .m_axis_data_tlast(fft_last),
    .m_axis_data_tready(fft_ready)
  );

  feature_extractor uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .fft_data_in(fft_data),
    .fft_valid_in(fft_valid),
    .fft_last_in(fft_last),
    .fft_ready_out(fft_ready),

    .feature_ready_in(feature_ready_in),
    .feature_last_out(feature_last_out),
    .feature_valid_out(feature_valid_out),
    .feature_data_out(feature_data_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/feature_extractor.vcd");
    $dumpvars(0, feature_extractor_tb);
    $display("Starting sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    audio_data_in = 0;
    audio_valid_in = 0;
    audio_last_in = 0;
    feature_ready_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: Three sine waves superimposed
    audio_valid_in = 1;
    feature_ready_in = 1;
    for (int i = 0; i < 512; i = i + 1) begin
      audio_data_in = 16'hBEEF * $sin(i / 5.0) + 16'hABCD * $sin(6.4) + 16'h666 * $cos(i / 17.0);
      audio_last_in = (i == 511);
      #10;
    end
    audio_last_in = 0;
    audio_valid_in = 0;
    while (!feature_last_out) #10;
    #100;

    // Test case 2: Two consecutive audio samples
    for (int i = 0; i < 1024; i = i + 1) begin
      audio_valid_in = 1;
      audio_data_in = 16'hBEEF * $sin(i / 5.0) + 16'hABCD * $sin(6.4) + 16'h666 * $cos(i / 17.0);
      audio_last_in = (i == 511) || (i == 1023);
      #10;
      audio_valid_in = 0;
      audio_last_in = 0;
      #90;
    end
    audio_last_in = 0;
    audio_valid_in = 0;
    while (!feature_last_out) #10;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
