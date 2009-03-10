import sys
import os
import time

class NetworkStats:
    def __init__(self):
	self.moteArray = {}
	self.filename = sys.argv[1]
	self.reader = Reader(self.filename)
	self.ParseLogFile()
    def ParseLogFile(self):
	line_num = 0
	packet = self.reader.readPacket()
	packet = self.reader.readPacket()#Ignore first two header lines of log file.
	packet = self.reader.readPacket()
	packet[1] = int(packet[1])
	while packet != False:
	    id=packet[1]
	    if id in self.moteArray:
		self.moteArray[id].update(packet)
	    else:
		self.moteArray[id] = Mote(id)
		self.moteArray[id].update(packet)
	    line_num += 1
	    print "Parsing line #" + str(line_num)
	    packet = self.reader.readPacket()
	    if packet:
		packet[1] = int(packet[1])
	print "Done parsing, outputing table..."
	SummaryWriter(self.moteArray)
	print "Exiting..."

class Reader:
    def __init__(self, filename):
        self.open=False
        try:
            self.datalog=open(filename,"r")
	    self.open = True
        except:
	    print "Failed to open document"
            self.open=False
    def readPacket(self):
        if self.open:
            line = self.datalog.readline()
	    if line == "":
	        return False
	    else:
		array = line.split(',')
		return array
    def close(self):
        self.datalog.close()
        self.open=False

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

class SummaryWriter:
    def __init__(self, moteArray):
	self.summary = Writer("Summary.txt")
	summary_header = "NodeID\tAvg. Light\tAvg.TreeDepth\tRecieved\tLost\t%" 
	self.summary.write(summary_header)
	self.line = ""
	for i in range(0, len(summary_header)+20):
	    self.line += "-"
	self.summary.write(self.line)
	self.array = moteArray
        self.writeResults()
        self.summary.close()
    def writeResults(self):
        keys = self.array.keys()
        keys.sort()
	for i in keys:
	    self.summary.write(self.array[i].printStats())
	self.summary.write(self.line)
	self.summary.write(str(len(keys))+" total nodes in tree")
class Mote:
    def __init__(self, NodeID):
	self.ID = NodeID
	self.avgData = []
	self.avgTreedepth = []
	self.packetsRecieved = 0
	self.maxSeqnum = 0
	self.minSeqnum = 4294967295
    def update(self, msg):
	if(msg[1] == self.ID):
	    self.updatePacketStats(int(msg[2]))
	    self.updateData(int(msg[4]))
	    self.updateTreedepth(int(msg[3]))
    def updateData(self, value):
	self.avgData.append(value)
    def updateTreedepth(self, value):
	self.avgTreedepth.append(value)
    def updatePacketStats(self, seqnum):
	if(seqnum > self.maxSeqnum):
	    self.maxSeqnum = seqnum
	if((seqnum < self.minSeqnum) or (self.minSeqnum == -1)):
	    self.minSeqnum = seqnum
	self.packetsRecieved += 1
    def printStats(self):
	self.droppedPackets = float((self.maxSeqnum - self.minSeqnum + 1) - self.packetsRecieved)        
        if (self.maxSeqnum == self.minSeqnum):
	    percent = 0
	else:
	    percent = round(100*(self.droppedPackets/(self.packetsRecieved+self.droppedPackets)))
        stats = ""
	stats += str(self.ID)
	stats +="\t"
        stats += str(round(self.average(self.avgData),2))
        stats +="\t\t"
	stats += str(round(self.average(self.avgTreedepth),2))
	stats += "\t\t"
	stats += str(self.packetsRecieved)
	stats += "\t\t"
	stats += str(int(self.droppedPackets))
	stats += "\t"
	stats += str(percent)+"%"
	return stats
    def average(self, values):
	return sum(values, 0.0)/len(values)
print "Starting table parse..."
stats = NetworkStats()
