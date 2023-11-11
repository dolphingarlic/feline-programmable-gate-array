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
  logic input_valid_buffer, input_last_buffer;

  // The triangular filters take 2 cycles to complete, so buffer the control
  // signals for 2 cycles
  pipeline #(
    .WIDTH(2),
    .DEPTH(2)
  ) input_valid_buffer_pipeline (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .val_in({power_valid_in, power_last_in}),
    .val_out({input_valid_buffer, input_last_buffer})
  );

  // Run the triangular filters in parallel
  generate;
    genvar i;
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
        .filtered_out(filter_buffer[i])
      );

      always_ff @(posedge clk_in) begin
        if (rst_in || (filtered_valid_out && filtered_ready_in)) begin
          filtered_data_out[i] <= 0;
        end else if (input_valid_buffer) begin
          // TODO: What if this overflows?
          // Let's just assume that won't happen for now...
          filtered_data_out[i] <= filtered_data_out[i] + filter_buffer[i];
          // filtered_data_out[i] <= filtered_data_out[i] + filter_buffer[i][31:5];
        end
      end
    end
  endgenerate

  always_ff @(posedge clk_in) begin
    if (rst_in || (filtered_valid_out && filtered_ready_in)) begin
      // Reset the counter to zero once we're done
      k_curr <= 0;
      filtered_valid_out <= 0;
      // Stop stalling after releasing held data
      power_ready_out <= 1;
    end else begin
      // Advance the pipeline once we've consumed a valid input
      if (power_valid_in) begin
        k_curr <= k_curr + 1;

        if (power_last_in) begin
          // The output isn't valid yet, but we can't accept more inputs
          power_ready_out <= 0;
        end
      end

      // The output is valid once we finish processing the last input
      if (input_last_buffer) begin
        filtered_valid_out <= 1;
      end
    end
  end

endmodule

`default_nettype wire
