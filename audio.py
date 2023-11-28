import time
from manta import Manta
import matplotlib.pyplot as plt
import struct
m = Manta('audio.yaml') # create manta python instance using yaml

ws = m.io_core.ws.get() # read in the output from our divider

# b = m.lab8_io_core.val2_in.get() # read in the output from our divider

data = []

while len(data) < 200:
    # print(len(data))
    audio_data = m.io_core.audio_data.get() # read in the output from our divider
    data.append(audio_data)

data = [struct.unpack('h', struct.pack('H', i))[0] for i in data]

plt.plot(data)
plt.show()

