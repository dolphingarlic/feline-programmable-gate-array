`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `power_spectrum`
 * 
 * Computes the power spectrum from the output of FFT.
 */
module power_spectrum (
  input wire clk_in,
  input wire rst_in,
  
  input wire [31:0] fft_data_in,
  input wire fft_valid_in,
  output wire fft_ready_out,

  input wire power_ready_in,
  output wire power_valid_out,
  output wire [31:0] power_data_out,
);

  logic [15:0] real_in, imag_in;
  logic [31:0] real_square, imag_square;
  logic square_valid;

  assign real_in = fft_data_in[31:16];
  assign imag_in = fft_data_in[15:0];

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      fft_ready_out <= 0;
      square_valid <= 0;
      power_valid_out <= 0;
    end else if (power_ready_in) begin
      fft_ready_out <= 1;
      // Stage 1: compute squares
      real_square <= real_in * real_in;
      imag_square <= imag_in * imag_in;
      square_valid <= fft_valid_in;
      // Stage 2: compute sum
      power_data_out <= real_square + imag_square;
      power_valid_out <= square_valid;
    end else begin
      fft_ready_out <= 0;
    end
  end

endmodule

`default_nettype wire
