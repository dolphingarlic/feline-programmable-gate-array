`timescale 1ns / 1ps
`default_nettype none

module dct_tb;

  // Input logics
  logic clk_in, rst_in;
  logic log_valid_in, dct_ready_in;
  logic [15:0] log_data_in [25:0];
  // Output logics
  logic log_ready_out, dct_valid_out, dct_last_out;
  logic [15:0] dct_data_out;

  dct #(
    .NUM_FILTERS(26),
    .N_DCT(32)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .log_data_in(log_data_in),
    .log_valid_in(log_valid_in),
    .log_ready_out(log_ready_out),

    .dct_ready_in(dct_ready_in),
    .dct_valid_out(dct_valid_out),
    .dct_data_out(dct_data_out),
    .dct_last_out(dct_last_out)
  );

  always begin
    #5; // 100MHz clock
    clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/dct.vcd");
    $dumpvars(0, dct_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    log_valid_in = 0;
    dct_ready_in = 0;
    for (int i = 0; i < 26; i = i + 1) begin
      log_data_in[i] = 0;
    end

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test 1: idk man
    log_valid_in = 1;
    dct_ready_in = 1;
    for (int i = 0; i < 26; i = i + 1) begin
      log_data_in[i] = (i - 13) << 11;
    end
    #10;
    log_valid_in = 0;
    for (int i = 0; i < 26; i = i + 1) begin
      log_data_in[i] = 0;
    end
    while (!dct_last_out) #10;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
