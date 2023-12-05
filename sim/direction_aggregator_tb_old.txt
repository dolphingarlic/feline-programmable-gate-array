`timescale 1ns / 1ps
`default_nettype none

module direction_aggregator_tb;

  // Input logics
  logic clk_in, rst_in;

  logic direction_valid_in;
  logic [31:0] direction;

  logic [15:0] angle;
  logic angle_valid_out;

  // INPUTS

  direction_aggregator uut(
    .clk_in(clk_in),
    .rst_in(rst_in),

    .direction_valid_in(direction_valid_in),
    .direction(direction),

    .angle(angle),
    .angle_valid_out(angle_valid_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  initial begin
    // $dumpfile("vcd/direction_calculator_tb.vcd");
    // $dumpvars(0, direction_calculator_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;

    #10;

    rst_in = 1;

    #10

    rst_in = 0;
    direction = 32'h03_00_03_00;
    direction_valid_in = 1;

    #10;

    while (angle_valid_out == 0) begin
      #10;
    end

    $display("Angle is %b", angle);

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
