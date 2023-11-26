`timescale 1ns / 1ps
`default_nettype none

module microphones_tb;

  // Input logics
  logic clk_in, rst_in;
  logic sck, ws;

  logic mic_data;

  microphones uut (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .mic_data(mic_data),
    .mic_sck(sck),
    .mic_ws(ws)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  logic [5:0] sck_counter;
  logic sck_prev;
  logic signed [0:31] j;

  // Generate and transmit a sine wave
  real freq = 1e6; // 1MHz frequency
  real ampl = 0.5;  // Amplitude
  real angle = 0;

  initial begin
    $dumpfile("microphones.vcd");
    $dumpvars(0, microphones_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;

    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    while (ws == 1'b0) begin
        #10;
    end

    sck_prev = sck;
    sck_counter = 0;

    for (int i = 0; i < 30; i = i + 1) begin
      $display("i is %d", i);

      angle = i * 3.1415 * 2 / 360;

      j = 32'h7F_FF_FF_FF * $sin(1.0 * angle); // 2's complement

      while (sck_counter < 32) begin
          if (sck == 1'b1 && sck_prev == 1'b0) begin
              mic_data = j[sck_counter];
              sck_counter = sck_counter + 1;
          end
          sck_prev = sck;
          #10;
      end

      sck_counter = 0;
      #10;
    end

    // for (int i = 0; i <= 8'h0A; i = i + 1) begin
    //     $display("i is %d", i);
    //     j = i << 24;
    //     while (sck_counter < 32) begin
    //         if (sck == 1'b1 && sck_prev == 1'b0) begin
    //             mic_data = j[sck_counter];
    //             sck_counter = sck_counter + 1;
    //         end
    //         sck_prev = sck;
    //         #10;
    //     end
    //     sck_counter = 0;
    //     #10;
    // end

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
