import asyncio
import sys
from itertools import count, takewhile
from typing import Iterator
import csv

from bleak import BleakClient, BleakScanner
from bleak.backends.characteristic import BleakGATTCharacteristic
from bleak.backends.device import BLEDevice
from bleak.backends.scanner import AdvertisementData
import matplotlib.pyplot as plt
import numpy as np

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

N_FEATURES = 32

feature_buffer = b""
features = []


# TIP: you can get this function and more from the ``more-itertools`` package.
def sliced(data: bytes, n: int) -> Iterator[bytes]:
    """
    Slices *data* into chunks of size *n*. The last slice may be smaller than
    *n*.
    """
    return takewhile(len, (data[i : i + n] for i in count(0, n)))


async def uart_terminal():
    """This is a simple "terminal" program that uses the Nordic Semiconductor
    (nRF) UART service. It reads from stdin and sends each line of data to the
    remote device. Any data received from the device is printed to stdout.
    """

    def match_nus_uuid(device: BLEDevice, adv: AdvertisementData):
        # This assumes that the device includes the UART service UUID in the
        # advertising data. This test may need to be adjusted depending on the
        # actual advertising data supplied by the device.
        if UART_SERVICE_UUID.lower() in adv.service_uuids:
            return True

        return False

    device = await BleakScanner.find_device_by_filter(match_nus_uuid)

    if device is None:
        print("no matching device found, you may need to edit match_nus_uuid().")
        sys.exit(1)

    def handle_disconnect(_: BleakClient):
        print("Device was disconnected, goodbye.")
        # plt.imshow(np.array(features).T, aspect='auto', interpolation=None)
        # plt.figure(1, figsize=(5, 10))
        # plt.show()
        with open('sw/data/features.csv', 'w', newline='') as csvfile:
            feature_writer = csv.writer(csvfile)
            feature_writer.writerows(features)
        # cancelling all tasks effectively ends the program
        for task in asyncio.all_tasks():
            task.cancel()

    def handle_rx(_: BleakGATTCharacteristic, data: bytearray):
        global feature_buffer

        feature_buffer += data
        if (len(feature_buffer) >= N_FEATURES):
            new_feat = [int.from_bytes(feature_buffer[i:i+2], byteorder='little', signed=True) for i in range(0, N_FEATURES, 2)]
            if new_feat[0] > -14000:
                print(len(features) + 1)
                print(new_feat)
                features.append(new_feat[1:])
            feature_buffer = b""

    async with BleakClient(device, disconnected_callback=handle_disconnect) as client:
        await client.start_notify(UART_TX_CHAR_UUID, handle_rx)
        print("Connected")

        loop = asyncio.get_running_loop()
        while True:
            data = await loop.run_in_executor(None, sys.stdin.buffer.readline)


if __name__ == "__main__":
    try:
        asyncio.run(uart_terminal())
    except asyncio.CancelledError:
        # task is cancelled on disconnect, so we ignore this error
        pass
