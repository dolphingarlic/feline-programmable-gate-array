from scipy.io import wavfile
import scipy.signal as sps
import numpy as np

import matplotlib.pyplot as plt

new_rate = 12000 # 12kHz

sampling_rate, data = wavfile.read('sw/data/meow.wav')
downsampled = np.trim_zeros(np.round(sps.decimate(data, round(sampling_rate / new_rate))))

with open(f'data/meow.mem', 'w') as f:
    f.write('0000\n')
    f.write('\n'.join([f'{(int(i) & 0xFFFF):04x}' for i in downsampled]))
