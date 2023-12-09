`timescale 1ns / 1ps
`default_nettype none

module synchronizer #(
  parameter SYNC_DEPTH = 2
) (
  input wire clk_in,
  input wire rst_in,
  input wire us_in,
  output logic s_out
);

  logic [SYNC_DEPTH-1:0] sync;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      sync <= {(SYNC_DEPTH){us_in}};
    end else begin
      sync[SYNC_DEPTH-1] <= us_in;
      for (int i = 1; i < SYNC_DEPTH; i = i + 1) begin
        sync[i - 1] <= sync[i];
      end
    end
  end
  assign s_out = sync[0];

endmodule

`default_nettype wire
