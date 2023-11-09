`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `pipeline`
 *
 * Creates an n-stage pipeline of some data.
 */
module pipeline #(
  parameter WIDTH,
  parameter DEPTH
) (
  input wire clk_in,
  input wire rst_in,
  input wire [WIDTH-1:0] val_in,
  output logic [WIDTH-1:0] val_out
);

  logic [WIDTH-1:0] pipe [DEPTH-1:0];

  generate
    genvar i;
    for (i = 0; i < DEPTH; i = i + 1) begin
      always_ff @(posedge clk_in) begin
        if (rst_in) begin
          pipe[i] <= 0;
        end else begin
          if (i == 0) begin
            pipe[i] <= val_in;
          end else begin
            pipe[i] <= pipe[i - 1];
          end
        end
      end
    end
  endgenerate

  assign val_out = pipe[DEPTH-1];

endmodule

`default_nettype wire
