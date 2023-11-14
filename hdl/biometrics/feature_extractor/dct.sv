`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `dct`
 *
 * Computes the discrete cosine transform of the output from
 * mel filtering and logarithm.
 */
module dct #(
  parameter NUM_FILTERS,
  parameter N_DCT
) (
  input wire clk_in,
  input wire rst_in,
  
  input wire [15:0] log_data_in [NUM_FILTERS-1:0],
  input wire log_valid_in,
  output logic log_ready_out,

  input wire dct_ready_in,
  output logic dct_valid_out,
  output logic [15:0] dct_data_out,
  output logic dct_last_out
);

  typedef enum { IDLE=0, FORWARD=1, BACKWARD=2, OUTPUT=3 } dct_state;
  dct_state state;
  assign log_ready_out = (state == IDLE);

  logic [$clog2(N_DCT)-1:0] traversal_idx;
  logic insert_zero;
  logic [15:0] log_data_buffer [NUM_FILTERS-1:0];

  // FFT IP module
  logic [31:0] fft_data_in, fft_data_out;
  logic fft_valid, fft_last, fft_ready;
  xfft_128 xfft_128_inst (
    .aclk(clk_in),
    .s_axis_data_tdata(fft_data_in),
    .s_axis_data_tvalid(fft_valid),
    .s_axis_data_tlast(fft_last),
    .s_axis_data_tready(fft_ready),
    .s_axis_config_tdata(16'b0),
    .s_axis_config_tvalid(1'b0),
    .s_axis_config_tready(),
    .m_axis_data_tdata(fft_data_out),
    .m_axis_data_tvalid(dct_valid_out),
    .m_axis_data_tlast(dct_last_out),
    .m_axis_data_tready(dct_ready_in)
  );
  assign dct_data_out = fft_data_out[15:0];

  // State machine logic
  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      state <= IDLE;
      fft_last <= 0;
      fft_valid <= 0;
      fft_data_in <= 0;
    end else begin
      if (state == IDLE) begin
        if (log_valid_in) begin
          // Once we receive valid input, store it and start processing it
          state <= FORWARD;
          traversal_idx <= 0;
          log_data_buffer <= log_data_in;

          // Set the FFT input already on this cycle
          fft_data_in <= {16'b0, log_data_in[0]};
          fft_valid <= 1;
          insert_zero <= fft_ready;
        end
      end else if (state == OUTPUT) begin
        // Wait for a last signal before enabling requests again
        fft_last <= 0;
        fft_valid <= 0;
        if (dct_last_out) state <= IDLE;
      end else begin
        if (insert_zero) begin
          fft_data_in <= 0;
          // Advance the processing stage after inserting a zero and the FFT accepts it
          if (fft_ready) begin
            if (state == FORWARD) begin
              if (traversal_idx == N_DCT - 1) state <= BACKWARD;
              else traversal_idx <= traversal_idx + 1;
            end else begin
              if (traversal_idx == 0) begin
                state <= OUTPUT;
                fft_last <= 1;
              end else traversal_idx <= traversal_idx - 1;
            end
          end
        end else begin
          // Try insert the filtered value, and zero otherwise
          if (traversal_idx < NUM_FILTERS) begin
            fft_data_in <= {16'b0, log_data_buffer[traversal_idx]};
          end else begin
            fft_data_in <= 0;
          end
        end

        if (fft_ready) insert_zero <= ~insert_zero;
      end
    end
  end

endmodule

`default_nettype wire
