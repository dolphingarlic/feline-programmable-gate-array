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
  input wire fft_last_in,
  output logic fft_ready_out,

  input wire power_ready_in,
  output logic power_last_out,
  output logic power_valid_out,
  output logic [31:0] power_data_out
);

  logic signed [15:0] real_in, imag_in;
  logic signed [31:0] real_square, imag_square;
  logic square_valid, last_buffer;

  assign real_in = fft_data_in[31:16];
  assign imag_in = fft_data_in[15:0];

  // Only advance the pipeline if the downstream stages are ready
  logic stall_1, stall_2;
  assign stall_2 = !power_ready_in && power_valid_out;
  assign stall_1 = stall_2 && square_valid;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      fft_ready_out <= 0;
      square_valid <= 0;
      last_buffer <= 0;
      power_valid_out <= 0;
    end else begin
      // Stage 1: compute squares
      fft_ready_out <= ~stall_1;
      if (!stall_1) begin
        real_square <= real_in * real_in;
        imag_square <= imag_in * imag_in;
        square_valid <= fft_valid_in;
        last_buffer <= fft_last_in;
      end
      // Stage 2: compute sum
      if (!stall_2) begin
        power_data_out <= real_square + imag_square;
        power_valid_out <= square_valid;
        power_last_out <= last_buffer;
      end
    end
  end

endmodule

`default_nettype wire
