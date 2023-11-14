`timescale 1ns / 1ps
`default_nettype none

module uart_rx_tb();

  logic clk_in;
  logic rst_in;
  logic uart_tick;
  logic rx_in;
  logic [7:0] data_out;
  logic done_out;

  uart_tick_generator #(
    .BAUDRATE_HZ(115_200),
    .CLK_HZ(100_000_000),
    .SAMPLE_RATE(16)
  ) brg (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_out(uart_tick)
  );
  uart_rx #(
    .SAMPLE_RATE(16)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .rx_in(rx_in),
    .enable_in(1'b1),
    .data_out(data_out),
    .done_out(done_out)
  );

  always begin
      #5;
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);
    $display("Starting Sim");
    clk_in = 0;
    rst_in = 0;
    rx_in = 1;
    #6;
    rst_in = 1;
    #10;
    rst_in = 0;
    $display("Starting");

    #1000;
    rx_in = 0;
    #8680
    rx_in = 1;
    #8680
    #8680
    #8680
    rx_in = 0;
    #8680
    #8680
    rx_in = 1;
    #8680
    rx_in = 0;
    #8680
    #8680
    rx_in = 1;
    #10000

    #10000
    rx_in = 0;
    #8680
    #8680
    #8680
    rx_in = 1;
    #8680
    rx_in = 0;
    #8680
    #8680
    #8680
    rx_in = 1;
    #8680
    #8680
    #10000

    $display("Finishing");
    $finish;
  end

endmodule

`default_nettype wire
