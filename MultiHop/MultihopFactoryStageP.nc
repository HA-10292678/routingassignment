#include "Pixie.h"
#include "Multihop.h"
generic module MultihopProcessStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
  uses interface RoutingTable;
} implementation {

  command error_t PixieStage.init() {
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      memref_t newMR;
      MultihopMsg* msgPtr;
      uint16_t* TSRVal;

      newMR = call PixieMemAlloc.allocate(sizeof(MultihopMsg));
      msgPtr = (MultihopMsg*) call PixieMemAlloc.data(newMR);
      TSRVal = (uint16_t*) call PixieMemAlloc.data(ref);
      
	if (msgPtr != NULL) {
	  msgPtr->source = TOS_NODE_ID;
	  msgPtr->seqnum = call RoutingTable.getCurrentSeqnum();
	  msgPtr->treedepth = call RoutingTable.getCurrentTreeDepth();
	  msgPtr->data = TSRVal;
	}

      }
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);
      call PixieMemAlloc.release(ref);
      return SUCCESS;
  } 
}

