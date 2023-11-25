`timescale 1ns / 1ps
`default_nettype none

module microphones_tb;

  // Input logics
  logic clk_in, rst_in;
  logic sck, ws;

  logic [31:0] mic_data;

  i2s_controller i2s_controller_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .sck(sck),
    .ws(ws)
  );

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

  logic prev_ws;

  initial begin
    $dumpfile("microphones.vcd");
    $dumpvars(0, microphones_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    mic_data = 1;

    // Transmit a high-frequency sine wave
    for (int i = 0; i < 512; i = i + 1) begin
      mic_data = 16'hBEEF * $sin(i / 5.0);

      while (prev_ws == 1 || ws == 0) begin
        prev_ws = ws;
        #10;
      end
    end

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
