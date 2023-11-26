`timescale 1ns / 1ps
`default_nettype none

module logarithm_tb;

  // Input logics
  logic clk_in, rst_in;
  logic filtered_valid_in, log_ready_in;
  logic [31:0] filtered_data_in;
  // Output logics
  logic filtered_ready_out, log_valid_out;
  logic signed [15:0] log_data_out;

  logarithm uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .filtered_data_in(filtered_data_in),
    .filtered_valid_in(filtered_valid_in),
    .filtered_ready_out(filtered_ready_out),

    .log_ready_in(log_ready_in),
    .log_valid_out(log_valid_out),
    .log_data_out(log_data_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/logarithm.vcd");
    $dumpvars(0, logarithm_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    filtered_valid_in = 0;
    log_ready_in = 0;
    filtered_data_in = 1;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Small values
    filtered_valid_in = 1;
    log_ready_in = 1;
    for (int i = 1; i < 1024; i = i + 1) begin
      filtered_data_in = i;
      #10;
    end
    filtered_valid_in = 0;
    filtered_data_in = 1;
    #10;
    log_ready_in = 0;
    #50;

    // Medium-small values
    filtered_valid_in = 1;
    log_ready_in = 1;
    for (int i = 1024; i < 65_536; i = i + 64) begin
      filtered_data_in = i;
      #10;
    end
    filtered_valid_in = 0;
    filtered_data_in = 1;
    #10;
    log_ready_in = 0;
    #50;

    // Medium-large values
    filtered_valid_in = 1;
    log_ready_in = 1;
    for (int i = 65_536; i < 2_097_152; i = i + 2048) begin
      filtered_data_in = i;
      #10;
    end
    filtered_valid_in = 0;
    filtered_data_in = 1;
    #10;
    log_ready_in = 0;
    #50;

    // Large values
    filtered_valid_in = 1;
    log_ready_in = 1;
    for (int i = 2_097_152; i < 1_073_741_824; i = i + 2_097_152) begin
      filtered_data_in = i;
      #10;
    end
    filtered_valid_in = 0;
    filtered_data_in = 1;
    #10;
    log_ready_in = 0;
    #50;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
