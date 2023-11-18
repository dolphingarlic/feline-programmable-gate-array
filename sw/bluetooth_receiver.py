import asyncio
import os
import struct

from bleak import BleakClient
from dotenv import load_dotenv

load_dotenv()

address = os.getenv('FPGA_BLE_MAC_ADDRESS')
UART_RX = 'Nordic UART RX'
UART_TX = 'Nordic UART TX'

async def main(address):
    async with BleakClient(address) as client:
        # Discover the GATT characteristics
        rx = None
        tx = None
        for service in client.services:
            for characteristic in service.characteristics:
                if characteristic.description == UART_RX:
                    rx = characteristic
                elif characteristic.description == UART_TX:
                    tx = characteristic
        # Send and receive data
        while True:
            r = int(input('Red: '))
            g = int(input('Green: '))
            b = int(input('Blue: '))
            zero = 0
            await client.write_gatt_char(rx, r.to_bytes(1, 'big') + g.to_bytes(1, 'big') +\
                                             b.to_bytes(1, 'big') + zero.to_bytes(1, 'big'))

asyncio.run(main(address))
