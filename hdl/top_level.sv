`timescale 1ns / 1ps
`default_nettype none

module top_level (
  input wire clk_100mhz,
  input wire [15:0] sw,
  input wire [3:0] btn,
  output wire [15:0] led,

  output logic [2:0] rgb0,
  output logic [2:0] rgb1
);

  // Global reset
  logic sys_rst;
  assign sys_rst = btn[0];

  assign rgb1 = rgb0;

  feature_extractor feature_extractor_inst (
    .clk_in(clk_100mhz),
    .rst_in(sys_rst),
    
    .fft_data_in({sw, sw[3:0], sw[11:4], sw[15:12]}),
    .fft_valid_in(btn[1]),
    .fft_last_in(btn[2]),
    .fft_ready_out(rgb0[0]),

    .feature_ready_in(btn[3]),
    .feature_last_out(rgb0[1]),
    .feature_valid_out(rgb0[2]),
    .feature_data_out(led)
  );

endmodule

`default_nettype wire
