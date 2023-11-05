`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `mel_filterbank`
 *
 * Computes mel filterbank energies from the power spectrum.
 */
module mel_filterbank #(
  parameter NUM_FILTERS,
  parameter N_FFT,
  parameter FREQ_LOWERBOUND_HZ,
  parameter FREQ_UPPERBOUND_HZ,
  parameter SAMPLE_RATE_HZ
) (
  input wire clk_in,
  input wire rst_in,
  
  input wire [31:0] power_data_in,
  input wire power_valid_in,
  input wire power_last_in,
  output logic power_ready_out,

  input wire filtered_ready_in,
  output logic filtered_valid_out,
  output logic [31:0] filtered_data_out [NUM_FILTERS-1:0]
);

  localparam FREQ_LOWERBOUND_MEL = $ln(700.0 + FREQ_LOWERBOUND_HZ);
  localparam FREQ_UPPERBOUND_MEL = $ln(700.0 + FREQ_UPPERBOUND_HZ);
  localparam MEL_SPACING = (FREQ_UPPERBOUND_MEL - FREQ_LOWERBOUND_MEL) / (NUM_FILTERS + 1);

  logic [$clog2(N_FFT)-1:0] k_curr;
  logic [31:0] filter_buffer [NUM_FILTERS-1:0];

  genvar i;
  generate;
    for (i = 0; i < NUM_FILTERS; i = i + 1) begin
      localparam PEAK_MEL = FREQ_LOWERBOUND_MEL + (i + 1) * MEL_SPACING;
      localparam START_HZ = $exp(PEAK_MEL - MEL_SPACING) - 700;
      localparam PEAK_HZ = $exp(PEAK_MEL) - 700;
      localparam STOP_HZ = $exp(PEAK_MEL + MEL_SPACING) - 700;

      triangular_filter #(
        .N_FFT(N_FFT),
        .START($floor((N_FFT + 1) * START_HZ / SAMPLE_RATE_HZ)),
        .PEAK($floor((N_FFT + 1) * PEAK_HZ / SAMPLE_RATE_HZ)),
        .STOP($floor((N_FFT + 1) * STOP_HZ / SAMPLE_RATE_HZ))
      ) triangular_filter_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .power_in(power_data_in),
        .k_in(k_curr),
        // .filtered_out(filter_buffer[i])
        .filtered_out(filtered_data_out[i]) // TODO: fixme
      );
    end
  endgenerate

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      k_curr <= 0;
    end else if (power_valid_in) begin
      if (power_last_in) k_curr <= 0;
      else k_curr <= k_curr + 1;

      // TODO: deal with other output logics and stuff
    end
  end

endmodule

`default_nettype wire
