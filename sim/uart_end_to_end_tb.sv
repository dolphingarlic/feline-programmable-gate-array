`timescale 1ns / 1ps
`default_nettype none

module uart_end_to_end_tb;

  // Input logics
  logic clk_in, rst_in;
  logic uart_tx_enable;
  logic [7:0] data_in;
  // Shared logics
  logic uart_tick, uart_line;
  // Output logics 
  logic [7:0] data_out;
  logic busy_out, tx_done_out, rx_done_out;

  uart_tick_generator #(
    .BAUDRATE_HZ(115_200),
    .CLK_HZ(100_000_000),
    .SAMPLE_RATE(16)
  ) brg (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_out(uart_tick)
  );
  ble_uart_tx #(
    .SAMPLE_RATE(16)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .data_in(data_in),
    .enable_in(uart_tx_enable),
    .tx_out(uart_line),
    .busy_out(busy_out),
    .done_out(tx_done_out)
  );
  ble_uart_rx #(
    .SAMPLE_RATE(16)
  ) uart_rx_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .rx_in(uart_line),
    .enable_in(1'b1),
    .data_out(data_out),
    .done_out(rx_done_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/uart_end_to_end.vcd");
    $dumpvars(0, uart_end_to_end_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    uart_tx_enable = 0;
    data_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Send a value
    uart_tx_enable = 1;
    data_in = 8'b10010011;
    #10;
    uart_tx_enable = 0;
    #100000

    // And another
    // Send a value
    uart_tx_enable = 1;
    data_in = 8'b11000011;
    #10;
    uart_tx_enable = 0;
    #100000

    $display("Finishing");
    $finish;
  end

endmodule

`default_nettype wire
