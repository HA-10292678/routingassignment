#include "Pixie.h"
#include "MultiHop.h"
#include "printf.h"
generic module MultihopRootGatewayStageP() {
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
      if (TOS_NODE_ID != ROOT_ID){
        call PixieMemAlloc.release(ref);
	return SUCCESS;
      } 
      printf("Made it to RootGatewayStageP \n");
      printfflush();
      call PixieSink.enqueue(ref);
      call PixieMemAlloc.release(ref);        
      return SUCCESS;
    }
  }
}
