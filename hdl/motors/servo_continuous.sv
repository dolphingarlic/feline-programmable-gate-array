`timescale 1ns / 1ps
`default_nettype none

/**
  Servo Control Module - Given an bin (representing pi/8 radians from 0 degress) generate a PWM signal to 
**/

module servo_continuous (
            input wire clk_in, // at 98.304 MHz
            input wire rst_in,

            input wire [21:0] divisor,

            output logic pwm_out
);

  localparam PWM_FREQ = 1_966_079; // 50Hz so 98.304 MHz / 50 = 1_966_080

  // Convert bin to the divider

  logic [21:0] counter;

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

