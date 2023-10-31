`timescale 1ns / 1ps
`default_nettype none
 
module biometrics #(
  
) (
  input wire clk_in,
  input wire rst_in,
  input wire uart_rx_in,
  input wire uart_cts_in,
  
  output logic detected_out,
  output logic uart_tx_out,
  output logic uart_rts_out
);

  feature_extractor #(

  ) feature_extractor_inst (

  );

endmodule

`default_nettype wire
