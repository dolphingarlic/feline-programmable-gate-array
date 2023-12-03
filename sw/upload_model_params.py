import asyncio
import sys
from itertools import count, takewhile
from typing import Iterator

from bleak import BleakClient, BleakScanner
from bleak.backends.characteristic import BleakGATTCharacteristic
from bleak.backends.device import BLEDevice
from bleak.backends.scanner import AdvertisementData
from sklearn.svm import OneClassSVM
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

    async with BleakClient(device, disconnected_callback=handle_disconnect) as client:
        print("Connected!")
        nus = client.services.get_service(UART_SERVICE_UUID)
        rx_char = nus.get_characteristic(UART_RX_CHAR_UUID)
        np.set_printoptions(linewidth=np.inf)
        await asyncio.sleep(0.5)

        print(f"Sending number of support vectors: {svm_model.n_support_[0]}")
        n_byte = int(svm_model.n_support_[0]).to_bytes(1, "big")
        await client.write_gatt_char(rx_char, n_byte, response=False)
        print()
        await asyncio.sleep(0.05)

        print("Sending support vectors:")
        duals = svm_model.dual_coef_[0]
        supports = svm_model.support_vectors_
        scaled_and_rounded = np.round((supports.T * duals).T)
        for i, vec in enumerate(scaled_and_rounded):
            print(f"Vector {i}: {vec}")
            vec_bytes = b''.join([int(coef).to_bytes(2, "big", signed=True) for coef in vec])
            for s in sliced(vec_bytes, rx_char.max_write_without_response_size):
                await client.write_gatt_char(rx_char, s, response=False)
                await asyncio.sleep(0.05)
        print()
        
        print(f"Sending bias: {round(svm_model.intercept_[0])}")
        bias_bytes = int(round(svm_model.intercept_[0])).to_bytes(4, "big", signed=True)
        await client.write_gatt_char(rx_char, bias_bytes, response=False)
        print()
        await asyncio.sleep(0.5)

        print("Done!")


if __name__ == "__main__":
    try:
        asyncio.run(uart_terminal())
    except asyncio.CancelledError:
        # task is cancelled on disconnect, so we ignore this error
        pass
