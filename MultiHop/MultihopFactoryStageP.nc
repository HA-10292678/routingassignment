#include "Pixie.h"
#include "MultiHop.h"
#include "printf.h"
generic module MultihopFactoryStageP() {
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
      if (TOS_NODE_ID == ROOT_ID){
	call PixieMemAlloc.release(ref);
        return SUCCESS;
      } else {
	memref_t newMR;
	message_t* msgPtr;
	MultihopMsg* msgPayload;
	uint16_t* TSRVal;
	uint16_t myParent;

	
	newMR = call PixieMemAlloc.allocate(sizeof(message_t));
	msgPtr = (message_t*) call PixieMemAlloc.data(newMR);
	TSRVal = (uint16_t*) call PixieMemAlloc.data(ref);
	msgPayload = (MultihopMsg*) call Packet.getPayload(msgPtr, sizeof(MultihopMsg));
	if (msgPtr != NULL) {
	  msgPayload->source = TOS_NODE_ID;
	  msgPayload->seqnum = call RoutingTable.getCurrentSeqnum();
	  msgPayload->treedepth = call RoutingTable.getCurrentTreeDepth();
	  msgPayload->data = *TSRVal;
	  
	  myParent = call RoutingTable.getCurrentParent();
	  call AMPacket.setSource(msgPtr, TOS_NODE_ID);
	  call AMPacket.setDestination(msgPtr, myParent);
	}
	printf("ID: %d Generating data packet, sending to parent: %d \n", TOS_NODE_ID, myParent);
	printfflush();
	
	call PixieSink.enqueue(newMR);
	call PixieMemAlloc.release(newMR);
	call PixieMemAlloc.release(ref);
	return SUCCESS;
      }
    } 
  }
}
  
  
