`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `logarithm
 *
 * Estimates the base-2 logarithm of a number via leading-bit
 * detection and linear interpolation.
 */
module logarithm (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] filtered_data_in,
  input wire filtered_valid_in,
  output logic filtered_ready_out,

  input wire log_ready_in,
  output logic log_valid_out,
  output logic signed [15:0] log_data_out
);

  logic signed [5:0] res_int; // One more bit than strictly necessary
  logic [15:0] half;
  logic [7:0] quarter;
  logic [3:0] eighth;

  logic signed [10:0] res_frac;
  logic [31:0] shifted;

  always_comb begin
    // Calculate the integer part
    // TODO: make this more general (handle different precisions)
    // (Right now we assume 16 int bits + 16 frac bits in input)
    res_int = -16;
    shifted = filtered_data_in;

    if (|shifted[31:16]) res_int = res_int + 16;
    else shifted = shifted << 16;

    if (|shifted[31:24]) res_int = res_int + 8;
    else shifted = shifted << 8;

    if (|shifted[31:28]) res_int = res_int + 4;
    else shifted = shifted << 4;

    if (|shifted[31:30]) res_int = res_int + 2;
    else shifted = shifted << 2;

    if (shifted[31]) res_int = res_int + 1;
    else shifted = shifted << 1;

    // Calculate the fractional part
    res_frac = shifted[30:20];
  end

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      log_data_out <= 0;
    end else begin
      log_data_out <= {res_int[4:0], res_frac};
      log_valid_out <= filtered_valid_in;
      filtered_ready_out <= log_ready_in;
    end
  end

endmodule

`default_nettype wire
