`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `laser_chaser`
 *
 * Code structure adapted from 6.2050 lab 5.
 * Chases a red laser dot in the camera frame.
 */
module laser_chaser (
  input wire clk_in,
  input wire rst_in,

  input wire [7:0] chroma_lower_bound_in, // 0x60 works well
  input wire [7:0] chroma_upper_bound_in, // 0xF0 works well
  input wire [15:0] detection_threshold_in, // 0x0700 works well

  input wire [7:0] pmoda,
  input wire [2:0] pmodb,
  output logic pmodbclk,
  output logic pmodblock,

  output logic [1:0] detected_out
);

  logic clk_pixel;
  // Keep the pixel clock at 98.304 MHz because we're not displaying stuff
  assign clk_pixel = clk_in;

  // Synchronize the camera inputs
  logic cam_clk_buff, cam_clk_in;
  logic vsync_buff, vsync_in;
  logic href_buff, href_in;
  logic [7:0] pixel_buff, pixel_in;

  always_ff @(posedge clk_pixel) begin
    cam_clk_buff <= pmodb[0];
    cam_clk_in <= cam_clk_buff;
    vsync_buff <= pmodb[1];
    vsync_in <= vsync_buff;
    href_buff <= pmodb[2];
    href_in <= href_buff;
    pixel_buff <= pmoda;
    pixel_in <= pixel_buff;
  end

  ///////////////////////
  // GRAB CAMERA INPUT //
  ///////////////////////
  logic [15:0] cam_pixel;
  logic valid_pixel, frame_done;

  camera camera_inst (
    .clk_pixel_in(clk_pixel),

    .cam_clk_in(cam_clk_in),
    .vsync_in(vsync_in),
    .href_in(href_in),
    .pixel_in(pixel_in),
  
    .pmodbclk(pmodbclk),
    .pmodblock(pmodblock),
    .pixel_out(cam_pixel),
    .pixel_valid_out(valid_pixel),
    .frame_done_out(frame_done)
  );

  /////////////////////
  // GET COORDINATES //
  /////////////////////
  logic [15:0] pixel_data_rec;
  logic data_valid_rec;
  logic [8:0] hcount_rec;
  logic [7:0] vcount_rec;

  recover recover_inst (
    .clk_in(clk_pixel),
    .rst_in(rst_in),

    .valid_pixel_in(valid_pixel),
    .pixel_in(cam_pixel),
    .frame_done_in(frame_done),

    .pixel_out(pixel_data_rec),
    .data_valid_out(data_valid_rec),
    .hcount_out(hcount_rec),
    .vcount_out(vcount_rec)
  );

  //////////////////////////
  // CONVERT RGB -> YCrCb //
  //////////////////////////
  logic [9:0] cr_full;
  logic [7:0] cr;

  // 3-cycle latency; we only care about the Cr channel
  rgb_to_ycrcb rgb_to_ycrcb_inst (
    .clk_in(clk_pixel),
    .r_in({pixel_data_rec[15:11], 3'b0}),
    .g_in({pixel_data_rec[10:5], 2'b0}),
    .b_in({pixel_data_rec[4:0], 3'b0}),
    .y_out(),
    .cr_out(cr_full),
    .cb_out()
  );

  assign cr = cr_full[7:0];

  //////////////////
  // THRESHOLDING //
  //////////////////
  logic mask;

  // 1 cycle latency
  threshold threshold_inst (
    .clk_in(clk_pixel),
    .rst_in(rst_in),
    .pixel_in(cr),
    .lower_bound_in(chroma_lower_bound_in),
    .upper_bound_in(chroma_upper_bound_in),
    .mask_out(mask)
  );

  //////////////////////////
  // DETECT THE RED STUFF //
  //////////////////////////
  logic [8:0] hcount_buf;
  logic [7:0] vcount_buf;
  logic data_valid_buf;

  logic [15:0] l_mask_cnt, r_mask_cnt;

  pipeline #(
    .WIDTH(18),
    .DEPTH(4)
  ) coord_pipeline (
    .clk_in(clk_pixel),
    .rst_in(rst_in),
    .val_in({hcount_rec, vcount_rec, data_valid_rec}),
    .val_out({hcount_buf, vcount_buf, data_valid_buf})
  );

  always_ff @(posedge clk_pixel) begin
    if (rst_in) begin
      l_mask_cnt <= 0;
      r_mask_cnt <= 0;
      detected_out <= 0;
    end else if (data_valid_buf) begin
      if (hcount_buf == 1 && vcount_buf == 1) begin
        detected_out <= {l_mask_cnt > detection_threshold_in, r_mask_cnt > detection_threshold_in};
        l_mask_cnt <= mask;
        r_mask_cnt <= 0;
      end else begin
        // Upper half of the frame (i.e. the left side)
        if (vcount_buf < 160) l_mask_cnt <= l_mask_cnt + mask;
        // Lower half of the frame (i.e. the right side)
        else r_mask_cnt <= r_mask_cnt + mask;
      end
    end
  end

endmodule

`default_nettype wire
