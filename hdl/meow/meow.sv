`timescale 1ns / 1ps
`default_nettype none

`ifdef SYNTHESIS
`define FPATH(X) `"X`"
`else /* ! SYNTHESIS */
`define FPATH(X) `"data/X`"
`endif  /* ! SYNTHESIS */

module meow (
  input wire clk_in,
  input wire rst_in,

  input wire activate_in,
  output logic pdm_out
);

  localparam N_AUDIO = 7391;

  logic playing;
  logic [$clog2(N_AUDIO)-1:0] read_idx;
  logic [15:0] audio_level;
  // Play the audio at 12kHz
  logic [12:0] pulse_counter;

  xilinx_true_dual_port_read_first_2_clock_ram #(
    .RAM_WIDTH(16),
    .RAM_DEPTH(N_AUDIO),
    .INIT_FILE(`FPATH(meow.mem))
  ) meow_memory (
    .addra(read_idx),
    .clka(clk_in),
    .wea(1'b0),
    .dina(16'b0),
    .ena(1'b1),
    .regcea(1'b1),
    .rsta(rst_in),
    .douta(audio_level),

    .addrb(read_idx),
    .clkb(clk_in),
    .dinb(16'b0),
    .web(1'b0),
    .enb(1'b0),
    .regceb(1'b0),
    .rstb(rst_in),
    .doutb()
  );

  pdm pdm_inst (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .level_in(audio_level),
    .pdm_out(pdm_out)
  );

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      playing <= 0;
      read_idx <= 0;
    end else begin
      if (~playing && activate_in) begin
        playing <= 1;
      end else if (playing && pulse_counter == 0) begin
        if (read_idx == N_AUDIO - 1) begin
          read_idx <= 0;
          playing <= 0;
        end else read_idx <= read_idx + 1;
      end
    end

    pulse_counter <= pulse_counter + 1;
  end

endmodule

`default_nettype wire
