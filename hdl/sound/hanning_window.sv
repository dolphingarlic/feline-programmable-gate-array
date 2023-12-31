
///////////////////////////////
//    AUTO-GENERATED FILE    //
// ------------------------- //
// N_FFT = 512               //
///////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module hanning_window #(
    SAMPLES = 512,
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
                        0: scale_factor = 16'd0;
            1: scale_factor = 16'd1;
            2: scale_factor = 16'd2;
            3: scale_factor = 16'd6;
            4: scale_factor = 16'd10;
            5: scale_factor = 16'd15;
            6: scale_factor = 16'd22;
            7: scale_factor = 16'd30;
            8: scale_factor = 16'd40;
            9: scale_factor = 16'd50;
            10: scale_factor = 16'd62;
            11: scale_factor = 16'd75;
            12: scale_factor = 16'd89;
            13: scale_factor = 16'd104;
            14: scale_factor = 16'd121;
            15: scale_factor = 16'd139;
            16: scale_factor = 16'd158;
            17: scale_factor = 16'd178;
            18: scale_factor = 16'd200;
            19: scale_factor = 16'd223;
            20: scale_factor = 16'd246;
            21: scale_factor = 16'd272;
            22: scale_factor = 16'd298;
            23: scale_factor = 16'd325;
            24: scale_factor = 16'd354;
            25: scale_factor = 16'd384;
            26: scale_factor = 16'd415;
            27: scale_factor = 16'd447;
            28: scale_factor = 16'd481;
            29: scale_factor = 16'd515;
            30: scale_factor = 16'd551;
            31: scale_factor = 16'd588;
            32: scale_factor = 16'd626;
            33: scale_factor = 16'd665;
            34: scale_factor = 16'd706;
            35: scale_factor = 16'd747;
            36: scale_factor = 16'd790;
            37: scale_factor = 16'd833;
            38: scale_factor = 16'd878;
            39: scale_factor = 16'd924;
            40: scale_factor = 16'd971;
            41: scale_factor = 16'd1019;
            42: scale_factor = 16'd1068;
            43: scale_factor = 16'd1119;
            44: scale_factor = 16'd1170;
            45: scale_factor = 16'd1222;
            46: scale_factor = 16'd1276;
            47: scale_factor = 16'd1330;
            48: scale_factor = 16'd1386;
            49: scale_factor = 16'd1442;
            50: scale_factor = 16'd1500;
            51: scale_factor = 16'd1559;
            52: scale_factor = 16'd1618;
            53: scale_factor = 16'd1679;
            54: scale_factor = 16'd1740;
            55: scale_factor = 16'd1803;
            56: scale_factor = 16'd1866;
            57: scale_factor = 16'd1931;
            58: scale_factor = 16'd1996;
            59: scale_factor = 16'd2063;
            60: scale_factor = 16'd2130;
            61: scale_factor = 16'd2198;
            62: scale_factor = 16'd2267;
            63: scale_factor = 16'd2337;
            64: scale_factor = 16'd2408;
            65: scale_factor = 16'd2480;
            66: scale_factor = 16'd2553;
            67: scale_factor = 16'd2626;
            68: scale_factor = 16'd2701;
            69: scale_factor = 16'd2776;
            70: scale_factor = 16'd2852;
            71: scale_factor = 16'd2928;
            72: scale_factor = 16'd3006;
            73: scale_factor = 16'd3084;
            74: scale_factor = 16'd3164;
            75: scale_factor = 16'd3243;
            76: scale_factor = 16'd3324;
            77: scale_factor = 16'd3405;
            78: scale_factor = 16'd3488;
            79: scale_factor = 16'd3570;
            80: scale_factor = 16'd3654;
            81: scale_factor = 16'd3738;
            82: scale_factor = 16'd3823;
            83: scale_factor = 16'd3908;
            84: scale_factor = 16'd3995;
            85: scale_factor = 16'd4081;
            86: scale_factor = 16'd4169;
            87: scale_factor = 16'd4257;
            88: scale_factor = 16'd4346;
            89: scale_factor = 16'd4435;
            90: scale_factor = 16'd4525;
            91: scale_factor = 16'd4615;
            92: scale_factor = 16'd4706;
            93: scale_factor = 16'd4797;
            94: scale_factor = 16'd4889;
            95: scale_factor = 16'd4982;
            96: scale_factor = 16'd5075;
            97: scale_factor = 16'd5168;
            98: scale_factor = 16'd5262;
            99: scale_factor = 16'd5356;
            100: scale_factor = 16'd5451;
            101: scale_factor = 16'd5546;
            102: scale_factor = 16'd5641;
            103: scale_factor = 16'd5737;
            104: scale_factor = 16'd5834;
            105: scale_factor = 16'd5930;
            106: scale_factor = 16'd6027;
            107: scale_factor = 16'd6125;
            108: scale_factor = 16'd6222;
            109: scale_factor = 16'd6320;
            110: scale_factor = 16'd6418;
            111: scale_factor = 16'd6517;
            112: scale_factor = 16'd6615;
            113: scale_factor = 16'd6714;
            114: scale_factor = 16'd6814;
            115: scale_factor = 16'd6913;
            116: scale_factor = 16'd7013;
            117: scale_factor = 16'd7112;
            118: scale_factor = 16'd7212;
            119: scale_factor = 16'd7312;
            120: scale_factor = 16'd7413;
            121: scale_factor = 16'd7513;
            122: scale_factor = 16'd7613;
            123: scale_factor = 16'd7714;
            124: scale_factor = 16'd7814;
            125: scale_factor = 16'd7915;
            126: scale_factor = 16'd8016;
            127: scale_factor = 16'd8116;
            128: scale_factor = 16'd8217;
            129: scale_factor = 16'd8318;
            130: scale_factor = 16'd8419;
            131: scale_factor = 16'd8519;
            132: scale_factor = 16'd8620;
            133: scale_factor = 16'd8720;
            134: scale_factor = 16'd8821;
            135: scale_factor = 16'd8921;
            136: scale_factor = 16'd9022;
            137: scale_factor = 16'd9122;
            138: scale_factor = 16'd9222;
            139: scale_factor = 16'd9322;
            140: scale_factor = 16'd9421;
            141: scale_factor = 16'd9521;
            142: scale_factor = 16'd9620;
            143: scale_factor = 16'd9719;
            144: scale_factor = 16'd9818;
            145: scale_factor = 16'd9917;
            146: scale_factor = 16'd10015;
            147: scale_factor = 16'd10113;
            148: scale_factor = 16'd10211;
            149: scale_factor = 16'd10308;
            150: scale_factor = 16'd10405;
            151: scale_factor = 16'd10502;
            152: scale_factor = 16'd10599;
            153: scale_factor = 16'd10695;
            154: scale_factor = 16'd10790;
            155: scale_factor = 16'd10886;
            156: scale_factor = 16'd10981;
            157: scale_factor = 16'd11075;
            158: scale_factor = 16'd11169;
            159: scale_factor = 16'd11263;
            160: scale_factor = 16'd11356;
            161: scale_factor = 16'd11449;
            162: scale_factor = 16'd11541;
            163: scale_factor = 16'd11633;
            164: scale_factor = 16'd11724;
            165: scale_factor = 16'd11814;
            166: scale_factor = 16'd11904;
            167: scale_factor = 16'd11994;
            168: scale_factor = 16'd12083;
            169: scale_factor = 16'd12171;
            170: scale_factor = 16'd12259;
            171: scale_factor = 16'd12346;
            172: scale_factor = 16'd12433;
            173: scale_factor = 16'd12518;
            174: scale_factor = 16'd12604;
            175: scale_factor = 16'd12688;
            176: scale_factor = 16'd12772;
            177: scale_factor = 16'd12855;
            178: scale_factor = 16'd12938;
            179: scale_factor = 16'd13019;
            180: scale_factor = 16'd13100;
            181: scale_factor = 16'd13181;
            182: scale_factor = 16'd13260;
            183: scale_factor = 16'd13339;
            184: scale_factor = 16'd13417;
            185: scale_factor = 16'd13494;
            186: scale_factor = 16'd13570;
            187: scale_factor = 16'd13646;
            188: scale_factor = 16'd13721;
            189: scale_factor = 16'd13795;
            190: scale_factor = 16'd13868;
            191: scale_factor = 16'd13940;
            192: scale_factor = 16'd14011;
            193: scale_factor = 16'd14082;
            194: scale_factor = 16'd14151;
            195: scale_factor = 16'd14220;
            196: scale_factor = 16'd14288;
            197: scale_factor = 16'd14355;
            198: scale_factor = 16'd14420;
            199: scale_factor = 16'd14485;
            200: scale_factor = 16'd14549;
            201: scale_factor = 16'd14612;
            202: scale_factor = 16'd14675;
            203: scale_factor = 16'd14736;
            204: scale_factor = 16'd14796;
            205: scale_factor = 16'd14855;
            206: scale_factor = 16'd14913;
            207: scale_factor = 16'd14970;
            208: scale_factor = 16'd15026;
            209: scale_factor = 16'd15081;
            210: scale_factor = 16'd15135;
            211: scale_factor = 16'd15188;
            212: scale_factor = 16'd15240;
            213: scale_factor = 16'd15291;
            214: scale_factor = 16'd15340;
            215: scale_factor = 16'd15389;
            216: scale_factor = 16'd15437;
            217: scale_factor = 16'd15483;
            218: scale_factor = 16'd15528;
            219: scale_factor = 16'd15573;
            220: scale_factor = 16'd15616;
            221: scale_factor = 16'd15658;
            222: scale_factor = 16'd15699;
            223: scale_factor = 16'd15739;
            224: scale_factor = 16'd15777;
            225: scale_factor = 16'd15815;
            226: scale_factor = 16'd15851;
            227: scale_factor = 16'd15886;
            228: scale_factor = 16'd15920;
            229: scale_factor = 16'd15953;
            230: scale_factor = 16'd15985;
            231: scale_factor = 16'd16015;
            232: scale_factor = 16'd16044;
            233: scale_factor = 16'd16072;
            234: scale_factor = 16'd16099;
            235: scale_factor = 16'd16125;
            236: scale_factor = 16'd16150;
            237: scale_factor = 16'd16173;
            238: scale_factor = 16'd16195;
            239: scale_factor = 16'd16216;
            240: scale_factor = 16'd16236;
            241: scale_factor = 16'd16254;
            242: scale_factor = 16'd16271;
            243: scale_factor = 16'd16287;
            244: scale_factor = 16'd16302;
            245: scale_factor = 16'd16316;
            246: scale_factor = 16'd16328;
            247: scale_factor = 16'd16339;
            248: scale_factor = 16'd16349;
            249: scale_factor = 16'd16358;
            250: scale_factor = 16'd16365;
            251: scale_factor = 16'd16371;
            252: scale_factor = 16'd16376;
            253: scale_factor = 16'd16380;
            254: scale_factor = 16'd16383;
            255: scale_factor = 16'd16384;
            256: scale_factor = 16'd16384;
            257: scale_factor = 16'd16383;
            258: scale_factor = 16'd16380;
            259: scale_factor = 16'd16376;
            260: scale_factor = 16'd16371;
            261: scale_factor = 16'd16365;
            262: scale_factor = 16'd16358;
            263: scale_factor = 16'd16349;
            264: scale_factor = 16'd16339;
            265: scale_factor = 16'd16328;
            266: scale_factor = 16'd16316;
            267: scale_factor = 16'd16302;
            268: scale_factor = 16'd16287;
            269: scale_factor = 16'd16271;
            270: scale_factor = 16'd16254;
            271: scale_factor = 16'd16236;
            272: scale_factor = 16'd16216;
            273: scale_factor = 16'd16195;
            274: scale_factor = 16'd16173;
            275: scale_factor = 16'd16150;
            276: scale_factor = 16'd16125;
            277: scale_factor = 16'd16099;
            278: scale_factor = 16'd16072;
            279: scale_factor = 16'd16044;
            280: scale_factor = 16'd16015;
            281: scale_factor = 16'd15985;
            282: scale_factor = 16'd15953;
            283: scale_factor = 16'd15920;
            284: scale_factor = 16'd15886;
            285: scale_factor = 16'd15851;
            286: scale_factor = 16'd15815;
            287: scale_factor = 16'd15777;
            288: scale_factor = 16'd15739;
            289: scale_factor = 16'd15699;
            290: scale_factor = 16'd15658;
            291: scale_factor = 16'd15616;
            292: scale_factor = 16'd15573;
            293: scale_factor = 16'd15528;
            294: scale_factor = 16'd15483;
            295: scale_factor = 16'd15437;
            296: scale_factor = 16'd15389;
            297: scale_factor = 16'd15340;
            298: scale_factor = 16'd15291;
            299: scale_factor = 16'd15240;
            300: scale_factor = 16'd15188;
            301: scale_factor = 16'd15135;
            302: scale_factor = 16'd15081;
            303: scale_factor = 16'd15026;
            304: scale_factor = 16'd14970;
            305: scale_factor = 16'd14913;
            306: scale_factor = 16'd14855;
            307: scale_factor = 16'd14796;
            308: scale_factor = 16'd14736;
            309: scale_factor = 16'd14675;
            310: scale_factor = 16'd14612;
            311: scale_factor = 16'd14549;
            312: scale_factor = 16'd14485;
            313: scale_factor = 16'd14420;
            314: scale_factor = 16'd14355;
            315: scale_factor = 16'd14288;
            316: scale_factor = 16'd14220;
            317: scale_factor = 16'd14151;
            318: scale_factor = 16'd14082;
            319: scale_factor = 16'd14011;
            320: scale_factor = 16'd13940;
            321: scale_factor = 16'd13868;
            322: scale_factor = 16'd13795;
            323: scale_factor = 16'd13721;
            324: scale_factor = 16'd13646;
            325: scale_factor = 16'd13570;
            326: scale_factor = 16'd13494;
            327: scale_factor = 16'd13417;
            328: scale_factor = 16'd13339;
            329: scale_factor = 16'd13260;
            330: scale_factor = 16'd13181;
            331: scale_factor = 16'd13100;
            332: scale_factor = 16'd13019;
            333: scale_factor = 16'd12938;
            334: scale_factor = 16'd12855;
            335: scale_factor = 16'd12772;
            336: scale_factor = 16'd12688;
            337: scale_factor = 16'd12604;
            338: scale_factor = 16'd12518;
            339: scale_factor = 16'd12433;
            340: scale_factor = 16'd12346;
            341: scale_factor = 16'd12259;
            342: scale_factor = 16'd12171;
            343: scale_factor = 16'd12083;
            344: scale_factor = 16'd11994;
            345: scale_factor = 16'd11904;
            346: scale_factor = 16'd11814;
            347: scale_factor = 16'd11724;
            348: scale_factor = 16'd11633;
            349: scale_factor = 16'd11541;
            350: scale_factor = 16'd11449;
            351: scale_factor = 16'd11356;
            352: scale_factor = 16'd11263;
            353: scale_factor = 16'd11169;
            354: scale_factor = 16'd11075;
            355: scale_factor = 16'd10981;
            356: scale_factor = 16'd10886;
            357: scale_factor = 16'd10790;
            358: scale_factor = 16'd10695;
            359: scale_factor = 16'd10599;
            360: scale_factor = 16'd10502;
            361: scale_factor = 16'd10405;
            362: scale_factor = 16'd10308;
            363: scale_factor = 16'd10211;
            364: scale_factor = 16'd10113;
            365: scale_factor = 16'd10015;
            366: scale_factor = 16'd9917;
            367: scale_factor = 16'd9818;
            368: scale_factor = 16'd9719;
            369: scale_factor = 16'd9620;
            370: scale_factor = 16'd9521;
            371: scale_factor = 16'd9421;
            372: scale_factor = 16'd9322;
            373: scale_factor = 16'd9222;
            374: scale_factor = 16'd9122;
            375: scale_factor = 16'd9022;
            376: scale_factor = 16'd8921;
            377: scale_factor = 16'd8821;
            378: scale_factor = 16'd8720;
            379: scale_factor = 16'd8620;
            380: scale_factor = 16'd8519;
            381: scale_factor = 16'd8419;
            382: scale_factor = 16'd8318;
            383: scale_factor = 16'd8217;
            384: scale_factor = 16'd8116;
            385: scale_factor = 16'd8016;
            386: scale_factor = 16'd7915;
            387: scale_factor = 16'd7814;
            388: scale_factor = 16'd7714;
            389: scale_factor = 16'd7613;
            390: scale_factor = 16'd7513;
            391: scale_factor = 16'd7413;
            392: scale_factor = 16'd7312;
            393: scale_factor = 16'd7212;
            394: scale_factor = 16'd7112;
            395: scale_factor = 16'd7013;
            396: scale_factor = 16'd6913;
            397: scale_factor = 16'd6814;
            398: scale_factor = 16'd6714;
            399: scale_factor = 16'd6615;
            400: scale_factor = 16'd6517;
            401: scale_factor = 16'd6418;
            402: scale_factor = 16'd6320;
            403: scale_factor = 16'd6222;
            404: scale_factor = 16'd6125;
            405: scale_factor = 16'd6027;
            406: scale_factor = 16'd5930;
            407: scale_factor = 16'd5834;
            408: scale_factor = 16'd5737;
            409: scale_factor = 16'd5641;
            410: scale_factor = 16'd5546;
            411: scale_factor = 16'd5451;
            412: scale_factor = 16'd5356;
            413: scale_factor = 16'd5262;
            414: scale_factor = 16'd5168;
            415: scale_factor = 16'd5075;
            416: scale_factor = 16'd4982;
            417: scale_factor = 16'd4889;
            418: scale_factor = 16'd4797;
            419: scale_factor = 16'd4706;
            420: scale_factor = 16'd4615;
            421: scale_factor = 16'd4525;
            422: scale_factor = 16'd4435;
            423: scale_factor = 16'd4346;
            424: scale_factor = 16'd4257;
            425: scale_factor = 16'd4169;
            426: scale_factor = 16'd4081;
            427: scale_factor = 16'd3995;
            428: scale_factor = 16'd3908;
            429: scale_factor = 16'd3823;
            430: scale_factor = 16'd3738;
            431: scale_factor = 16'd3654;
            432: scale_factor = 16'd3570;
            433: scale_factor = 16'd3488;
            434: scale_factor = 16'd3405;
            435: scale_factor = 16'd3324;
            436: scale_factor = 16'd3243;
            437: scale_factor = 16'd3164;
            438: scale_factor = 16'd3084;
            439: scale_factor = 16'd3006;
            440: scale_factor = 16'd2928;
            441: scale_factor = 16'd2852;
            442: scale_factor = 16'd2776;
            443: scale_factor = 16'd2701;
            444: scale_factor = 16'd2626;
            445: scale_factor = 16'd2553;
            446: scale_factor = 16'd2480;
            447: scale_factor = 16'd2408;
            448: scale_factor = 16'd2337;
            449: scale_factor = 16'd2267;
            450: scale_factor = 16'd2198;
            451: scale_factor = 16'd2130;
            452: scale_factor = 16'd2063;
            453: scale_factor = 16'd1996;
            454: scale_factor = 16'd1931;
            455: scale_factor = 16'd1866;
            456: scale_factor = 16'd1803;
            457: scale_factor = 16'd1740;
            458: scale_factor = 16'd1679;
            459: scale_factor = 16'd1618;
            460: scale_factor = 16'd1559;
            461: scale_factor = 16'd1500;
            462: scale_factor = 16'd1442;
            463: scale_factor = 16'd1386;
            464: scale_factor = 16'd1330;
            465: scale_factor = 16'd1276;
            466: scale_factor = 16'd1222;
            467: scale_factor = 16'd1170;
            468: scale_factor = 16'd1119;
            469: scale_factor = 16'd1068;
            470: scale_factor = 16'd1019;
            471: scale_factor = 16'd971;
            472: scale_factor = 16'd924;
            473: scale_factor = 16'd878;
            474: scale_factor = 16'd833;
            475: scale_factor = 16'd790;
            476: scale_factor = 16'd747;
            477: scale_factor = 16'd706;
            478: scale_factor = 16'd665;
            479: scale_factor = 16'd626;
            480: scale_factor = 16'd588;
            481: scale_factor = 16'd551;
            482: scale_factor = 16'd515;
            483: scale_factor = 16'd481;
            484: scale_factor = 16'd447;
            485: scale_factor = 16'd415;
            486: scale_factor = 16'd384;
            487: scale_factor = 16'd354;
            488: scale_factor = 16'd325;
            489: scale_factor = 16'd298;
            490: scale_factor = 16'd272;
            491: scale_factor = 16'd246;
            492: scale_factor = 16'd223;
            493: scale_factor = 16'd200;
            494: scale_factor = 16'd178;
            495: scale_factor = 16'd158;
            496: scale_factor = 16'd139;
            497: scale_factor = 16'd121;
            498: scale_factor = 16'd104;
            499: scale_factor = 16'd89;
            500: scale_factor = 16'd75;
            501: scale_factor = 16'd62;
            502: scale_factor = 16'd50;
            503: scale_factor = 16'd40;
            504: scale_factor = 16'd30;
            505: scale_factor = 16'd22;
            506: scale_factor = 16'd15;
            507: scale_factor = 16'd10;
            508: scale_factor = 16'd6;
            509: scale_factor = 16'd2;
            510: scale_factor = 16'd1;
            511: scale_factor = 16'd0;

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
