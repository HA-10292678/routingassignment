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
	print "NodeID\tAvg. Light\tAvg.\tTreeDepth\tRecieved\tLost\t%"
	print "--------------------------------------------------------------------"
    def receive(self, src, msg):
        if msg.get_amType() == MultihopMsg.AM_TYPE:
	    id = msg.get_ID()
	    if(self.moteArray[id])
		self.moteArray[id].update(msg)
	    else
		self.moteArray[id] = new Mote(id)
    def sendMsg(self, addr, amType, amGroup, msg):
        self.mif.sendMsg(self.source, add, amType, amGroup, msg)
    def logMsg(self, msg):
	
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
	    self.packetsRecieved++
	self.droppedPackets = self.maxSeqnum - self.packetsRecieved	        
    def printStats():
	print self.ID + "\t" + self.avgData + "\t" + self.avgTreedepth + "\t" + self.packetsRecieved + "\t" + self.droppedPackets + "\t" + (self.droppedPackets/self.maxSeqnum)
listener = NetworkMonitor()
msg = MultihopMsg.MultihopMsg()

while True:
    time.sleep(1)
