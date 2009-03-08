import sys
import os
import time
sys.path.append(os.path.join(os.environ["TOSROOT"], "support/sdkpython"))
from tinyos.message import MoteIF
import MultihopMsg

class NetworkMonitor:
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.mif.addSource("sf@"+sys.argv[1])
        self.mif.addListener(self, MultihopMsg.MultihopMsg)
	self.moteArray = {}
        time.sleep(2)
	print "NodeID\tAvg. Light\tAvg.TreeDepth\tRecieved\tLost\t%"
	print "--------------------------------------------------------------------"
    def receive(self, src, msg):
        if msg.get_amType() == MultihopMsg.AM_TYPE:
	    id = msg.get_source()
            if id in self.moteArray:
		self.moteArray[id].update(msg)
            else:
		self.moteArray[id] = Mote(id)
                self.moteArray[id].update(msg)
            self.moteArray[id].printStats()
class Mote:
    def __init__(self, NodeID):
	self.ID = NodeID
	self.avgData = -1
	self.avgTreedepth = -1
	self.packetsRecieved = 0
	self.maxSeqnum = -1
	self.droppedPackets = -1
    def update(self, msg):
	if(msg.get_source() == self.ID):
	    self.updateData(msg.get_data())
	    self.updateTreedepth(msg.get_treedepth())
	    self.updatePacketStats(msg.get_seqnum())
    def updateData(self, value):
	if(self.avgData == -1):
	    self.avgData = value
	else:
	    self.avgData = (value + self.avgData)/2
    def updateTreedepth(self, value):
	if(self.avgTreedepth == -1):
	    self.avgTreedepth = value
	else:
	    self.avgTreedepth = (self.avgTreedepth + value)/2
    def updatePacketStats(self, seqnum):
	if(seqnum > self.maxSeqnum):
	    self.maxSeqnum = seqnum
	    self.packetsRecieved += 1
    def printStats(self):
	self.droppedPackets = self.maxSeqnum - self.packetsRecieved        
        percent = float(self.droppedPackets/self.maxSeqnum)
        print self.ID,"\t",self.avgData,"\t\t",self.avgTreedepth,"\t\t",self.packetsRecieved,"\t\t",self.droppedPackets,"\t",percent,"%"
listener = NetworkMonitor()
msg = MultihopMsg.MultihopMsg()

while True:
    time.sleep(1)
