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
  input wire write_enable_in,

  input wire [15:0] feature_data_in,
  input wire feature_valid_in,
  input wire feature_last_in,
  output logic feature_ready_out,

  output logic ble_valid_out,
  output logic [7:0] ble_data_out,

  input wire ble_uart_rx_in,
  output logic ble_uart_tx_out
);

  logic [15:0] fifo_data;
  logic fifo_valid, fifo_last, fifo_ready;

  axis_data_fifo_2byte_256 fifo_inst (
    .s_axis_aclk(clk_in),
    .s_axis_aresetn(~rst_in),
    .s_axis_tvalid(feature_valid_in),
    .s_axis_tready(feature_ready_out),
    .s_axis_tdata(feature_data_in),
    .s_axis_tlast(feature_last_in),
    .m_axis_tvalid(fifo_valid),
    .m_axis_tdata(fifo_data),
    .m_axis_tlast(fifo_last),
    .m_axis_tready(fifo_ready)
  );

  // We want to write entire frames at a time
  logic frame_write_enable, fifo_last_buffer;
  // So use a consistent write_enable signal across a single frame
  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      frame_write_enable <= 0;
      fifo_last_buffer <= 0;
    end else begin
      if (fifo_last) frame_write_enable <= write_enable_in;
      fifo_last_buffer <= fifo_last;
    end
  end

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
  typedef enum { IDLE=0, DATA=1, FLUSH=2 } ble_write_state;
  ble_write_state state;
  logic [7:0] uart_tx_data, next_uart_tx_data;
  logic curr_byte, uart_tx_enable, uart_tx_busy, uart_tx_done;

  // We're ready to accept  
  assign fifo_ready = (state == IDLE) || !frame_write_enable;
  assign uart_tx_enable = ~fifo_ready;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      state <= IDLE;
      next_uart_tx_data <= 0;
      uart_tx_data <= 0;
      curr_byte <= 0;
    end else begin
      if (state == IDLE && frame_write_enable) begin
        // Oh boy we're ready to start sending new data
        if (fifo_valid) begin
          next_uart_tx_data <= fifo_data[15:8];
          state <= DATA;
          uart_tx_data <= fifo_data[7:0];
          curr_byte <= 0;
        end
      end else if (state == DATA && uart_tx_done) begin
        if (fifo_last_buffer) begin
          // Send a newline character (0x0A) to flush the output
          uart_tx_data <= 8'h0A;
          state <= FLUSH;
        end else begin
          uart_tx_data <= next_uart_tx_data;
          if (curr_byte) state <= IDLE;
          else curr_byte <= 1;
        end
      end else if (state == FLUSH && uart_tx_done) begin
        state <= IDLE;
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
    .busy_out(uart_tx_busy),
    .done_out(uart_tx_done)
  );

  ///////////////
  // READ DATA //
  ///////////////
  uart_rx #(
    .SAMPLE_RATE(SAMPLE_RATE)
  ) uart_rx_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .tick_in(uart_tick),
    .rx_in(ble_uart_rx_in),
    .enable_in(1'b1),
    .data_out(ble_data_out),
    .done_out(ble_valid_out)
  );

endmodule

`default_nettype wire
