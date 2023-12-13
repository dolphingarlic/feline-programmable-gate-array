`timescale 1ns / 1ps
`default_nettype none

module dc_motors_tb;

  // Input logics
  logic clk_in;
  logic rst_in;

  logic in1, in2, ena, in3, in4, enb;

  dc_motors uut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .speed_left(8'd0),
    .speed_right(8'd0),
    .in1(in1),
    .in2(in2),
    .ena(ena),
    .in3(in3),
    .in4(in4),
    .enb(enb)
  );


  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  initial begin
    $dumpfile("vcd/dc_motors_tb.vcd");
    $dumpvars(0, dc_motors_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;

    #10;
    
    rst_in = 1;

    #10;

    rst_in = 0;

    // We'll just wait around for a little bit

    for (int i = 0; i < 4_000_000; i = i + 1) begin
      #10;
    end

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
