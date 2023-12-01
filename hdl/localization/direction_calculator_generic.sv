`timescale 1ns / 1ps
`default_nettype none

/**
    Computes the direction vector for a given frequency.

    Gets the phase difference between the outer microphones and the center microphone.
    Then scales by the microphones positions and sums all. Finally output is scaled
    by central magnitude.

    We pay particular attention to the bit sizes since they grow really quickly with all the adding
    and multiplying.

    TODO: Improve this code!
*/

module direction_calculator_generic #(
    parameter PERIPHERAL_MICS = 3,
    parameter DATA_WIDTH = 32
) (
    // CENTRAL MICROPHONE
    input logic [DATA_WIDTH - 1: 0] central_mic,
    // PERIPHERAL MICROPHONES
    input logic [DATA_WIDTH - 1: 0] peripheral_mics [PERIPHERAL_MICS-1:0],
    input logic [(DATA_WIDTH / 2) - 1: 0] mic_locations [PERIPHERAL_MICS-1:0][2],
    // OUTPUT
    output logic signed [DATA_WIDTH - 1:0] vector,
    output logic signed [(DATA_WIDTH / 2) + PERIPHERAL_MICS - 1:0] summed_locations [2]
);

    logic signed [(DATA_WIDTH / 2):0] phase_differences [PERIPHERAL_MICS - 1:0];
   
    logic signed [(DATA_WIDTH / 2):0] scaled_locations [PERIPHERAL_MICS - 1:0][2];
    logic signed [DATA_WIDTH + 1 : 0] multiplication_temp;

    always_comb begin
        summed_locations[0] = 0;
        summed_locations[1] = 0;

        for (integer i = 0; i < PERIPHERAL_MICS; i = i + 1) begin: loop
            phase_differences[i] = signed'(peripheral_mics[i][DATA_WIDTH - 1:DATA_WIDTH / 2]) - signed'(central_mic[DATA_WIDTH - 1:DATA_WIDTH / 2]);

            // We need to constraint the phase_difference to be between -pi and pi
            
            // 16'h6488 is pi in 2Q13 format.
            if (phase_differences[i] > signed'(16'h6488)) begin
                // We want to subtract 2pi = 16'hC910 in 2Q13
                phase_differences[i] = phase_differences[i] - signed'(17'hC910);
            end else if (phase_differences[i] < signed'(-16'h6488)) begin
                phase_differences[i] = phase_differences[i] + signed'(17'hC910);
            end

            // Next we need to scale the location vectors by the phase_differences
            multiplication_temp = signed'(phase_differences[i]) * signed'(mic_locations[i][0]); // Scale the x direction (34 bits)

            // Since we scaled the phase_difference to be +pi -pi it is actually 16 bits so the MSB is always
            // the same as the MSB - 1, so we can safetly ignore it
            scaled_locations[i][0] = multiplication_temp[DATA_WIDTH - 1 -: 17];

            // We do the same for the y location
            multiplication_temp = signed'(phase_differences[i]) * signed'(mic_locations[i][1]);
            scaled_locations[i][1] = multiplication_temp[DATA_WIDTH - 1 -: 17]; // NOTE: scaled_locations is 7.10 fixed point

            summed_locations[0] = summed_locations[0] + scaled_locations[i][0]; // Note summed_locations is a 9.10 fixed point
            summed_locations[1] = summed_locations[1] + scaled_locations[i][1]; 
        end
    end

    assign vector = 0;
endmodule