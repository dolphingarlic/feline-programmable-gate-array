`timescale 1ns / 1ps
`default_nettype none

module feature_extractor #(
  parameter NUM_FILTERS = 26
) (
  input wire clk_in,
  input wire rst_in,
  input wire [1:0] mode_in,

  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  output wire fft_ready_out,
  
  input wire feature_ready_in,
  output wire feature_valid_out,
  output wire [31:0] feature_data_out
);

  logic power_ready, power_valid;
  logic [31:0] power_data;

  power_spectrum power_spectrum_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .fft_data_in(fft_data_in),
    .fft_valid_in(fft_valid_in),
    .fft_ready_out(fft_ready_out),

    .power_ready_in(power_ready),
    .power_valid_out(power_valid),
    .power_data_out(power_data)
  );

  logic filtered_ready, filtered_valid;
  logic [31:0] filtered_data;

  mel_filterbank #(
    .NUM_FILTERS(NUM_FILTERS)
  ) mel_filterbank_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .power_data_in(power_data),
    .power_valid_in(power_valid),
    .power_ready_out(power_ready),

    .filtered_ready_in(filtered_ready),
    .filtered_valid_out(filtered_valid),
    .filtered_data_out(filtered_data)
  );

  // TODO: use CORDIC or LUT logarithm

  dct #(

  ) dct_inst (

  );

  // TODO: truncate and stuff (coefficients 2 to 13 only)

  // TODO: output control based on operating mode

  always_ff @(posedge clk_in) begin
  end

endmodule

`default_nettype wire
