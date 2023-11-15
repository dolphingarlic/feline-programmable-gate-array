`timescale 1ns / 1ps
`default_nettype none

module gen_triangular_filters_tb;

  // Input logics
  logic clk_in, rst_in;
  logic [31:0] power_in;
  logic [8:0] k_in;

  logic [31:0] filtered_out_0;
  triangular_filter_0 uut_0 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_0));

  logic [31:0] filtered_out_1;
  triangular_filter_1 uut_1 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_1));

  logic [31:0] filtered_out_2;
  triangular_filter_2 uut_2 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_2));

  logic [31:0] filtered_out_3;
  triangular_filter_3 uut_3 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_3));

  logic [31:0] filtered_out_4;
  triangular_filter_4 uut_4 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_4));

  logic [31:0] filtered_out_5;
  triangular_filter_5 uut_5 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_5));

  logic [31:0] filtered_out_6;
  triangular_filter_6 uut_6 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_6));

  logic [31:0] filtered_out_7;
  triangular_filter_7 uut_7 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_7));

  logic [31:0] filtered_out_8;
  triangular_filter_8 uut_8 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_8));

  logic [31:0] filtered_out_9;
  triangular_filter_9 uut_9 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_9));

  logic [31:0] filtered_out_10;
  triangular_filter_10 uut_10 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_10));

  logic [31:0] filtered_out_11;
  triangular_filter_11 uut_11 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_11));

  logic [31:0] filtered_out_12;
  triangular_filter_12 uut_12 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_12));

  logic [31:0] filtered_out_13;
  triangular_filter_13 uut_13 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_13));

  logic [31:0] filtered_out_14;
  triangular_filter_14 uut_14 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_14));

  logic [31:0] filtered_out_15;
  triangular_filter_15 uut_15 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_15));

  logic [31:0] filtered_out_16;
  triangular_filter_16 uut_16 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_16));

  logic [31:0] filtered_out_17;
  triangular_filter_17 uut_17 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_17));

  logic [31:0] filtered_out_18;
  triangular_filter_18 uut_18 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_18));

  logic [31:0] filtered_out_19;
  triangular_filter_19 uut_19 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_19));

  logic [31:0] filtered_out_20;
  triangular_filter_20 uut_20 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_20));

  logic [31:0] filtered_out_21;
  triangular_filter_21 uut_21 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_21));

  logic [31:0] filtered_out_22;
  triangular_filter_22 uut_22 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_22));

  logic [31:0] filtered_out_23;
  triangular_filter_23 uut_23 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_23));

  logic [31:0] filtered_out_24;
  triangular_filter_24 uut_24 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_24));

  logic [31:0] filtered_out_25;
  triangular_filter_25 uut_25 (.clk_in(clk_in), .rst_in(rst_in),
    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_25));


  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("gen_triangular_filters.vcd");
    $dumpvars(0, gen_triangular_filters_tb);
    $display("Starting sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    power_in = 0;
    k_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: flat signal
    power_in = 32'hDEADBEEF;
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    // Test case 2: sine wave
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      power_in = 32'hDEADBEEF * $sin(i / 5.0) * $sin(i / 5.0);
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
