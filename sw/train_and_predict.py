import asyncio
import sys
from itertools import count, takewhile
from typing import Iterator
import csv

from bleak import BleakClient, BleakScanner
from bleak.backends.characteristic import BleakGATTCharacteristic
from bleak.backends.device import BLEDevice
from bleak.backends.scanner import AdvertisementData
from sklearn.svm import OneClassSVM
from sklearn.mixture import GaussianMixture
import numpy as np

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

N_FEATURES = 32

feature_buffer = b""
detected = False


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

    data = np.genfromtxt('sw/data/features.csv', delimiter=',')
    svm_model = OneClassSVM(kernel='linear', nu=0.1).fit(data)

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
        # cancelling all tasks effectively ends the program
        for task in asyncio.all_tasks():
            task.cancel()

    def handle_rx(_: BleakGATTCharacteristic, data: bytearray):
        global feature_buffer
        global detected

        feature_buffer += data
        if (len(feature_buffer) >= N_FEATURES):
            new_feat = [int.from_bytes(feature_buffer[i:i+2], byteorder='little', signed=True) for i in range(0, N_FEATURES, 2)]
            svm_pred = svm_model.predict(np.array([new_feat[1:]]))[0]

            detected = new_feat[0] > -14000 and svm_pred == 1
            if new_feat[0] > -14000:
                print(detected)
                # print(gmm_model.score(np.array([new_feat[1:]])))

            feature_buffer = b""

    async with BleakClient(device, disconnected_callback=handle_disconnect) as client:
        await client.start_notify(UART_TX_CHAR_UUID, handle_rx)

        print("Connected, start typing and press ENTER...")

        loop = asyncio.get_running_loop()
        nus = client.services.get_service(UART_SERVICE_UUID)
        rx_char = nus.get_characteristic(UART_RX_CHAR_UUID)

        while True:
            # This waits until you type a line and press ENTER.
            # A real terminal program might put stdin in raw mode so that things
            # like CTRL+C get passed to the remote device.
            data = await loop.run_in_executor(None, sys.stdin.buffer.readline)

            # data will be empty on EOF (e.g. CTRL+D on *nix)
            if not data:
                break

            # some devices, like devices running MicroPython, expect Windows
            # line endings (uncomment line below if needed)
            # data = data.replace(b"\n", b"\r\n")
            # data = data.replace(b"\n", b"")

            # Writing without response requires that the data can fit in a
            # single BLE packet. We can use the max_write_without_response_size
            # property to split the data into chunks that will fit.

            for s in sliced(data, rx_char.max_write_without_response_size):
                await client.write_gatt_char(rx_char, s, response=False)
            
            # if detected:
            #     await client.write_gatt_char(rx_char, b'\x01', response=False)
            # else:
            #     await client.write_gatt_char(rx_char, b'\x00', response=False)

            print("sent:", data)


if __name__ == "__main__":
    # try:
    #     asyncio.run(uart_terminal())
    # except asyncio.CancelledError:
    #     # task is cancelled on disconnect, so we ignore this error
    #     pass
    data = np.genfromtxt('sw/data/features.csv', delimiter=',')
    svm_model = OneClassSVM(kernel='linear', nu=0.1).fit(data)

    print('NUMBER OF SUPPORT VECTORS:')
    print(svm_model.n_support_[0])
    print()

    # print('WEIGHTS OF SUPPORT VECTORS:')
    # print(svm_model.dual_coef_[0])
    # print()
    
    # print('SUPPORT VECTORS:')
    # print(svm_model.support_vectors_)
    # print()

    print('SCALED AND ROUNDED SUPPORT VECTORS:')
    duals = svm_model.dual_coef_[0]
    supports = svm_model.support_vectors_
    scaled = (supports.T * duals).T
    print(np.round(scaled))
    print()

    print('BIAS:')
    print(round(svm_model.intercept_[0]))
