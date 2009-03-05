#include "Pixie.h"
#include "MultiHop.h"

generic module BeaconFactoryStageP() {
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
      MultihopMsg* msgPtr;
      
      
      newMR = call PixieMemAlloc.allocate(sizeof(BeaconMsg));
      msgPtr = (BeaconMsg*) call PixieMemAlloc.data(newMR);
      msgPtr = ref;
	
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);	
      }
      
      call PixieMemAlloc.release(ref);
      return SUCCESS;
    }
  }

}

