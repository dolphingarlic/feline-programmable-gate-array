`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `feature_extractor`
 *
 * Given FFT outputs for a frame, computes 13 MFCCs.
 */
module feature_extractor #(
  parameter NUM_FILTERS = 26,
  parameter N_FFT = 512,
  parameter N_DCT = 32,
  parameter FREQ_LOWERBOUND_HZ = 20,
  parameter FREQ_UPPERBOUND_HZ = 3_000,
  parameter SAMPLE_RATE_HZ = 6_000,
) (
  input wire clk_in,
  input wire rst_in,
  input wire [1:0] mode_in,

  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  input wire fft_last_in,
  output logic fft_ready_out,
  
  input wire feature_ready_in,
  output logic feature_valid_out,
  output logic [31:0] feature_data_out
);

  ////////////////////
  // POWER SPECTRUM //
  ////////////////////
  logic power_ready, power_valid, power_last;
  logic [31:0] power_data;

  power_spectrum power_spectrum_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .fft_data_in(fft_data_in),
    .fft_valid_in(fft_valid_in),
    .fft_last_in(fft_last_in),
    .fft_ready_out(fft_ready_out),

    .power_ready_in(power_ready),
    .power_last_out(power_last),
    .power_valid_out(power_valid),
    .power_data_out(power_data)
  );

  ///////////////////
  // MEL FILTERING //
  ///////////////////
  logic filtered_ready, filtered_valid;
  logic [31:0] filtered_data [NUM_FILTERS-1:0];

  mel_filterbank #(
    .NUM_FILTERS(NUM_FILTERS),
    .N_FFT(N_FFT),
    .FREQ_LOWERBOUND_HZ(FREQ_LOWERBOUND_HZ),
    .FREQ_UPPERBOUND_HZ(FREQ_UPPERBOUND_HZ),
    .SAMPLE_RATE_HZ(SAMPLE_RATE_HZ)
  ) mel_filterbank_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .power_data_in(power_data),
    .power_valid_in(power_valid),
    .power_last_in(power_last),
    .power_ready_out(power_ready),

    .filtered_ready_in(filtered_ready),
    .filtered_valid_out(filtered_valid),
    .filtered_data_out(filtered_data)
  );

  //////////////////////
  // BASE-2 LOGARITHM //
  //////////////////////
  logic [NUM_FILTERS-1:0] log_ready;
  logic log_valid;
  logic [15:0] log_data [NUM_FILTERS-1:0];

  generate
    genvar i;
    for (i = 0; i < NUM_FILTERS; i = i + 1) begin
      logarithm logarithm_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .filtered_data_in(filtered_data[i]),
        .filtered_valid_in(filtered_valid),
        .filtered_ready_out(filtered_ready),

        .log_ready_in(log_ready),
        .log_valid_out(log_valid[i]),
        .log_data_out(log_data[i])
      );
    end
  endgenerate

  ///////////////////////////////
  // DISCRETE COSINE TRANSFORM //
  ///////////////////////////////
  logic dct_ready, dct_valid, dct_last;
  logic [15:0] dct_data;

  dct #(
    .NUM_FILTERS(NUM_FILTERS),
    .N_DCT(N_DCT)
  ) dct_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .log_data_in(log_data),
    .log_valid_in(log_valid[0]),
    .log_ready_out(log_ready),

    .dct_ready_in(dct_ready),
    .dct_valid_out(dct_valid),
    .dct_data_out(dct_data),
    .dct_last_out(dct_last)
  );

  // TODO: truncate and stuff (coefficients 2 to 13 only)

  // TODO: output control based on operating mode

  always_ff @(posedge clk_in) begin
  end

endmodule

`default_nettype wire
