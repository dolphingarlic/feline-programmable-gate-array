`timescale 1ns / 1ps
`default_nettype none

/**
NOTE: THIS TEST RELIES ON A FUNCTIONAL I2S_CONTROLLER MODULE
*/

module i2s_receiver_tb;

  // Input logics
  logic clk_in, rst_in;
  logic sck, ws;

  i2s_controller i2s_controller_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),

    .sck(sck),
    .ws(ws)
  );

  logic i2s_controller_tvalid, i2s_controller_tlast;
  logic [31:0] i2s_controller_tdata;

  logic mic_data;

  i2s_receiver uut (
    .m_axis_aclk(clk_in),
    .m_axis_aresetn(!rst_in),
    .m_axis_tready(1'b1),
    .m_axis_tvalid(i2s_controller_tvalid),
    .m_axis_tdata(i2s_controller_tdata),
    .m_axis_tlast(i2s_controller_tlast),
    // I2S Interface
    .sck(sck),
    .ws(ws),
    .sd(mic_data)
  );

  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  logic [5:0] sck_counter;
  logic sck_prev;
  logic [0:31] j;

  initial begin
    $dumpfile("i2s_receiver.vcd");
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

    while (ws == 1'b0) begin
        #10;
    end

    sck_prev = sck;
    sck_counter = 0;

    for (int i = 0; i <= 8'hFF; i = i + 1) begin
        $display("i is %d", i);
        j = i << 24;
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

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
