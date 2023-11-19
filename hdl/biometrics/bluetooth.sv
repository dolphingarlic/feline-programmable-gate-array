`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `bluetooth`
 *
 * Over BLE UART:
 * (1) Sends data from the feature extractor to the PC.
 * (2) Receives classifier model parameters from the PC.
 */
module bluetooth #(
  parameter BAUDRATE_HZ = 115_200,
  parameter CLK_HZ = 98_304_000,
  parameter SAMPLE_RATE = 16
) (
  input wire clk_in,
  input wire rst_in,
  // TODO: include a "mode" too (to control when to output data)

  input wire [15:0] feature_data_in,
  input wire feature_valid_in,
  // input wire feature_last_in, // TODO: Use this signal
  output wire feature_ready_out,

  input wire ble_uart_rx_in,
  input wire ble_uart_cts_in,
  output logic ble_uart_tx_out,
  output logic ble_uart_rts_out
);

  logic [15:0] fifo_data;
  logic fifo_valid, fifo_ready;

  axis_data_fifo_2byte_256 fifo_inst (
    .s_axis_aclk(clk_in),
    .s_axis_aresetn(1'b1),
    .s_axis_tvalid(feature_valid_in),
    .s_axis_tready(feature_ready_out),
    .s_axis_tdata(feature_data_in),
    .m_axis_tvalid(fifo_valid),
    .m_axis_tdata(fifo_data),
    .m_axis_tready(fifo_ready)
  );

  logic uart_tick;

  uart_tick_generator #(
    .BAUDRATE_HZ(BAUDRATE_HZ),
    .CLK_HZ(CLK_HZ),
    .SAMPLE_RATE(SAMPLE_RATE)
  ) uart_tick_generator_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_out(uart_tick)
  );

  ////////////////
  // WRITE DATA //
  ////////////////
  typedef enum { IDLE=0, WRITE=1 } write_state;
  write_state state;
  logic [7:0] uart_tx_data, next_uart_tx_data;
  logic curr_byte, uart_tx_enable, uart_tx_busy;

  assign fifo_ready = (state == IDLE);
  // TODO: deal with RTS/CTS
  assign uart_tx_enable = (state == WRITE);

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      state <= IDLE;
      next_uart_tx_data <= 0;
      uart_tx_data <= 0;
      curr_byte <= 0;
    end else begin
      if (state == IDLE) begin
        // Oh boy we're ready to start sending new data
        if (fifo_valid) begin
          next_uart_tx_data <= fifo_data[15:8];
          state <= WRITE;
          uart_tx_data <= fifo_data[7:0];
          curr_byte <= 0;
        end
      end else if (state == WRITE) begin
        // We've finished sending a byte
        if (!uart_tx_busy) begin
          uart_tx_data <= next_uart_tx_data;
          // Transition back to IDLE if we've sent both bytes
          if (curr_byte) state <= IDLE;
          else curr_byte <= 1;
        end
      end
    end
  end

  uart_tx #(
    .SAMPLE_RATE(SAMPLE_RATE)
  ) uart_tx_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .data_in(uart_tx_data),
    .enable_in(uart_tx_enable),
    .tx_out(ble_uart_tx_out),
    .busy_out(uart_tx_busy)
  );

  ///////////////
  // READ DATA //
  ///////////////
  logic [7:0] uart_rx_data;
  logic uart_rx_enable, uart_rx_done;
  // TODO: use RTS/CTS
  assign uart_rx_enable = 1;

  uart_rx #(
    .SAMPLE_RATE(SAMPLE_RATE)
  ) uart_rx_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .rx_in(ble_uart_rx_in),
    .enable_in(uart_rx_enable),
    .data_out(uart_rx_data),
    .done_out(uart_rx_done)
  );

endmodule

`default_nettype wire
