`timescale 1ns / 1ps
`default_nettype none

module uart_tick_generator #(
  parameter BAUDRATE_HZ = 115_200,
  parameter CLK_HZ = 100_000_000,
  parameter SAMPLE_RATE = 16
) (
  input wire clk_in,
  input wire rst_in,
  output logic tick_out
);

  // (100MHz input) / (115200 baud rate) / (16 ticks per baud) = 54 clock periods per tick
  localparam PERIODS_PER_TICK = CLK_HZ / BAUDRATE_HZ / SAMPLE_RATE;

  logic [$clog2(PERIODS_PER_TICK)-1:0] baud_counter;

  always_ff @(posedge clk_in) begin
    if (rst_in || baud_counter == PERIODS_PER_TICK - 1) baud_counter <= 0;
    else baud_counter <= baud_counter + 1;
  end

  assign tick_out = (baud_counter == PERIODS_PER_TICK - 1);

endmodule

`default_nettype wire
