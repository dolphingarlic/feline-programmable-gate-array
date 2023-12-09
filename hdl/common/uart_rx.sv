`timescale 1ns / 1ps
`default_nettype none

module ble_uart_rx #(
  parameter SAMPLE_RATE = 16
) (
  input wire clk_in,
  input wire rst_in,
  input wire tick_in,
  input wire rx_in,
  input wire enable_in,
  output logic [7:0] data_out,
  output logic busy_out,
  output logic done_out
);

  typedef enum { IDLE=0, WAIT_FOR_START=1, READ=2, DONE=3 } uart_rx_state;
  uart_rx_state state;
  logic [$clog2(SAMPLE_RATE)-1:0] counter;
  logic [3:0] num_bits_read;

  assign busy_out = (state != IDLE);

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      state <= IDLE;
      counter <= 0;
      data_out <= 0;
      done_out <= 0;
      num_bits_read <= 0;
    end else begin
      if (state == IDLE) begin
        // Detect the falling edge of the rx signal
        if (!rx_in && enable_in) begin
          state <= WAIT_FOR_START;
          counter <= 0;
          num_bits_read <= 0;
        end
      end else if (state == DONE) begin
        state <= IDLE;
        done_out <= 0;
      end else if (tick_in) begin
        // For both the WAIT_FOR_START and READ states, we wait until
        // we're in the middle of a bit (i.e., after (SAMPLE_RATE / 2) ticks)
        // before reading the value
        if (counter == SAMPLE_RATE - 1) counter <= 0;
        else counter <= counter + 1;

        if (counter == SAMPLE_RATE / 2 - 1) begin
          if (state == WAIT_FOR_START) state <= READ;
          else if (num_bits_read < 9) begin
            // UART is little endian
            if (num_bits_read != 8) data_out <= {rx_in, data_out[7:1]};
            num_bits_read <= num_bits_read + 1;
          end else if (rx_in) begin
            // We've detected the end (high) bit
            state <= DONE;
            done_out <= 1;
          end
        end
      end
    end
  end

endmodule

`default_nettype wire
