#include "printf.h"
#include "Pixie.h"
#include "MultiHop.h"

generic module BeaconFactoryStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
} implementation {

  uint32_t beacon_seqnum;

  command error_t PixieStage.init() {
    beacon_seqnum = 0;
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      memref_t newMR;
      BeaconMsg* msgPtr;
      
      
      // If the node is the root, send beacon msg
      if (TOS_NODE_ID == ROOT_ID){

	beacon_seqnum = beacon_seqnum + 1;
        newMR = call PixieMemAlloc.allocate(sizeof(BeaconMsg));
    	msgPtr = (BeaconMsg*) call PixieMemAlloc.data(newMR);
      	
	msgPtr->seqnum = beacon_seqnum;
	msgPtr->source = TOS_NODE_ID;
	msgPtr->treedepth = 0;
	
	printf("BeaconFactoryStageP: generating beacon. Source: %d, Treedepth: %d, Seqnum: %d\n", msgPtr->source, msgPtr->treedepth, msgPtr->seqnum);
	printfflush();
	call PixieSink.enqueue(newMR);
	call PixieMemAlloc.release(newMR);	
      }
      
      call PixieMemAlloc.release(ref);
      return SUCCESS;
    }
  }

}
