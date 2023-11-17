`timescale 1ns / 1ps
`default_nettype none

module microphones_tb;

  // Input logics
  logic clk_in, rst_in;
  logic sck, ws;

  logic [31:0] mic_data;

  microphones uut(
    .clk_in(clk_in),
    .rst_in(rst_in)

    // Microphone signals
    .mic_data(mic_data),
    .mic_sck(sck),
    .mic_ws(ws)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("i2s_microphones.vcd");
    $dumpvars(0, i2s_receiver_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    mic_data = 1;

    // Transmit all 8 character hex numbers
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
