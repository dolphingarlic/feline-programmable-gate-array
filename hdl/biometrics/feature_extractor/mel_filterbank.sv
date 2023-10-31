`timescale 1ns / 1ps
`default_nettype none

module mel_filterbank #(
  parameter NUM_FILTERS = 26
) (
  input wire clk_in,
  input wire rst_in,
  
  input wire [31:0] power_data_in,
  input wire power_valid_in,
  output wire power_ready_out,

  input wire filtered_ready_in,
  output wire filtered_valid_out,
  output wire [31:0] filtered_data_out
);

endmodule

`default_nettype wire
