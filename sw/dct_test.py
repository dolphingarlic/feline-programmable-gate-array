from scipy import fft
import numpy as np
from matplotlib import pyplot as plt

np.set_printoptions(precision=3, linewidth=np.inf)

n = 26

for _ in range(5):
    # Simulate a mel filtered result
    x = 36 * np.random.rand(n) - 16
    print('INPUT:')
    print(x)
    print('-----')

    # Reference solution
    print('REFERENCE:')
    dct = fft.dct(x)[:13]
    plt.plot(np.linspace(0, 1, 13), dct, label='Reference DCT')
    print(dct)
    print('-----')

    # Append zeroes to input
    y = np.append(x, np.zeros(6))
    u = np.zeros(4 * (n + 6))
    u[1:2*(n+6):2] = y
    u[2*(n+6)+1::2] = y[::-1]
    print('ZERO APPENDED:')
    fft_append = fft.fft(u)[:16].real
    plt.plot(np.linspace(0, 1, 16), fft_append, label='Zero padded')
    print(fft_append)
    print('-----')

    plt.legend(loc="upper left")
    plt.show()
