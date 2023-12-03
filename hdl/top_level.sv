`timescale 1ns / 1ps
`default_nettype none

module top_level (
  input wire clk_100mhz,
  input wire [15:0] sw,
  input wire [3:0] btn,

  output logic spkl, spkr, //speaker outputs

  input wire ble_uart_rx,
  output logic ble_uart_tx,

  input wire uart_rxd,
  output logic uart_txd,

  output logic [15:0] led,
  output logic [2:0] rgb0,
  output logic [2:0] rgb1,

  output logic [7:0] pmoda, //output I/O used for SPI TX (in part 3)
	input wire [7:0] pmodb //input I/O used for SPI RX (in part 3)
);

  // Global reset
  logic sys_rst;
  assign sys_rst = btn[0];

  // 98.304 MHz audio/AXI clock
  logic clk_m;
  audio_clk_wiz macw (
    .clk_in(clk_100mhz),
    .clk_out(clk_m)
  );

  // Capture audio from the microphones

  logic signed [15:0] mic_audio_data [3:0];
  logic ws;
  logic sck;

  assign pmoda[0] = sck;
  assign pmoda[1] = ws;

  logic audio_sample_valid;
  logic audio_sample_ready;

  microphones my_microphones(
    .clk_in(clk_m),
    .rst_in(sys_rst),

    .mic_data(pmodb[3:0]),
    .mic_sck(sck),
    .mic_ws(ws),
    .audio_data(mic_audio_data),
    .audio_valid(audio_sample_valid),
    .audio_ready(audio_sample_ready)
  );

  // Playback audio to headphones

  logic [15:0] playback_audio;

  always_comb begin
    if (sw[0])
      playback_audio = mic_audio_data[0];
    else if (sw[1])
      playback_audio = mic_audio_data[1];
    else if (sw[2])
      playback_audio = mic_audio_data[2];
    else if (sw[3])
      playback_audio = mic_audio_data[3];
  end

  logic audio_out;
  pdm my_pdm(
    .clk_in(clk_m),
    .rst_in(sys_rst),
    .level_in(playback_audio),
    .pdm_out(audio_out)
  );

  assign spkl = audio_out;
  assign spkr = audio_out;

  // Calculate FFT of the audio data

  logic [8:0] audio_counter;

  always_ff @(posedge clk_m) begin
    if (sys_rst) audio_counter <= 0;
    else if (audio_sample_valid) audio_counter <= audio_counter + 1;
  end

  logic [127:0] fft_data;
  logic fft_valid, fft_last, fft_ready;

  xfft_0 xfft_0_inst (
    .aclk(clk_m),
    // TODO: Use multiple microphones
    .s_axis_data_tdata({mic_audio_data[3], 16'b0, mic_audio_data[2], 16'b0, mic_audio_data[1], 16'b0, mic_audio_data[0], 16'b0}), // We only have real-data
    .s_axis_data_tvalid(audio_sample_valid),
    .s_axis_data_tlast(audio_counter == 511),
    .s_axis_data_tready(audio_sample_ready),
    .s_axis_config_tdata(16'b0),
    .s_axis_config_tvalid(1'b0),
    .s_axis_config_tready(1'b1),
    .m_axis_data_tdata(fft_data),
    .m_axis_data_tvalid(fft_valid),
    .m_axis_data_tlast(fft_last),
    .m_axis_data_tready(fft_ready)
  );

  // // We can put this into the localizer

  logic angle_valid_out;
  logic [15:0] angle;

  localizer localizer_inst (
    .clk_in(clk_m),
    .rst_in(sys_rst),

    .fft_data_in(fft_data),
    .fft_valid_in(fft_valid),

    .localizer_ready_out(fft_ready),
    .angle_valid_out(angle_valid_out),
    .angle(angle),

    .uart_rxd(uart_rxd),
    .uart_txd(uart_txd)
  );

  // END LAB 7 STUFF

  // logic [31:0] fft_data;
  // logic fft_valid, fft_last, fft_ready;

  // xfft_512 xfft_512_inst (
  //   .aclk(clk_m),
  //   .s_axis_data_tdata({mic_audio_data, 16'b0}),
  //   .s_axis_data_tvalid(audio_sample_valid),
  //   .s_axis_data_tlast(audio_counter == 511),
  //   .s_axis_data_tready(rgb1[0]),
  //   .s_axis_config_tdata(16'b0),
  //   .s_axis_config_tvalid(1'b0),
  //   .s_axis_config_tready(),
  //   .m_axis_data_tdata(fft_data),
  //   .m_axis_data_tvalid(fft_valid),
  //   .m_axis_data_tlast(fft_last),
  //   .m_axis_data_tready(fft_ready)
  // );

  // biometrics biometrics_inst (
  //   .clk_in(clk_m),
  //   .rst_in(sys_rst),
  //   .write_enable_in(btn[1]),

  //   .fft_data_in(fft_data),
  //   .fft_valid_in(fft_valid),
  //   .fft_last_in(fft_last),
  //   .fft_ready_out(fft_ready),

  //   .ble_uart_rx_in(ble_uart_rx),
  //   .ble_uart_tx_out(ble_uart_tx),

  //   .detected_out(rgb0[0])
  // );

endmodule

`default_nettype wire
