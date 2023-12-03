`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `biometrics`
 *
 * Detects whether the input voice data matches the owner.
 */
module biometrics (
  input wire clk_in,
  input wire rst_in,
  input wire write_enable_in,
  input wire predict_enable_in,

  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  input wire fft_last_in,
  output logic fft_ready_out,

  input wire ble_uart_rx_in,
  input wire ble_uart_cts_in,
  output logic ble_uart_tx_out,
  output logic ble_uart_rts_out,
  
  input wire signed [15:0] loudness_threshold_in,
  output logic detected_out
);

  ////////////////////////
  // FEATURE EXTRACTION //
  ////////////////////////
  logic signed [15:0] feature_data;
  logic feature_valid, feature_last, feature_ready;

  feature_extractor feature_extractor_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .fft_data_in(fft_data_in),
    .fft_valid_in(fft_valid_in),
    .fft_last_in(fft_last_in),
    .fft_ready_out(fft_ready_out),

    .feature_ready_in(feature_ready),
    .feature_last_out(feature_last),
    .feature_valid_out(feature_valid),
    .feature_data_out(feature_data)
  );

  ///////////////
  // BLUETOOTH //
  ///////////////
  logic [7:0] ble_data;
  logic ble_valid;

  bluetooth bluetooth_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .write_enable_in(write_enable_in),

    .feature_data_in(feature_data),
    .feature_valid_in(feature_valid),
    .feature_last_in(feature_last),
    .feature_ready_out(feature_ready),

    .ble_valid_out(ble_valid),
    .ble_data_out(ble_data),

    .ble_uart_rx_in(ble_uart_rx_in),
    .ble_uart_tx_out(ble_uart_tx_out)
  );

  ////////////////////
  // CLASSIFICATION //
  ////////////////////
  classifier classifier_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .feature_data_in(feature_data),
    .feature_valid_in(feature_valid && feature_ready),
    .feature_last_in(feature_last),

    .ble_data_in(ble_data),
    .ble_valid_in(ble_valid),

    .predict_enable_in(predict_enable_in),
    .loudness_threshold_in(loudness_threshold_in),
    .detected_out(detected_out)
  );

endmodule

`default_nettype wire
