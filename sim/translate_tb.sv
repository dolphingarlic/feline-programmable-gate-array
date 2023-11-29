`timescale 1ns / 1ps
`default_nettype none

module translate_tb;

  // Input logics
  logic clk_in, rst_in;
  
  logic [127:0] data_in;
  logic [127:0] data_out;

  logic valid_in, ready_out, valid_out;

  translate uut(
    .clk_in(clk_in),

    .data_in(data_in),
    .valid_in(valid_in),

    .data_out(data_out),
    .ready_out(ready_out),
    .valid_out(valid_out)
  );

  always begin
      #5; // 100MHz clock
      clk_in = ~clk_in;
  end

  initial begin
    $dumpfile("vcd/translate_tb.vcd");
    $dumpvars(0, translate_tb);
    $display("Starting Sim");

    // Initialize variables
    clk_in = 0;

    while (ready_out == 1'b0) begin
        #10;
    end

    data_in = 128'h00_03_00_04_00_03_00_04_00_03_00_04_00_03_00_04;
    valid_in = 1'b1;

    #10;

    while (valid_out == 1'b0) begin
        #10;
    end

    $display("data_out is %h", data_out);

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
