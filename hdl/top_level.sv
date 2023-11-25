`timescale 1ns / 1ps
`default_nettype none

module top_level (
  input wire clk_100mhz,
  input wire [15:0] sw,
  input wire [3:0] btn,

  input wire  mic_data, //microphone data
  output logic spkl, spkr, //speaker outputs
  output logic mic_clk, //microphone clock

  input wire ble_uart_rx,
  output logic ble_uart_tx,
  input wire ble_uart_cts,
  output logic ble_uart_rts,

  output logic [15:0] led,
  output logic [2:0] rgb0,
  output logic [2:0] rgb1
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

  // BEGIN STUFF FROM LAB 7

  logic [8:0] m_clock_counter;
  logic audio_sample_valid;
  logic signed [8:0] mic_audio;
  logic[7:0] audio_data;

  localparam PDM_COUNT_PERIOD = 32;
  localparam NUM_PDM_SAMPLES = 512;

  logic old_mic_clk;
  logic sampled_mic_data;
  logic pdm_signal_valid;

  assign pdm_signal_valid = mic_clk && ~old_mic_clk;

  always_ff @(posedge clk_m)begin
    mic_clk <= m_clock_counter < PDM_COUNT_PERIOD/2;
    m_clock_counter <= (m_clock_counter==PDM_COUNT_PERIOD-1)?0:m_clock_counter+1;
    old_mic_clk <= mic_clk;
  end

  assign audio_data = mic_audio[8:1];

  logic audio_out;
  pdm my_pdm(
    .clk_in(clk_m),
    .rst_in(sys_rst),
    .level_in(audio_data),
    .tick_in(pdm_signal_valid),
    .pdm_out(audio_out)
  );

  assign spkl = audio_out;
  assign spkr = audio_out;

  // END LAB 7 STUFF

  logic [8:0] audio_counter;

  always_ff @(posedge clk_m) begin
    if (sys_rst) audio_counter <= 0;
    else if (audio_sample_valid) audio_counter <= audio_counter + 1;
  end

  logic [31:0] fft_data;
  logic fft_valid, fft_last, fft_ready;

  xfft_512 xfft_512_inst (
    .aclk(clk_m),
    .s_axis_data_tdata({audio_data, 24'b0}),
    .s_axis_data_tvalid(audio_sample_valid),
    .s_axis_data_tlast(audio_counter == 511),
    .s_axis_data_tready(rgb1[0]),
    .s_axis_config_tdata(16'b0),
    .s_axis_config_tvalid(1'b0),
    .s_axis_config_tready(),
    .m_axis_data_tdata(fft_data),
    .m_axis_data_tvalid(fft_valid),
    .m_axis_data_tlast(fft_last),
    .m_axis_data_tready(fft_ready)
  );

  biometrics biometrics_inst (
    .led(led),

    .clk_in(clk_m),
    .rst_in(sys_rst),
    .write_enable_in(btn[1]),

    .fft_data_in(fft_data),
    .fft_valid_in(fft_valid),
    .fft_last_in(fft_last),
    .fft_ready_out(fft_ready),

    .ble_uart_rx_in(ble_uart_rx),
    .ble_uart_cts_in(ble_uart_cts),
    .ble_uart_tx_out(ble_uart_tx),
    .ble_uart_rts_out(ble_uart_rts),

    .detected_out(rgb0[0])
  );

endmodule


module pdm(
            input wire clk_in,
            input wire rst_in,
            input wire signed [7:0] level_in,
            input wire tick_in,
            output logic pdm_out
  );

  logic signed [8:0] error;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      error <= 0;
    end else if (tick_in) begin
      error <= error + level_in - (error > 0 ? 127 : -128);
    end
  end

  assign pdm_out = error > 0;

endmodule

`default_nettype wire
