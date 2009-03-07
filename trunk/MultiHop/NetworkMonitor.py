import sys
import os
import time
sys.path.append(os.path.join(os.environ["TOSROOT"], "support/sdkpython"))
from tinyos.message import MoteIF
import MultihopMsg

class NetworkMonitor:
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.mif.addSource("sf@localhost:9000")
        self.mif.addListener(self, MultihopMsg.MultihopMsg)

    def receive(self, src, msg):
        if msg.get_amType() == MultihopMsg.AM_TYPE:
	    print "source: ", msg.get_source()
	    print "seqnum: ", msg.get_seqnum()
	    print "treedepth: ", msg.get_treedepth()
	    print "data: ", msg.get_data()
    def sendMsg(self, addr, amType, amGroup, msg):
        self.mif.sendMsg(self.source, add, amType, amGroup, msg)

listener = NetworkMonitor()
msg = MultihopMsg.MultihopMsg()

while True:
    print "Waiting..."
    time.sleep(1)
