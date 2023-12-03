import time
from manta import Manta
import matplotlib.pyplot as plt
import struct
import math

m = Manta("audio.yaml")  # create manta python instance using yaml


def binary_to_fixed_point(binary):
    result = binary
    if result & (
        1 << 15
    ):  # Check the sign bit (15th bit for a 16-bit two's complement)
        result -= 1 << 16
    return result / (2**13)


while True:
    # x_dir = m.io_core.x_dir.get() # read in the output from our divider
    # y_dir = m.io_core.y_dir.get() # read in the output from our divider
    # print((x_dir, y_dir))
    # angle = m.io_core.angle.get() # read in the output from our divider
    # binary = bin(angle)
    # fixed_point_angle = binary_to_fixed_point(angle)
    # print(math.degrees(fixed_point_angle))

    polar_0 = m.io_core.polar_0.get()
    polar_1 = m.io_core.polar_1.get()
    polar_2 = m.io_core.polar_2.get()
    polar_3 = m.io_core.polar_3.get()

    polars = [polar_0, polar_1, polar_2, polar_3]

    for i, polar in enumerate(polars):
        phase = (polar & 0xFFFFFFFF) >> 16
        fixed_point_angle = binary_to_fixed_point(phase)
        print((i, fixed_point_angle))

    # x_dir = m.io_core.x_dir.get() # read in the output from our divider
    # y_dir = m.io_core.y_dir.get() # read in the output from our divider
    # print((x_dir, y_dir))


# binary_number = 0b0110011010111000
# fixed_point_result = binary_to_fixed_point(binary_number)
# print(fixed_point_result)
