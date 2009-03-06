#include "Pixie.h"
#include "MultiHop.h"

generic module MultihopProcessStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
  uses interface RoutingTable;
  uses interface Packet;
  uses interface AMPacket;
} implementation {

  command error_t PixieStage.init() {
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      memref_t newMR;
      message_t *msgPtr;
      MultihopMsg *msgPayload;
      MultihopMsg *origMsgPtr;
      uint16_t myParent;
     
      origMsgPtr = (MultihopMsg*) call PixieMemAlloc.data(ref);
      newMR = call PixieMemAlloc.allocate(sizeof(message_t));
      msgPtr = (message_t*) call PixieMemAlloc.data(newMR);
      msgPayload = (MultihopMsg*) call Packet.getPayload(msgPtr, sizeof(MultihopMsg));
      msgPayload->source = origMsgPtr->source;
      msgPayload->seqnum = origMsgPtr->seqnum;
      msgPayload->treedepth = origMsgPtr->treedepth;
      msgPayload->data = origMsgPtr->data;
      

      /*Setup send and recieve fields */
      myParent = call RoutingTable.getCurrentParent();
      call AMPacket.setSource(msgPtr, TOS_NODE_ID);
      call AMPacket.setDestination(msgPtr, myParent);
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);	
    }
      
    call PixieMemAlloc.release(ref);
    return SUCCESS;
  }

}

