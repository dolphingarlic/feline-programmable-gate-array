`timescale 1ns / 1ps
`default_nettype none

module classifier_tb;

  // Input logics
  logic clk_in, rst_in;
  logic signed [15:0] feature_data_in;
  logic feature_valid_in, feature_last_in;
  logic [7:0] ble_data_in;
  logic ble_valid_in;
  logic predict_enable_in;
  // Output logics
  logic detected_out;

  classifier #(
    .NUM_FEATURES_IN(4)
  ) uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .feature_data_in(feature_data_in),
    .feature_valid_in(feature_valid_in),
    .feature_last_in(feature_last_in),

    .ble_data_in(ble_data_in),
    .ble_valid_in(ble_valid_in),

    .predict_enable_in(predict_enable_in),
    .detected_out(detected_out)
  );

  always begin
    #5; // 100MHz clock
    clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/classifier.vcd");
    $dumpvars(0, classifier_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    feature_data_in = 0;
    feature_valid_in = 0;
    feature_last_in = 0;
    ble_data_in = 0;
    ble_valid_in = 0;
    predict_enable_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test 1: upload 5 support vectors
    ble_valid_in = 1;
    ble_data_in = 5;
    #10;
    ble_valid_in = 0;
    #100;
    // Vector 1
    ble_valid_in = 1;
    ble_data_in = 8'hEF;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hBE;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hAD;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hDE;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hEF;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hBE;
    #10;
    ble_valid_in = 0;
    #100;
    // Vector 2
    ble_valid_in = 1;
    ble_data_in = 8'h01;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h23;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h45;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h67;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h76;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h54;
    #10;
    ble_valid_in = 0;
    #100;
    // Vector 3
    ble_valid_in = 1;
    ble_data_in = 8'h11;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h05;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h45;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h08;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h19;
    #10;
    ble_valid_in = 0;
    #100;
    // Vector 4
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h00;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'hFF;
    #10;
    ble_valid_in = 0;
    #100;
    // Vector 5
    ble_valid_in = 1;
    ble_data_in = 8'h10;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h20;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h30;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h40;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h50;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h60;
    #10;
    ble_valid_in = 0;
    #100;
    // Finally, send a bias
    ble_valid_in = 1;
    ble_data_in = 8'h07;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h65;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h43;
    #10;
    ble_valid_in = 0;
    #100;
    ble_valid_in = 1;
    ble_data_in = 8'h21;
    #10;
    ble_valid_in = 0;
    #100;

    #1000;

    // Test 2: Process a feature vector
    predict_enable_in = 1;
    feature_valid_in = 1;
    feature_data_in = 16'hBEEF;
    #10;
    feature_data_in = 16'hDEAD;
    #10;
    feature_data_in = 16'h1337;
    #10;
    feature_last_in = 1;
    feature_data_in = 16'h4321;
    #10;
    feature_valid_in = 0;
    feature_last_in = 0;

    #1000;

    // Test 3: ... and another
    predict_enable_in = 1;
    feature_valid_in = 1;
    feature_data_in = 16'h1234;
    #10;
    feature_data_in = 16'h0101;
    #10;
    feature_data_in = 16'h1337;
    #10;
    feature_last_in = 1;
    feature_data_in = 16'h0690;
    #10;
    feature_valid_in = 0;
    feature_last_in = 0;

    #1000;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
