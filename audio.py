import time
from manta import Manta
import matplotlib.pyplot as plt
import struct
import math

m = Manta("audio.yaml")  # create manta python instance using yaml


def binary_to_fixed_point(binary, n_bits=16, frac_index=3):
    result = binary
    if result & (1 << (n_bits - 1)):
        result -= 1 << n_bits
    return result / (2 ** (n_bits - frac_index))


#  polar_0 = m.io_core.polar_0.get()
#     polar_1 = m.io_core.polar_1.get()
#     polar_2 = m.io_core.polar_2.get()
#     polar_3 = m.io_core.polar_3.get()

#     polars = [polar_0, polar_1, polar_2, polar_3]

#     for i, polar in enumerate(polars):
#         phase = (polar & 0xFFFFFFFF) >> 16
#         fixed_point_angle = binary_to_fixed_point(phase)
#         print((i, fixed_point_angle))

val_store = [0, 0, 0, 0, 0, 0]
# count = 0

while True:
    # x_dir = m.io_core.x_dir.get() # read in the output from our divider
    # y_dir = m.io_core.y_dir.get() # read in the output from our divider
    # print((x_dir, y_dir))
    # angle = m.io_core.angle.get()  # read in the output from our divider
    # binary = bin(angle)
    # fixed_point_angle = binary_to_fixed_point(angle)
    # print(math.degrees(fixed_point_angle))

    # direction_x = m.io_core.direction_x.get()
    # direction_y = m.io_core.direction_y.get()

    # Calculate angle
    # angle = math.atan2(direction_y, direction_x)

    # print(math.degrees(angle))

    # mag_bin_0 = m.io_core.mag_bin_0.get()
    # mag_bin_1 = m.io_core.mag_bin_1.get()
    # mag_bin_2 = m.io_core.mag_bin_2.get()
    # mag_bin_3 = m.io_core.mag_bin_3.get()
    # mag_bin_4 = m.io_core.mag_bin_4.get()
    # mag_bin_5 = m.io_core.mag_bin_5.get()
    # mag_bin_6 = m.io_core.mag_bin_6.get()
    # mag_bin_7 = m.io_core.mag_bin_7.get()
    # mag_bin_8 = m.io_core.mag_bin_8.get()
    # mag_bin_9 = m.io_core.mag_bin_9.get()
    # mag_bin_10 = m.io_core.mag_bin_10.get()
    # mag_bin_11 = m.io_core.mag_bin_11.get()
    # mag_bin_12 = m.io_core.mag_bin_12.get()
    # mag_bin_13 = m.io_core.mag_bin_13.get()
    # mag_bin_14 = m.io_core.mag_bin_14.get()
    # mag_bin_15 = m.io_core.mag_bin_15.get()

    # vals = [
    #     mag_bin_0,
    #     mag_bin_1,
    #     mag_bin_2,
    #     mag_bin_3,
    #     mag_bin_4,
    #     mag_bin_5,
    #     mag_bin_6,
    #     mag_bin_7,
    #     mag_bin_8,
    #     mag_bin_9,
    #     mag_bin_10,
    #     mag_bin_11,
    #     mag_bin_12,
    #     mag_bin_13,
    #     mag_bin_14,
    #     mag_bin_15,
    # ]

    # audio_bin = m.io_core.bin.get()
    mag = m.io_core.mag.get()

    # print((audio_bin, mag))

    servo_bin = m.io_core.servo_bin.get()
    # bin_stored_0 = m.io_core.bin_stored_0.get()
    # bin_stored_1 = m.io_core.bin_stored_1.get()

    print((servo_bin, mag))

    # counter = m.io_core.bin_count.get()

    # print(counter)

    # print(audio_bin)

    # val_store.pop(0)
    # val_store.append(audio_bin)

    # if val_store[0] == val_store[1] == val_store[2] == val_store[3] == val_store[4] == val_store[5]:
    #     print(val_store[0])

# direction_x = m.io_core.direction_x.get()
# direction_y = m.io_core.direction_y.get()

# print(
#     (
#         binary_to_fixed_point(direction_x, 16, 6),
#         binary_to_fixed_point(direction_y, 16, 6),
#     )
# )

# print(vals)

# i = vals.index(max(vals))

# last.append(i)
# last.pop(0)

# if last[0] == last[1] == last[2]:
#     print(last[0])

# print(i)

# print(vals)

# print([binary_to_fixed_point(val, 24, 10) for val in vals])

# magnitude_stored = m.io_core.magnitude_stored.get()

# print((mag_bin_0, mag_bin_1, mag_bin_2, mag_bin_3))

# fft_counter = m.io_core.fft_counter.get()
# aggregator_ready = m.io_core.aggregator_ready.get()
# translate_ready = m.io_core.translate_ready.get()
# print(mag_bin_0, fft_counter, aggregator_ready, translate_ready)
# print(magnitude_stored)
# print(mag_bin_0)

# print(aggregator_counter)

# print((bin(direction_x), bin(direction_y)))

# mic_1_phase = m.io_core.mic_1_phase.get()
# mic_2_phase = m.io_core.mic_2_phase.get()
# mic_3_phase = m.io_core.mic_3_phase.get()
# mic_4_phase = m.io_core.mic_4_phase.get()

# phases = [mic_1_phase, mic_2_phase, mic_3_phase, mic_4_phase]

# print("--PHASES:---")

# for phase in phases:
#     fixed_point_angle = binary_to_fixed_point(phase)
#     print(math.degrees(fixed_point_angle))

# print("-----------")

# mic_1_mag = m.io_core.mic_1_mag.get()
# mic_2_mag = m.io_core.mic_2_mag.get()
# mic_3_mag = m.io_core.mic_3_mag.get()
# mic_4_mag = m.io_core.mic_4_mag.get()

# mags = [mic_1_mag, mic_2_mag, mic_3_mag, mic_4_mag]

# print("--MAGNITUDES:---")

# for mag in mags:
#     print(binary_to_fixed_point(mag, 2))

# print("-----------")

# until_last_fft = m.io_core.until_last_fft.get()
# translate_counter = m.io_core.translate_counter.get()
# print(translate_counter)

# fft_counter = m.io_core.fft_counter.get()
# print(fft_counter)

# x_dir = m.io_core.x_dir.get() # read in the output from our divider
# y_dir = m.io_core.y_dir.get() # read in the output from our divider
# print((x_dir, y_dir))


# binary_number = 0b0110011010111000
# fixed_point_result = binary_to_fixed_point(binary_number)
# print(fixed_point_result)


# addrs = list(range(0, 1))
# # datas = list(range(1234, 2468))
# # m.my_block_memory.write(addrs, datas)
# print("Reading...")
# foo = m.my_block_memory.read(addrs)
# print(foo)

# addrs = list(range(0, 512))
# # m.my_block_memory.write(addrs, addrs)

# # print("Wrote")

# # foo = m.my_block_memory.read([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
# # print(foo)

# for i in range(180):
#     val = m.my_block_memory.read([i])[0]

#     # print(val)
#     print(binary_to_fixed_point(val))
