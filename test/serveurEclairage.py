
# coding utf-8

import socket
import threading
import serial
import json
import colour

SERIAL_PORT = "/dev/ttyUSB0"

def UpdateColor(colors):
    ser = serial.Serial(SERIAL_PORT,115200,timeout=0.2)
    m = [0xDE, 0xAD]
    length = 180
    command = 10
    checksum = length ^ command
    for c in colors:
        checksum = checksum ^ c
    m = m + [length, command] + colors + [checksum, 0xBE, 0xEF]
    toSend = bytes(m)
    ser.write(toSend)
    resp = ser.readall()
    print(resp)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.bind(('',15555))

    while True:
        sock.listen(5)
        client, address = sock.accept()
        print("{} connected".format(address))
        resp = client.recv(4096)
        if resp != "":
            client.send(resp)
            print(resp)
            d = json.loads(resp.decode("utf-8"))
            print(d)
            if "command" in d:
                print("Command: {}".format(d["command"]))
                if "led colors" in d:
                    UpdateColor(d["led colors"])
sock.close()