`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `mel_filterbank`
 *
 * Computes mel filterbank energies from the power spectrum.
 */
module mel_filterbank #(
  parameter NUM_FILTERS,
  parameter N_FFT
) (
  input wire clk_in,
  input wire rst_in,
  
  input wire [31:0] power_data_in,
  input wire power_valid_in,
  input wire power_last_in,
  output logic power_ready_out,

  input wire filtered_ready_in,
  output logic filtered_valid_out,
  output logic [31:0] filtered_data_out [NUM_FILTERS-1:0]
);

  logic [$clog2(N_FFT)-1:0] k_curr;
  logic [31:0] filter_buffer [NUM_FILTERS-1:0];
  logic input_valid_buffer, input_last_buffer;

  // The triangular filters take 2 cycles to complete, so buffer the control
  // signals for 2 cycles
  pipeline #(
    .WIDTH(2),
    .DEPTH(2)
  ) input_valid_buffer_pipeline (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .val_in({power_valid_in, power_last_in}),
    .val_out({input_valid_buffer, input_last_buffer})
  );


  // Run the triangular filters in parallel
  triangular_filter_0 triangular_filter_inst_0 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[0]));
  triangular_filter_1 triangular_filter_inst_1 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[1]));
  triangular_filter_2 triangular_filter_inst_2 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[2]));
  triangular_filter_3 triangular_filter_inst_3 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[3]));
  triangular_filter_4 triangular_filter_inst_4 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[4]));
  triangular_filter_5 triangular_filter_inst_5 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[5]));
  triangular_filter_6 triangular_filter_inst_6 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[6]));
  triangular_filter_7 triangular_filter_inst_7 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[7]));
  triangular_filter_8 triangular_filter_inst_8 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[8]));
  triangular_filter_9 triangular_filter_inst_9 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[9]));
  triangular_filter_10 triangular_filter_inst_10 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[10]));
  triangular_filter_11 triangular_filter_inst_11 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[11]));
  triangular_filter_12 triangular_filter_inst_12 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[12]));
  triangular_filter_13 triangular_filter_inst_13 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[13]));
  triangular_filter_14 triangular_filter_inst_14 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[14]));
  triangular_filter_15 triangular_filter_inst_15 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[15]));
  triangular_filter_16 triangular_filter_inst_16 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[16]));
  triangular_filter_17 triangular_filter_inst_17 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[17]));
  triangular_filter_18 triangular_filter_inst_18 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[18]));
  triangular_filter_19 triangular_filter_inst_19 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[19]));
  triangular_filter_20 triangular_filter_inst_20 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[20]));
  triangular_filter_21 triangular_filter_inst_21 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[21]));
  triangular_filter_22 triangular_filter_inst_22 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[22]));
  triangular_filter_23 triangular_filter_inst_23 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[23]));
  triangular_filter_24 triangular_filter_inst_24 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[24]));
  triangular_filter_25 triangular_filter_inst_25 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[25]));
  triangular_filter_26 triangular_filter_inst_26 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[26]));
  triangular_filter_27 triangular_filter_inst_27 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[27]));
  triangular_filter_28 triangular_filter_inst_28 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[28]));
  triangular_filter_29 triangular_filter_inst_29 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[29]));
  triangular_filter_30 triangular_filter_inst_30 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[30]));
  triangular_filter_31 triangular_filter_inst_31 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[31]));


  always_ff @(posedge clk_in) begin
    if (rst_in || (filtered_valid_out && filtered_ready_in)) begin
      // Reset values to zero once we're done
      k_curr <= 0;
      filtered_valid_out <= 0;
      for (int i = 0; i < NUM_FILTERS; i = i + 1) begin
        filtered_data_out[i] <= 0;
      end
      // Stop stalling after releasing held data
      power_ready_out <= 1;
    end else begin
      // TODO: handle overflow lmao
      if (input_valid_buffer) begin
        for (int i = 0; i < NUM_FILTERS; i = i + 1) begin
          filtered_data_out[i] <= filtered_data_out[i] + filter_buffer[i];
        end
      end

      // Advance the pipeline once we've consumed a valid input
      if (power_valid_in) begin
        k_curr <= k_curr + 1;

        if (power_last_in) begin
          // The output isn't valid yet, but we can't accept more inputs
          power_ready_out <= 0;
        end
      end

      // The output is valid once we finish processing the last input
      if (input_last_buffer) begin
        filtered_valid_out <= 1;
      end
    end
  end

endmodule

`default_nettype wire
