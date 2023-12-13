`timescale 1ns / 1ps
`default_nettype none

/**
  Servo Control Module - Given an bin (representing pi/8 radians from 0 degress) generate a PWM signal to control the servo
**/

module servo (
            input wire clk_in, // at 98.304 MHz
            input wire rst_in,

            input wire [3:0] bin,

            output logic pwm_out
);

  localparam PWM_FREQ = 1_966_079; // 50Hz so 98.304 MHz / 50 = 1_966_080

  // Convert bin to the divider

  logic [21:0] counter;

  logic [21:0] divisor;

  always_comb begin
    case (bin)
      0,12,13,14,15: divisor = 22'd49_152; // 0 degrees
      1: divisor = 22'd72_499;
      2: divisor = 22'd95_847;
      3: divisor = 22'd119_194;
      4: divisor = 22'd142_541;
      5: divisor = 22'd165_888;
      6: divisor = 22'd189_236;
      7: divisor = 22'd212_583;
      8,9,10,11: divisor = 22'd235_930; // 180 degrees
      default: divisor = 22'd235_930;
    endcase
  end

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      counter <= 0;
      pwm_out <= 1;
    end else begin
      if (counter == PWM_FREQ) begin
        counter <= 0;
        pwm_out <= 1;
      end else begin
        if (counter == divisor) begin
          pwm_out <= 0;
        end

        counter <= counter + 1;
      end
    end
  end

endmodule
`default_nettype wire

