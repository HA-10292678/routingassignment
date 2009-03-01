import sys,os
sys.path.append(os.path.join(os.environ["TOSROOT"], "support/sdkpython"))
from tinyos.message import MoteIF
import TSRToLedsMsg

class MsgListener:
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.mif.addSource("sf@localhost:9002")
        self.mif.addListener(self, TSRToLedsMsg.TSRToLedsMsg)

    def receive(self, src, msg):
        if msg.get_amType() == TSRToLedsMsg.AM_TYPE:
            print "received mask:", msg.get_led_mask()
            print "received on? ", msg.get_on()

    def sendMsg(self, addr, amType, amGroup, msg):
        self.mif.sendMsg(self.source, add, amType, amGroup, msg)

listener = MsgListener()
msg = TSRToLedsMsg.TSRToLedsMsg()

while True:
    print "Waiting"
    time.sleep(1)
