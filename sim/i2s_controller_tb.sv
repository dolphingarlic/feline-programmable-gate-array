`timescale 1ns / 1ps
`default_nettype none

module i2s_controller_tb;

  // Input logics
  logic clk_in, rst_in;
  logic sck, ws;

  i2s_controller uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .sck(sck),
    .ws(ws)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("vcd/i2s_controller.vcd");
    $dumpvars(0, i2s_controller_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;

    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // We just want to wait a while and then check if the sck and ws signals are present in vcd

    for (int i = 0; i < 100000; i++) begin
      #10;
    end

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
