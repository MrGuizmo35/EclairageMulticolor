# coding utf-8

import socket
from threading import Thread, RLock
import serial
import json
import colour
import time

SERIAL_PORT = "/dev/ttyAMA0"

class LedStripControler(Thread):
    def __init__(self,SerialPort):
        Thread.__init__(self)
        self._serialPort = SerialPort
        self._ser = serial.Serial(self._serialPort,115200,timeout=0.2)
        self.leds = []
        self.nbLeds = 60
        for i in range(self.nbLeds):
            self.leds.append(colour.Color("black"))
        self.mode = "off"
        self.currentHue = 0
        self.modeLock = RLock()

    def updateMode(self,new_mode):
        with self.modeLock:
            self.mode = new_mode

    def run(self):
        while True:
            if self.mode == "off":
                self.offMode()
            elif self.mode == "variable":
                self.variableMode()
            elif self.mode == "manuel":
                self.manualMode()
            elif self.mode == "auto":
                self.autoMode()
            else:
                self.mode="off"
            time.sleep(0.005)

    def offMode(self):
        t = time.localtime().tm_hour
        if(t >= 17 and t<21):
            with self.modeLock:
                self.mode = "auto"
        for i in range(self.nbLeds):
            self.leds[i] = colour.Color("black")
        self.UpdateLedColors()

    def variableMode(self):
        t = time.localtime().tm_hour
        if(t >= 23):
            with self.modeLock:
                self.mode = "off"
        else:
            for i in range(self.nbLeds):
                self.leds[i].saturation = 1
                self.leds[i].luminance = 0.2
                self.leds[i].hue = self.currentHue
                self.currentHue = self.currentHue + 1.0/(self.nbLeds + 1)
                if self.currentHue > 1:
                    self.currentHue = 0
            self.UpdateLedColors()
    
    def manualMode(self):
        t = time.localtime().tm_hour
        self.UpdateLedColors()
        if(t >= 23):
            with self.modeLock:
                self.mode = "off"

    def autoMode(self):
        t = time.localtime().tm_hour
        if(t >= 21):
            with self.modeLock:
                self.mode = "off"
        else:
            for i in range(self.nbLeds):
                self.leds[i].saturation = 1
                self.leds[i].luminance = 0.2
                self.leds[i].hue = self.currentHue
                self.currentHue = self.currentHue + 1.0/(self.nbLeds + 1)
                if self.currentHue > 1:
                    self.currentHue = 0
            self.UpdateLedColors()

    def UpdateLedColors(self):
        m = [0xDE, 0xAD]
        length = 180
        command = 10
        checksum = length ^ command
        colors = []
        for c in self.leds:
            colors.append(int(255 * c.get_green()))
            colors.append(int(255 * c.get_red()))
            colors.append(int(255 * c.get_blue()))
        for c in colors:
            checksum = checksum ^ c
        m = m + [length, command] + colors + [checksum, 0xBE, 0xEF]
        toSend = bytes(m)
        self._ser.write(toSend)
        resp = self._ser.readall()

class TCPServer(Thread):
    def __init__(self,Port, ledstripControler):
        Thread.__init__(self)
        self._port = Port
        self._ledstripControler = ledstripControler

    def run(self):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.bind(('',self._port))
            while True:
                sock.listen(5)
                client, address = sock.accept()
                resp = client.recv(4096)
                if resp != "":
                    client.send(resp)
                    d = json.loads(resp.decode("utf-8"))
                    if "command" in d:
                        if(d["command"] == "manuel"):
                            self._ledstripControler.updateMode("manuel")
                            if "led colors" in d:
                                for i in range(len(self._ledstripControler.leds)):
                                    self._ledstripControler.leds[i].hex = d["led colors"][i]
                        elif d["command"] == "variable":
                            self._ledstripControler.updateMode("variable")
            sock.close()


if __name__ == "__main__":
    ledstrip = LedStripControler(SERIAL_PORT)
    tcpServer = TCPServer(15555, ledstrip)

    ledstrip.start()
    tcpServer.start()
    tcpServer.join()
    ledstrip.join()