`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `recover`
 *
 * Code modified from 6.2050 Lab 5.
 * Given raw camera pixel input, determines the position of the pixel.
 * Note that the resulting image is rotated by 90 degrees.
 */
module recover (
  input wire clk_in,
  input wire rst_in,

  input wire valid_pixel_in,
  input wire [15:0] pixel_in,
  input wire frame_done_in,

  output logic [15:0] pixel_out,
  output logic data_valid_out,
  output logic [8:0] hcount_out, // 320 pixels wide
  output logic [7:0] vcount_out // 240 pixels tall
);

  logic old_valid_pixel_in;

  always_ff @(posedge clk_in) begin
    old_valid_pixel_in <= valid_pixel_in;
    if (rst_in) begin
      hcount_out <= 0;
      vcount_out <= 0;
      old_valid_pixel_in <= 0;
      data_valid_out <= 0;
    end else if (frame_done_in) begin
      hcount_out <= 0;
      vcount_out <= 0;
      data_valid_out <= 0;
    end else if (valid_pixel_in && ~old_valid_pixel_in) begin
      data_valid_out <= 1;
      pixel_out <= pixel_in;
      if (hcount_out == 319) begin
        hcount_out <= 0;
        vcount_out <= vcount_out + 1;
      end else hcount_out <= hcount_out + 1;
    end else begin
      data_valid_out <= 0;
    end
  end

endmodule

`default_nettype wire
