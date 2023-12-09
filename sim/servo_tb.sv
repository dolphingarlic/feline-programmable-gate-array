`timescale 1ns / 1ps
`default_nettype none

module servo_tb;

  // Input logics
  logic clk_in;
  logic rst_in;

  logic pwm_out;

  servo uut(
    .clk_in(clk_in),
    .rst_in(rst_in),
    .pwm_out(pwm_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  initial begin
    $dumpfile("vcd/servo_tb.vcd");
    $dumpvars(0, servo_tb);
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
