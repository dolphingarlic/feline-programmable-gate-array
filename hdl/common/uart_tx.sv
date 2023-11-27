`timescale 1ns / 1ps
`default_nettype none

module uart_tx #(
  parameter SAMPLE_RATE = 16
) (
  input wire clk_in,
  input wire rst_in,
  input wire tick_in,
  input wire [7:0] data_in,
  input wire enable_in,
  output logic tx_out,
  output logic busy_out,
  output logic done_out
);

  typedef enum { IDLE=0, WRITE=1, DONE=2 } uart_tx_state;
  uart_tx_state state;
  logic [$clog2(SAMPLE_RATE)-1:0] counter;
  logic [8:0] input_buffer;
  logic [3:0] curr_bit;

  assign busy_out = (state != IDLE);

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      state <= IDLE;
      counter <= 0;
      input_buffer <= 0;
      curr_bit <= 0;
      tx_out <= 1;
      done_out <= 0;
    end else begin
      if (state == IDLE) begin
        done_out <= 0;
        // Start sending data
        if (enable_in && !done_out) begin
          state <= WRITE;
          counter <= 0;
          curr_bit <= 0;
          input_buffer <= {1'b1, data_in};
          // Pull the tx line low for the start bit
          tx_out <= 0;
        end
      end else if (state == WRITE && tick_in) begin
        if (counter == SAMPLE_RATE - 1) begin
          // Stop after sending the end bit
          if (curr_bit == 8) begin
            tx_out <= 1;
            counter <= 0;
            state <= DONE;
          end else begin
            // Else start sending the next bit
            tx_out <= input_buffer[0];
            input_buffer <= {1'b0, input_buffer[7:1]};
            counter <= 0;
            curr_bit <= curr_bit + 1;
          end
        end else counter <= counter + 1;
      end else if (state == DONE && tick_in) begin
        if (counter == SAMPLE_RATE - 1) begin
          done_out <= 1;
          state <= IDLE;
        end else counter <= counter + 1;
      end
    end
  end

endmodule

`default_nettype wire
