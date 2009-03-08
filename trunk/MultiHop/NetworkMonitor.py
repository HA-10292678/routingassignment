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
	self.rawlog = LogFileWriter()
    def receive(self, src, msg):
        if msg.get_amType() == MultihopMsg.AM_TYPE:
	    id = msg.get_source()
            if id in self.moteArray:
		self.moteArray[id].update(msg)
            else:
		self.moteArray[id] = Mote(id)
                self.moteArray[id].update(msg)	
    def __input(self):
	self.rawlog.close()
	SummaryWriter(self.moteArray)
	done = true	
class Writer():
    def __init__(self, filename):
        self.open=False
        try:
            self.datalog=open(filename,'a')
            self.open=True
        except:
            print("could not create text Document")
            self.open=False
    def write(self,row):
        if self.open:
            self.datalog.write(str(row))
	    self.datalog.write("\n")
            self.datalog.flush()
    def close(self):
        self.datalog.close()
        self.open=False

class LogFileWriter():
    def __init__(self):
	self.log = Writer("rawlog.csv")
	tableheader = "Time,Source,Sequence #,Tree depth, Light Sensor\n"
	if self.log.open:
	    self.log.write(tableheader)
	    self.open = True
    def writePacket(self, msg):
	if self.open:
	    row = []
	    row.append(str(self.__timeMaker()))
	    row.append(str(msg.get_source()))
	    row.append(str(msg.get_seqnum()))
	    row.append(str(msg.get_treedepth()))
	    row.append(str(msg.get_data()))
	    string = ""
	    for i in row:
		string += row[i]
		srting += ","
	    print string
    def close(self):
	self.log.close()
	self.open = False
    def __timeMaker(self):
        now=time.localtime()
        newformat=(now[3],now[4],now[5])
        return "%d:%d:%d" % newformat

class SummaryWriter():
    def __init__(self, moteArray):
	self.summary = Writer("Summary.txt")
	self.summary.write("NodeID\tAvg. Light\tAvg.TreeDepth\tRecieved\tLost\t%")
	self.array = moteArray
    def writeResults():
	for node in sort(self.array.keys()):
	    self.array[i].printStats()
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
        stats = ""
	stats += self.ID self.avgData
	stats +="\t"
	stats += self.avgTreedepth
	stats += "\t"
	stats += self.packetsRecieved
	stats += "\t"
	stats += self.droppedPackets
	stats += "\t"
	stats += percent
	return stats
listener = NetworkMonitor()
msg = MultihopMsg.MultihopMsg()
done = false
while not done:
    time.sleep(1)
