#include "Pixie.h"
#include "MultiHop.h"

generic module MultihopProcessStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
} implementation {

  command error_t PixieStage.init() {
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      memref_t newMR;
      MultihopMsg *msgPtr;
      MultihopMsg *origMsgPtr;

      origMsgPtr = (MultihopMsg*) ref;
      
      newMR = call PixieMemAlloc.allocate(sizeof(MultihopMsg));
      msgPtr = (MultihopMsg*) call PixieMemAlloc.data(newMR);
      msgPtr->source = origMsgPtr->source;
      msgPtr->seqnum = origMsgPtr->seqnum;
      msgPtr->treedepth = origMsgPtr->treedepth;
      msgPtr->data = origMsgPtr->data;
	
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);	
    }
      
    call PixieMemAlloc.release(ref);
    return SUCCESS;
  }

}

