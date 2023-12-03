`timescale 1ns / 1ps
`default_nettype none

module uart_tx_tb;

  // Input logics
  logic clk_in, rst_in;
  logic uart_tick, enable_in;
  logic [7:0] data_in;
  // Output logics
  logic tx_out, busy_out, done_out;

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
    .enable_in(enable_in),
    .tx_out(tx_out),
    .busy_out(busy_out),
    .done_out(done_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    enable_in = 0;
    data_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Send a value
    enable_in = 1;
    data_in = 8'b10010011;
    #10;
    enable_in = 0;
    #100000

    // And another
    // Send a value
    enable_in = 1;
    data_in = 8'b11000011;
    #10;
    enable_in = 0;
    #100000

    $display("Finishing");
    $finish;
  end

endmodule

`default_nettype wire
