`timescale 1ns / 1ps
`default_nettype none

module microphones_tb;

  logic clk_in, rst_in;

  logic signed [15:0] fir_data;
  logic i2s_receiver_tready;
  logic fir_tvalid;
  logic signed [23:0] data;

  fir_compiler_1 uut (
    .aclk(clk_in),
    .s_axis_data_tvalid(1'b1),
    .s_axis_data_tready(i2s_receiver_tready),
    .s_axis_data_tdata(data), // microphones only output 24 bits of data
    .m_axis_data_tvalid(fir_tvalid),
    .m_axis_data_tdata(fir_data)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  real angle = 0;

  initial begin
    $dumpfile("microphones.vcd");
    $dumpvars(0, microphones_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    data = 0;

    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    for (int i = 0; i < 3600; i = i + 1) begin
      $display("i is %d", i);

      angle = i * 3.1415 * 2 / 360;

      data = 24'h0F_FF_FF * $sin(1.0 * angle) + 24'h00_FF_FF * $sin(128.0 * angle); // 2's complement

      #10;
    end

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
