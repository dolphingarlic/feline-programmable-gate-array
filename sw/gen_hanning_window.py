import numpy as np

N_FFT = 512

"""
Generate the hanning coefficients
"""

hanning_coefficents = np.hanning(N_FFT)

# We need to convert to fixed point
scaled_coefficents = np.round(hanning_coefficents * 2**14)

# Generate the case statement
case_statement = ""
for i, coefficent in enumerate(scaled_coefficents):
    case_statement += f"            {i}: scale_factor = 16'd{int(coefficent)};\n"

# Generate the whole file

HANNING_WINDOW_MODULE = f"""
///////////////////////////////
//    AUTO-GENERATED FILE    //
// ------------------------- //
// N_FFT = {N_FFT}               //
///////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module hanning_window #(
    SAMPLES = {N_FFT},
    CHANNELS = 4
) (
    input wire clk_in,
    input wire rst_in,

    input wire [$clog2(SAMPLES) : 0] sample,
    input wire audio_valid_in,
    input wire signed [15:0] audio_data_in [CHANNELS-1:0],

    output logic signed [15:0] audio_data_out [CHANNELS-1:0],
    output logic audio_valid_out
);

    logic signed [15:0] scale_factor;

    always_comb begin
        case (sample)
            {case_statement}
        endcase
    end

    logic [31:0] scaled_value [CHANNELS-1:0];

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            for (integer i = 0; i < CHANNELS; i = i + 1) begin
                scaled_value[i] <= 0;
            end

            audio_valid_out <= 0;
        end else if (audio_valid_in) begin
            for (integer i = 0; i < CHANNELS; i = i + 1) begin
                scaled_value[i] <= (signed'(audio_data_in[i]) * signed'(scale_factor));
            end

            audio_valid_out <= 1;
        end else begin
            for (integer i = 0; i < CHANNELS; i = i + 1) begin
                scaled_value[i] <= 0;
            end

            audio_valid_out <= 0;
        end
    end

    always_comb begin
        for (integer i = 0; i < CHANNELS; i = i + 1) begin
            audio_data_out[i] = scaled_value[i][31:16];
        end
    end

endmodule;

`default_nettype wire
"""

# Write the file
with open("hdl/sound/hanning_window.sv", "w") as f:
    f.write(HANNING_WINDOW_MODULE)
