#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'MultihopMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 10

# The Active Message type associated with this message.
AM_TYPE = 42

class MultihopMsg(tinyos.message.Message.Message):
    # Create a new MultihopMsg of size 10.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=10):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <MultihopMsg> \n"
        try:
            s += "  [source=0x%x]\n" % (self.get_source())
        except:
            pass
        try:
            s += "  [seqnum=0x%x]\n" % (self.get_seqnum())
        except:
            pass
        try:
            s += "  [treedepth=0x%x]\n" % (self.get_treedepth())
        except:
            pass
        try:
            s += "  [data=0x%x]\n" % (self.get_data())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: source
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'source' is signed (False).
    #
    def isSigned_source(self):
        return False
    
    #
    # Return whether the field 'source' is an array (False).
    #
    def isArray_source(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'source'
    #
    def offset_source(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'source'
    #
    def offsetBits_source(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'source'
    #
    def get_source(self):
        return self.getUIntElement(self.offsetBits_source(), 16, 1)
    
    #
    # Set the value of the field 'source'
    #
    def set_source(self, value):
        self.setUIntElement(self.offsetBits_source(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'source'
    #
    def size_source(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'source'
    #
    def sizeBits_source(self):
        return 16
    
    #
    # Accessor methods for field: seqnum
    #   Field type: long
    #   Offset (bits): 16
    #   Size (bits): 32
    #

    #
    # Return whether the field 'seqnum' is signed (False).
    #
    def isSigned_seqnum(self):
        return False
    
    #
    # Return whether the field 'seqnum' is an array (False).
    #
    def isArray_seqnum(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'seqnum'
    #
    def offset_seqnum(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'seqnum'
    #
    def offsetBits_seqnum(self):
        return 16
    
    #
    # Return the value (as a long) of the field 'seqnum'
    #
    def get_seqnum(self):
        return self.getUIntElement(self.offsetBits_seqnum(), 32, 1)
    
    #
    # Set the value of the field 'seqnum'
    #
    def set_seqnum(self, value):
        self.setUIntElement(self.offsetBits_seqnum(), 32, value, 1)
    
    #
    # Return the size, in bytes, of the field 'seqnum'
    #
    def size_seqnum(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'seqnum'
    #
    def sizeBits_seqnum(self):
        return 32
    
    #
    # Accessor methods for field: treedepth
    #   Field type: int
    #   Offset (bits): 48
    #   Size (bits): 16
    #

    #
    # Return whether the field 'treedepth' is signed (False).
    #
    def isSigned_treedepth(self):
        return False
    
    #
    # Return whether the field 'treedepth' is an array (False).
    #
    def isArray_treedepth(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'treedepth'
    #
    def offset_treedepth(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'treedepth'
    #
    def offsetBits_treedepth(self):
        return 48
    
    #
    # Return the value (as a int) of the field 'treedepth'
    #
    def get_treedepth(self):
        return self.getUIntElement(self.offsetBits_treedepth(), 16, 1)
    
    #
    # Set the value of the field 'treedepth'
    #
    def set_treedepth(self, value):
        self.setUIntElement(self.offsetBits_treedepth(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'treedepth'
    #
    def size_treedepth(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'treedepth'
    #
    def sizeBits_treedepth(self):
        return 16
    
    #
    # Accessor methods for field: data
    #   Field type: int
    #   Offset (bits): 64
    #   Size (bits): 16
    #

    #
    # Return whether the field 'data' is signed (False).
    #
    def isSigned_data(self):
        return False
    
    #
    # Return whether the field 'data' is an array (False).
    #
    def isArray_data(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'data'
    #
    def offset_data(self):
        return (64 / 8)
    
    #
    # Return the offset (in bits) of the field 'data'
    #
    def offsetBits_data(self):
        return 64
    
    #
    # Return the value (as a int) of the field 'data'
    #
    def get_data(self):
        return self.getUIntElement(self.offsetBits_data(), 16, 1)
    
    #
    # Set the value of the field 'data'
    #
    def set_data(self, value):
        self.setUIntElement(self.offsetBits_data(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'data'
    #
    def size_data(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'data'
    #
    def sizeBits_data(self):
        return 16
    
