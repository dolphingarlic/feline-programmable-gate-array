`timescale 1ns / 1ps
`default_nettype none

module microphones_tb;

  // Input logics
  logic clk_in, rst_in;
  logic mic_data, mic_lr_clk, mic_sclk;
  logic axis_aud_tready, axis_aud_tvalid;
  logic [31:0] axis_aud_tdata;

  microphones uut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    
    .mic_data(mic_data),
    .mic_lr_clk(mic_lr_clk),
    .mic_sclk(mic_sclk),

    .axis_aud_tready(axis_aud_tready),
    .axis_aud_tdata(axis_aud_tdata),
    .axis_aud_tvalid(axis_aud_tvalid),
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("microphones.vcd");
    $dumpvars(0, microphones_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Is it generating the correct clk and lr signals?
    axis_aud_tready = 1;
    mic_data = 1;

    #1000;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
