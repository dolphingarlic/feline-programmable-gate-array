///////////////////////////////
//    AUTO-GENERATED FILE    //
// ------------------------- //
// N_FFT = 512               //
// NUM_FILTERS = 26          //
// FREQ_LOWERBOUND_HZ = 20   //
// FREQ_UPPERBOUND_HZ = 3000 //
// SAMPLE_RATE_HZ = 6000     //
// INV_PRECISION = 10        //
///////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module triangular_filter_0 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        2: scale_factor <= 0;
        3: scale_factor <= 256;
        4: scale_factor <= 512;
        5: scale_factor <= 768;
        // Falling edge
        6: scale_factor <= 1024;
        7: scale_factor <= 768;
        8: scale_factor <= 512;
        9: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_1 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        6: scale_factor <= 0;
        7: scale_factor <= 256;
        8: scale_factor <= 512;
        9: scale_factor <= 768;
        // Falling edge
        10: scale_factor <= 1024;
        11: scale_factor <= 768;
        12: scale_factor <= 512;
        13: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_2 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        10: scale_factor <= 0;
        11: scale_factor <= 256;
        12: scale_factor <= 512;
        13: scale_factor <= 768;
        // Falling edge
        14: scale_factor <= 1024;
        15: scale_factor <= 819;
        16: scale_factor <= 614;
        17: scale_factor <= 410;
        18: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_3 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        14: scale_factor <= 0;
        15: scale_factor <= 205;
        16: scale_factor <= 410;
        17: scale_factor <= 614;
        18: scale_factor <= 819;
        // Falling edge
        19: scale_factor <= 1024;
        20: scale_factor <= 819;
        21: scale_factor <= 614;
        22: scale_factor <= 410;
        23: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_4 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        19: scale_factor <= 0;
        20: scale_factor <= 205;
        21: scale_factor <= 410;
        22: scale_factor <= 614;
        23: scale_factor <= 819;
        // Falling edge
        24: scale_factor <= 1024;
        25: scale_factor <= 819;
        26: scale_factor <= 614;
        27: scale_factor <= 410;
        28: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_5 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        24: scale_factor <= 0;
        25: scale_factor <= 205;
        26: scale_factor <= 410;
        27: scale_factor <= 614;
        28: scale_factor <= 819;
        // Falling edge
        29: scale_factor <= 1024;
        30: scale_factor <= 819;
        31: scale_factor <= 614;
        32: scale_factor <= 410;
        33: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_6 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        29: scale_factor <= 0;
        30: scale_factor <= 205;
        31: scale_factor <= 410;
        32: scale_factor <= 614;
        33: scale_factor <= 819;
        // Falling edge
        34: scale_factor <= 1024;
        35: scale_factor <= 853;
        36: scale_factor <= 683;
        37: scale_factor <= 512;
        38: scale_factor <= 341;
        39: scale_factor <= 171;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_7 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        34: scale_factor <= 0;
        35: scale_factor <= 171;
        36: scale_factor <= 341;
        37: scale_factor <= 512;
        38: scale_factor <= 683;
        39: scale_factor <= 853;
        // Falling edge
        40: scale_factor <= 1024;
        41: scale_factor <= 853;
        42: scale_factor <= 683;
        43: scale_factor <= 512;
        44: scale_factor <= 341;
        45: scale_factor <= 171;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_8 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        40: scale_factor <= 0;
        41: scale_factor <= 171;
        42: scale_factor <= 341;
        43: scale_factor <= 512;
        44: scale_factor <= 683;
        45: scale_factor <= 853;
        // Falling edge
        46: scale_factor <= 1024;
        47: scale_factor <= 878;
        48: scale_factor <= 731;
        49: scale_factor <= 585;
        50: scale_factor <= 439;
        51: scale_factor <= 293;
        52: scale_factor <= 146;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_9 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        46: scale_factor <= 0;
        47: scale_factor <= 146;
        48: scale_factor <= 293;
        49: scale_factor <= 439;
        50: scale_factor <= 585;
        51: scale_factor <= 731;
        52: scale_factor <= 878;
        // Falling edge
        53: scale_factor <= 1024;
        54: scale_factor <= 878;
        55: scale_factor <= 731;
        56: scale_factor <= 585;
        57: scale_factor <= 439;
        58: scale_factor <= 293;
        59: scale_factor <= 146;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_10 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        53: scale_factor <= 0;
        54: scale_factor <= 146;
        55: scale_factor <= 293;
        56: scale_factor <= 439;
        57: scale_factor <= 585;
        58: scale_factor <= 731;
        59: scale_factor <= 878;
        // Falling edge
        60: scale_factor <= 1024;
        61: scale_factor <= 896;
        62: scale_factor <= 768;
        63: scale_factor <= 640;
        64: scale_factor <= 512;
        65: scale_factor <= 384;
        66: scale_factor <= 256;
        67: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_11 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        60: scale_factor <= 0;
        61: scale_factor <= 128;
        62: scale_factor <= 256;
        63: scale_factor <= 384;
        64: scale_factor <= 512;
        65: scale_factor <= 640;
        66: scale_factor <= 768;
        67: scale_factor <= 896;
        // Falling edge
        68: scale_factor <= 1024;
        69: scale_factor <= 896;
        70: scale_factor <= 768;
        71: scale_factor <= 640;
        72: scale_factor <= 512;
        73: scale_factor <= 384;
        74: scale_factor <= 256;
        75: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_12 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        68: scale_factor <= 0;
        69: scale_factor <= 128;
        70: scale_factor <= 256;
        71: scale_factor <= 384;
        72: scale_factor <= 512;
        73: scale_factor <= 640;
        74: scale_factor <= 768;
        75: scale_factor <= 896;
        // Falling edge
        76: scale_factor <= 1024;
        77: scale_factor <= 896;
        78: scale_factor <= 768;
        79: scale_factor <= 640;
        80: scale_factor <= 512;
        81: scale_factor <= 384;
        82: scale_factor <= 256;
        83: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_13 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        76: scale_factor <= 0;
        77: scale_factor <= 128;
        78: scale_factor <= 256;
        79: scale_factor <= 384;
        80: scale_factor <= 512;
        81: scale_factor <= 640;
        82: scale_factor <= 768;
        83: scale_factor <= 896;
        // Falling edge
        84: scale_factor <= 1024;
        85: scale_factor <= 910;
        86: scale_factor <= 796;
        87: scale_factor <= 683;
        88: scale_factor <= 569;
        89: scale_factor <= 455;
        90: scale_factor <= 341;
        91: scale_factor <= 228;
        92: scale_factor <= 114;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_14 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        84: scale_factor <= 0;
        85: scale_factor <= 114;
        86: scale_factor <= 228;
        87: scale_factor <= 341;
        88: scale_factor <= 455;
        89: scale_factor <= 569;
        90: scale_factor <= 683;
        91: scale_factor <= 796;
        92: scale_factor <= 910;
        // Falling edge
        93: scale_factor <= 1024;
        94: scale_factor <= 922;
        95: scale_factor <= 819;
        96: scale_factor <= 717;
        97: scale_factor <= 614;
        98: scale_factor <= 512;
        99: scale_factor <= 410;
        100: scale_factor <= 307;
        101: scale_factor <= 205;
        102: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_15 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        93: scale_factor <= 0;
        94: scale_factor <= 102;
        95: scale_factor <= 205;
        96: scale_factor <= 307;
        97: scale_factor <= 410;
        98: scale_factor <= 512;
        99: scale_factor <= 614;
        100: scale_factor <= 717;
        101: scale_factor <= 819;
        102: scale_factor <= 922;
        // Falling edge
        103: scale_factor <= 1024;
        104: scale_factor <= 922;
        105: scale_factor <= 819;
        106: scale_factor <= 717;
        107: scale_factor <= 614;
        108: scale_factor <= 512;
        109: scale_factor <= 410;
        110: scale_factor <= 307;
        111: scale_factor <= 205;
        112: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_16 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        103: scale_factor <= 0;
        104: scale_factor <= 102;
        105: scale_factor <= 205;
        106: scale_factor <= 307;
        107: scale_factor <= 410;
        108: scale_factor <= 512;
        109: scale_factor <= 614;
        110: scale_factor <= 717;
        111: scale_factor <= 819;
        112: scale_factor <= 922;
        // Falling edge
        113: scale_factor <= 1024;
        114: scale_factor <= 922;
        115: scale_factor <= 819;
        116: scale_factor <= 717;
        117: scale_factor <= 614;
        118: scale_factor <= 512;
        119: scale_factor <= 410;
        120: scale_factor <= 307;
        121: scale_factor <= 205;
        122: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_17 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        113: scale_factor <= 0;
        114: scale_factor <= 102;
        115: scale_factor <= 205;
        116: scale_factor <= 307;
        117: scale_factor <= 410;
        118: scale_factor <= 512;
        119: scale_factor <= 614;
        120: scale_factor <= 717;
        121: scale_factor <= 819;
        122: scale_factor <= 922;
        // Falling edge
        123: scale_factor <= 1024;
        124: scale_factor <= 939;
        125: scale_factor <= 853;
        126: scale_factor <= 768;
        127: scale_factor <= 683;
        128: scale_factor <= 597;
        129: scale_factor <= 512;
        130: scale_factor <= 427;
        131: scale_factor <= 341;
        132: scale_factor <= 256;
        133: scale_factor <= 171;
        134: scale_factor <= 85;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_18 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        123: scale_factor <= 0;
        124: scale_factor <= 85;
        125: scale_factor <= 171;
        126: scale_factor <= 256;
        127: scale_factor <= 341;
        128: scale_factor <= 427;
        129: scale_factor <= 512;
        130: scale_factor <= 597;
        131: scale_factor <= 683;
        132: scale_factor <= 768;
        133: scale_factor <= 853;
        134: scale_factor <= 939;
        // Falling edge
        135: scale_factor <= 1024;
        136: scale_factor <= 939;
        137: scale_factor <= 853;
        138: scale_factor <= 768;
        139: scale_factor <= 683;
        140: scale_factor <= 597;
        141: scale_factor <= 512;
        142: scale_factor <= 427;
        143: scale_factor <= 341;
        144: scale_factor <= 256;
        145: scale_factor <= 171;
        146: scale_factor <= 85;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_19 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        135: scale_factor <= 0;
        136: scale_factor <= 85;
        137: scale_factor <= 171;
        138: scale_factor <= 256;
        139: scale_factor <= 341;
        140: scale_factor <= 427;
        141: scale_factor <= 512;
        142: scale_factor <= 597;
        143: scale_factor <= 683;
        144: scale_factor <= 768;
        145: scale_factor <= 853;
        146: scale_factor <= 939;
        // Falling edge
        147: scale_factor <= 1024;
        148: scale_factor <= 945;
        149: scale_factor <= 866;
        150: scale_factor <= 788;
        151: scale_factor <= 709;
        152: scale_factor <= 630;
        153: scale_factor <= 551;
        154: scale_factor <= 473;
        155: scale_factor <= 394;
        156: scale_factor <= 315;
        157: scale_factor <= 236;
        158: scale_factor <= 158;
        159: scale_factor <= 79;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_20 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        147: scale_factor <= 0;
        148: scale_factor <= 79;
        149: scale_factor <= 158;
        150: scale_factor <= 236;
        151: scale_factor <= 315;
        152: scale_factor <= 394;
        153: scale_factor <= 473;
        154: scale_factor <= 551;
        155: scale_factor <= 630;
        156: scale_factor <= 709;
        157: scale_factor <= 788;
        158: scale_factor <= 866;
        159: scale_factor <= 945;
        // Falling edge
        160: scale_factor <= 1024;
        161: scale_factor <= 951;
        162: scale_factor <= 878;
        163: scale_factor <= 805;
        164: scale_factor <= 731;
        165: scale_factor <= 658;
        166: scale_factor <= 585;
        167: scale_factor <= 512;
        168: scale_factor <= 439;
        169: scale_factor <= 366;
        170: scale_factor <= 293;
        171: scale_factor <= 219;
        172: scale_factor <= 146;
        173: scale_factor <= 73;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_21 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        160: scale_factor <= 0;
        161: scale_factor <= 73;
        162: scale_factor <= 146;
        163: scale_factor <= 219;
        164: scale_factor <= 293;
        165: scale_factor <= 366;
        166: scale_factor <= 439;
        167: scale_factor <= 512;
        168: scale_factor <= 585;
        169: scale_factor <= 658;
        170: scale_factor <= 731;
        171: scale_factor <= 805;
        172: scale_factor <= 878;
        173: scale_factor <= 951;
        // Falling edge
        174: scale_factor <= 1024;
        175: scale_factor <= 951;
        176: scale_factor <= 878;
        177: scale_factor <= 805;
        178: scale_factor <= 731;
        179: scale_factor <= 658;
        180: scale_factor <= 585;
        181: scale_factor <= 512;
        182: scale_factor <= 439;
        183: scale_factor <= 366;
        184: scale_factor <= 293;
        185: scale_factor <= 219;
        186: scale_factor <= 146;
        187: scale_factor <= 73;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_22 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        174: scale_factor <= 0;
        175: scale_factor <= 73;
        176: scale_factor <= 146;
        177: scale_factor <= 219;
        178: scale_factor <= 293;
        179: scale_factor <= 366;
        180: scale_factor <= 439;
        181: scale_factor <= 512;
        182: scale_factor <= 585;
        183: scale_factor <= 658;
        184: scale_factor <= 731;
        185: scale_factor <= 805;
        186: scale_factor <= 878;
        187: scale_factor <= 951;
        // Falling edge
        188: scale_factor <= 1024;
        189: scale_factor <= 960;
        190: scale_factor <= 896;
        191: scale_factor <= 832;
        192: scale_factor <= 768;
        193: scale_factor <= 704;
        194: scale_factor <= 640;
        195: scale_factor <= 576;
        196: scale_factor <= 512;
        197: scale_factor <= 448;
        198: scale_factor <= 384;
        199: scale_factor <= 320;
        200: scale_factor <= 256;
        201: scale_factor <= 192;
        202: scale_factor <= 128;
        203: scale_factor <= 64;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_23 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        188: scale_factor <= 0;
        189: scale_factor <= 64;
        190: scale_factor <= 128;
        191: scale_factor <= 192;
        192: scale_factor <= 256;
        193: scale_factor <= 320;
        194: scale_factor <= 384;
        195: scale_factor <= 448;
        196: scale_factor <= 512;
        197: scale_factor <= 576;
        198: scale_factor <= 640;
        199: scale_factor <= 704;
        200: scale_factor <= 768;
        201: scale_factor <= 832;
        202: scale_factor <= 896;
        203: scale_factor <= 960;
        // Falling edge
        204: scale_factor <= 1024;
        205: scale_factor <= 960;
        206: scale_factor <= 896;
        207: scale_factor <= 832;
        208: scale_factor <= 768;
        209: scale_factor <= 704;
        210: scale_factor <= 640;
        211: scale_factor <= 576;
        212: scale_factor <= 512;
        213: scale_factor <= 448;
        214: scale_factor <= 384;
        215: scale_factor <= 320;
        216: scale_factor <= 256;
        217: scale_factor <= 192;
        218: scale_factor <= 128;
        219: scale_factor <= 64;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_24 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        204: scale_factor <= 0;
        205: scale_factor <= 64;
        206: scale_factor <= 128;
        207: scale_factor <= 192;
        208: scale_factor <= 256;
        209: scale_factor <= 320;
        210: scale_factor <= 384;
        211: scale_factor <= 448;
        212: scale_factor <= 512;
        213: scale_factor <= 576;
        214: scale_factor <= 640;
        215: scale_factor <= 704;
        216: scale_factor <= 768;
        217: scale_factor <= 832;
        218: scale_factor <= 896;
        219: scale_factor <= 960;
        // Falling edge
        220: scale_factor <= 1024;
        221: scale_factor <= 967;
        222: scale_factor <= 910;
        223: scale_factor <= 853;
        224: scale_factor <= 796;
        225: scale_factor <= 740;
        226: scale_factor <= 683;
        227: scale_factor <= 626;
        228: scale_factor <= 569;
        229: scale_factor <= 512;
        230: scale_factor <= 455;
        231: scale_factor <= 398;
        232: scale_factor <= 341;
        233: scale_factor <= 284;
        234: scale_factor <= 228;
        235: scale_factor <= 171;
        236: scale_factor <= 114;
        237: scale_factor <= 57;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_25 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        220: scale_factor <= 0;
        221: scale_factor <= 57;
        222: scale_factor <= 114;
        223: scale_factor <= 171;
        224: scale_factor <= 228;
        225: scale_factor <= 284;
        226: scale_factor <= 341;
        227: scale_factor <= 398;
        228: scale_factor <= 455;
        229: scale_factor <= 512;
        230: scale_factor <= 569;
        231: scale_factor <= 626;
        232: scale_factor <= 683;
        233: scale_factor <= 740;
        234: scale_factor <= 796;
        235: scale_factor <= 853;
        236: scale_factor <= 910;
        237: scale_factor <= 967;
        // Falling edge
        238: scale_factor <= 1024;
        239: scale_factor <= 967;
        240: scale_factor <= 910;
        241: scale_factor <= 853;
        242: scale_factor <= 796;
        243: scale_factor <= 740;
        244: scale_factor <= 683;
        245: scale_factor <= 626;
        246: scale_factor <= 569;
        247: scale_factor <= 512;
        248: scale_factor <= 455;
        249: scale_factor <= 398;
        250: scale_factor <= 341;
        251: scale_factor <= 284;
        252: scale_factor <= 228;
        253: scale_factor <= 171;
        254: scale_factor <= 114;
        255: scale_factor <= 57;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


`default_nettype wire
