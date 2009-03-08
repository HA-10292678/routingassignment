import sys
import os
import time
import signal
#sys.path.append(os.path.join(os.environ["TOSROOT"], "support/sdk/python"))
sys.path.append(os.path.join("/usr/local/tinyos-2.x", "support/sdk/python"))
from tinyos.message import MoteIF
import MultihopMsg

class NetworkMonitor:
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.mif.addSource("sf@"+sys.argv[1])
        self.mif.addListener(self, MultihopMsg.MultihopMsg)
	self.moteArray = {}
	self.rawlog = LogFileWriter()        
        time.sleep(2)
    def receive(self, src, msg):
        if msg.get_amType() == MultihopMsg.AM_TYPE:
            self.rawlog.writePacket(msg)
            id = msg.get_source()
            if id in self.moteArray:
		self.moteArray[id].update(msg)
            else:
		self.moteArray[id] = Mote(id)
                self.moteArray[id].update(msg)	
class Writer():
    def __init__(self, filename):
        self.open=False
        try:
            self.datalog=open(filename,'w')
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

class LogFileWriter:
    def __init__(self):
	self.log = Writer("rawlog.csv")
	tableheader = "Time,Source,Sequence #,Tree depth, Light Sensor\n"
	self.open = False
        if self.log.open:
            print tableheader
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
		string += i
		string += ","
	    self.log.write(string)
            print string
    def close(self):
	self.log.close()
	self.open = False
    def __timeMaker(self):
        now=time.localtime()
        newformat=(now[3],now[4],now[5])
        return "%d:%d:%d" % newformat

class SummaryWriter:
    def __init__(self, moteArray):
	self.summary = Writer("Summary.txt")
	self.summary.write("NodeID\tAvg. Light\tAvg.TreeDepth\tRecieved\tLost\t%")
	self.array = moteArray
        self.writeResults()
        self.summary.close()
    def writeResults(self):
        keys = self.array.keys()
        keys.sort()
	for i in keys:
            print self.summary.array[i].printStats()
	    self.summary.write(self.array[i].printStats())
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
	    self.updatePacketStats(msg.get_seqnum())
	    self.updateData(msg.get_data())
	    self.updateTreedepth(msg.get_treedepth())
    def updateData(self, value):
	if(self.avgData == -1):
	    self.avgData = value
	else:
	    self.avgData = (value + self.avgData)/self.packetsRecieved
    def updateTreedepth(self, value):
	if(self.avgTreedepth == -1):
	    self.avgTreedepth = value
	else:
	    self.avgTreedepth = (self.avgTreedepth + value)/self.packetsRecieved
    def updatePacketStats(self, seqnum):
	if(seqnum > self.maxSeqnum):
	    self.maxSeqnum = seqnum
	    self.packetsRecieved += 1
    def printStats(self):
	self.droppedPackets = self.maxSeqnum - self.packetsRecieved        
        percent = float(self.droppedPackets/self.maxSeqnum)
        stats = ""
	stats += str(self.ID)
	stats +="\t"
        stats += str(self.avgData)
        stats +="\t"
	stats += str(self.avgTreedepth)
	stats += "\t"
	stats += str(self.packetsRecieved)
	stats += "\t"
	stats += str(self.droppedPackets)
	stats += "\t"
	stats += str(percent)
	return stats
global listener 
listener = NetworkMonitor()
msg = MultihopMsg.MultihopMsg()
done = False
def exitHandler(signum, frame):
        print "Exiting..."
        #listener.rawlog.close()
	#SummaryWriter(listener.moteArray)
	done = True
        sys.exit(0)

signal.signal(signal.SIGINT,exitHandler)
while not done:
    time.sleep(1)

