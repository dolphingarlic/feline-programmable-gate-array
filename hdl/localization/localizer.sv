`timescale 1ns / 1ps
`default_nettype none

module localizer #(
    parameter LOWER_FFT_BOUND = 9,
    parameter UPPER_FFT_BOUND = 200
) (
    input wire clk_in,
    input wire rst_in,

    input wire [127:0] fft_data_in, // FFT data is MSB:X_IM,X_RE:0 – https://docs.xilinx.com/r/en-US/pg109-xfft/TDATA-Format?tocId=sjbj66N~wbday6WKmKSDKg
    input wire fft_valid_in,
    input wire fft_last,

    output logic angle_valid_out,
    output logic localizer_ready_out,
    output logic [15:0] angle,

    input wire uart_rxd,
    output logic uart_txd
);

    //////////////////////////////////////////////
    // We don't want to use all the frequencies //
    //////////////////////////////////////////////

    logic [$clog2(UPPER_FFT_BOUND) : 0] fft_counter;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            fft_counter <= 0;
        end else if (fft_last) begin
            fft_counter <= 0;
        end else if (fft_valid_in && fft_counter < UPPER_FFT_BOUND) begin
            fft_counter <= fft_counter + 1;
        end
    end

    //////////////////////////////////////////////
    // Convert values from rectangular to polar //
    //////////////////////////////////////////////

    logic [31:0] translate_data [3:0];
    logic translate_valid;
    logic translate_ready;

    translate translate_inst (
        .clk_in(clk_in),
        .data_in(fft_data_in), // MSB:Y_IN,X_IN:0 https://docs.xilinx.com/v/u/en-US/pg105-cordic pg 16
        .valid_in(fft_valid_in && (fft_counter > LOWER_FFT_BOUND && fft_counter < UPPER_FFT_BOUND)),

        .ready_out(translate_ready),
        .data_out(translate_data),
        .valid_out(translate_valid)
    );
    
    //////////////////////////////////////////////
    // Calculate the direction vector           //
    //////////////////////////////////////////////

    logic [37:0] direction_vector;

    direction_calculator direction_calculator_inst (
        .central_mic(translate_data[0]),
        .peripheral_mics(translate_data[3:1]),
        .vector(direction_vector)
    );
   
    ///////////////////////////////////////////////
    // Sum direction vectors to get angle        //
    ///////////////////////////////////////////////

    logic signed [23:0] [3:0] mag_bins;
    logic aggregator_ready;

    direction_aggregator #(
        .QUANTITY(UPPER_FFT_BOUND - LOWER_FFT_BOUND - 1)
    ) direction_aggregator_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .direction_valid_in(translate_valid),
        .direction(direction_vector),
        .magnitude(translate_data[0][31:16]),

        // .angle(angle),
        .mag_bins(mag_bins),
        .angle_valid_out(angle_valid_out),
        .aggregator_ready(aggregator_ready),

        .m_axis_tready(1'b1)
    );

    assign localizer_ready_out = aggregator_ready && translate_ready;

    // Store the angle

    logic signed [23:0] [3:0] mag_bins_stored;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            for (integer i = 0; i < 4; i = i + 1) begin
                mag_bins_stored[i] <= 0;
            end
        end else if (angle_valid_out) begin
            for (integer i = 0; i < 4; i = i + 1) begin
                mag_bins_stored[i] <= mag_bins[i];
            end
        end
    end

    manta manta_inst (
        .clk(clk_in),

        .rx(uart_rxd),
        .tx(uart_txd),
        
        .mag_bin_0(mag_bins_stored[0]),
        .mag_bin_1(mag_bins_stored[1]),
        .mag_bin_2(mag_bins_stored[2]),
        .mag_bin_3(mag_bins_stored[3])
    );

endmodule;


`default_nettype wire