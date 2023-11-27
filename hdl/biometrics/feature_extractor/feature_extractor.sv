`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `feature_extractor`
 *
 * Given FFT outputs for a frame, computes 13 MFCCs.
 */
module feature_extractor #(
  parameter NUM_FILTERS = 32,
  parameter NUM_FEATURES_OUT = 16,
  parameter N_FFT = 512,
  parameter N_DCT = 32
) (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  input wire fft_last_in,
  output logic fft_ready_out,
  
  input wire feature_ready_in,
  output logic feature_last_out,
  output logic feature_valid_out,
  output logic signed [15:0] feature_data_out
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
    .N_FFT(N_FFT)
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
  logic log_ready, log_valid;
  logic signed [15:0] log_data [NUM_FILTERS-1:0];

  logarithm logarithm_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .filtered_data_in(filtered_data[0]),
    .filtered_valid_in(filtered_valid),
    .filtered_ready_out(filtered_ready),

    .log_ready_in(log_ready),
    .log_valid_out(log_valid),
    .log_data_out(log_data[0])
  );
  generate
    genvar i;
    for (i = 1; i < NUM_FILTERS; i = i + 1) begin
      logarithm logarithm_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .filtered_data_in(filtered_data[i]),
        .filtered_valid_in(filtered_valid),
        .filtered_ready_out(),

        .log_ready_in(log_ready),
        .log_valid_out(),
        .log_data_out(log_data[i])
      );
    end
  endgenerate

  ///////////////////////////////
  // DISCRETE COSINE TRANSFORM //
  ///////////////////////////////
  logic dct_ready, dct_valid, dct_last;
  logic signed [15:0] dct_data;

  assign dct_ready = feature_ready_in;

  dct #(
    .NUM_FILTERS(NUM_FILTERS),
    .N_DCT(N_DCT)
  ) dct_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .log_data_in(log_data),
    .log_valid_in(log_valid),
    .log_ready_out(log_ready),

    .dct_ready_in(dct_ready),
    .dct_valid_out(dct_valid),
    .dct_data_out(dct_data),
    .dct_last_out(dct_last)
  );

  ///////////////////////
  // OUTPUT TRUNCATION //
  ///////////////////////
  logic [$clog2(NUM_FILTERS)-1:0] num_outputted;

  assign feature_data_out = dct_data;
  assign feature_valid_out = dct_valid && num_outputted < NUM_FEATURES_OUT;
  assign feature_last_out = feature_valid_out && (num_outputted == NUM_FEATURES_OUT - 1);

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      num_outputted <= 0;
    end else begin
      if (dct_valid) begin
        if (num_outputted < NUM_FEATURES_OUT) num_outputted <= num_outputted + 1;
        else if (dct_last) num_outputted <= 0;
      end
    end
  end

endmodule

`default_nettype wire
