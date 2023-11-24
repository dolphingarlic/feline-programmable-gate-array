`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `biometrics`
 *
 * Detects whether the input voice data matches the owner.
 */
module biometrics (
  output logic [15:0] led, // FOR DEBUGGING

  input wire clk_in,
  input wire rst_in,
  input wire write_enable_in,

  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  input wire fft_last_in,
  output logic fft_ready_out,

  input wire ble_uart_rx_in,
  input wire ble_uart_cts_in,
  output logic ble_uart_tx_out,
  output logic ble_uart_rts_out,
  
  output logic detected_out
);

  ////////////////////////
  // FEATURE EXTRACTION //
  ////////////////////////
  logic signed [15:0] feature_data;
  logic feature_valid, feature_last, feature_ready;

  assign led[2:0] = {feature_valid, feature_last, feature_ready};
  assign led[3] = write_enable_in;

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
  bluetooth bluetooth_inst (
    .led(led),

    .clk_in(clk_in),
    .rst_in(rst_in),
    .write_enable_in(write_enable_in),

    .feature_data_in(feature_data),
    .feature_valid_in(feature_valid),
    .feature_last_in(feature_last),
    .feature_ready_out(feature_ready),

    .ble_valid_out(),
    .ble_data_out(),

    .ble_uart_rx_in(ble_uart_rx_in),
    .ble_uart_tx_out(ble_uart_tx_out)
  );

  ////////////////////
  // CLASSIFICATION //
  ////////////////////
  assign detected_out = ble_uart_tx_out; // TODO: fix me

endmodule

`default_nettype wire
