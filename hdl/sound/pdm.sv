`timescale 1ns / 1ps
`default_nettype none

/**
    * @brief PDM module
    * @details This module takes in a 16-bit signed value and outputs a 1-bit PDM signal
*/

module pdm_tick_generator(
  input wire clk_in,
  input wire rst_in,
  output logic pdm_tick
);

  logic [8:0] m_clock_counter;

  localparam PDM_COUNT_PERIOD = 32;
  localparam NUM_PDM_SAMPLES = 512;

  logic mic_clk;
  logic old_mic_clk;
  logic pdm_signal_valid;

  assign pdm_tick = mic_clk && ~old_mic_clk;

  always_ff @(posedge clk_in)begin
    mic_clk <= m_clock_counter < PDM_COUNT_PERIOD/2;
    m_clock_counter <= (m_clock_counter==PDM_COUNT_PERIOD-1)?0:m_clock_counter+1;
    old_mic_clk <= mic_clk;
  end

endmodule

module pdm (
  input wire clk_in,
  input wire rst_in,
  input wire signed [15:0] level_in, // Changed to 16 bits
  output logic pdm_out
);

  logic tick;

  pdm_tick_generator pdm_tick_generator_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .pdm_tick(tick)
  );

  logic signed [16:0] error; // Changed to 17 bits to accommodate 16-bit values

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      error <= 0;
    end else if (tick) begin
      error <= error + level_in - (error > 0 ? 32767 : -32768); // Adjusted for 16-bit values
    end
  end

  assign pdm_out = error > 0;

endmodule

`default_nettype wire