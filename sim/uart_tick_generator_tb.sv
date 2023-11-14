`timescale 1ns / 1ps
`default_nettype none

module uart_tick_generator_tb();

  logic clk_in;
  logic rst_in;
  logic tick_out;

  uart_tick_generator #(
    .BAUDRATE_HZ(115_200),
    .CLK_HZ(100_000_000),
    .SAMPLE_RATE(16)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_out(tick_out)
  );

  always begin
      #5;
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("uart_tick_generator.vcd");
    $dumpvars(0, uart_tick_generator_tb);
    $display("Starting Sim");
    clk_in = 0;
    rst_in = 0;
    #6;
    rst_in = 1;
    #10;
    rst_in = 0;
    $display("Starting");
    #10000;
    $display("Finishing");
    $finish;
  end

endmodule

`default_nettype wire
