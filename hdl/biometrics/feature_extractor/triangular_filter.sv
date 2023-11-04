`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `triangular_filter`
 *
 * Filters an input signal over a triangular band, specified by 
 * (START, PEAK, STOP).
 */
module triangular_filter #(
  parameter N_FFT,
  parameter START,
  parameter PEAK,
  parameter STOP,
  parameter INV_PRECISION = 10
) (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [$clog2(N_FFT)-1:0] k_in,
  output logic [31:0] filtered_out
);

  localparam INV_LOWER_BANDWIDTH = (1 << INV_PRECISION) / (PEAK - START);
  localparam INV_UPPER_BANDWIDTH = (1 << INV_PRECISION) / (STOP - PEAK);

  logic [31:0] scale_factor, power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Stage 1
      power_buffer <= (power_in >> INV_PRECISION);
      if (k_in < START || k_in > STOP) scale_factor <= 0;
      else if (k_in < PEAK) begin
        scale_factor <= (k_in - START) * INV_LOWER_BANDWIDTH;
      end else begin
        scale_factor <= (STOP - k_in) * INV_UPPER_BANDWIDTH;
      end
      // Stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end

endmodule

`default_nettype wire
