`timescale 1ns / 1ps
`default_nettype none

/**
    Computes an average direction vector from 256 individual direction vectors
*/

module direction_aggregator #(
    parameter DATA_WIDTH = 32,
    parameter QUANTITY = 512
)(
    input wire clk_in,
    input wire rst_in,

    input wire direction_valid_in,
    input wire [DATA_WIDTH - 1:0] direction,

    output logic [(DATA_WIDTH / 2) - 1:0] angle,
    output logic angle_valid_out,
    output logic aggregator_ready
);

    // If we add QUANTIY DATA_WIDTH-bit numbers the maximum size is:
    localparam AGGREGATE_WIDTH = (DATA_WIDTH / 2) + $clog2(QUANTITY);

    logic [AGGREGATE_WIDTH - 1:0] aggregate_direction_x, aggregate_direction_y;

    logic [$clog2(QUANTITY):0] counter;
    
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            aggregate_direction_x <= 0;
            aggregate_direction_y <= 0;
            counter <= 0;
        end else if (direction_valid_in && counter < QUANTITY) begin
            aggregate_direction_x <= aggregate_direction_x + direction[15:0];
            aggregate_direction_y <= aggregate_direction_y + direction[31:16];
            counter <= counter + 1;
        end
    end

    // We want to get the angle from the aggregate_direction

    logic [(DATA_WIDTH / 2) - 1: 0] shifted_x, shifted_y;
    
    assign shifted_y = aggregate_direction_y[(AGGREGATE_WIDTH - 1) -: (DATA_WIDTH / 2)];
    assign shifted_x = aggregate_direction_x[(AGGREGATE_WIDTH - 1) -: (DATA_WIDTH / 2)];

    logic cordic_valid;
    logic [DATA_WIDTH - 1:0] angle_phase_data;

    cordic_0 cordic_inst (
        .aclk(clk_in),
        .s_axis_cartesian_tdata({shifted_y, shifted_x}),
        .s_axis_cartesian_tvalid(counter == QUANTITY),
        .s_axis_cartesian_tready(aggregator_ready),
        .m_axis_dout_tdata(angle_phase_data),
        .m_axis_dout_tvalid(cordic_valid)
    );

    // We'll store the angle

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            angle <= 0;
            angle_valid_out <= 0;
        end else if (cordic_valid) begin
            angle <= angle_phase_data[31:16];
            angle_valid_out <= 1;
        end
    end

endmodule