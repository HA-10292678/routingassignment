#include "printf.h"
#include "Pixie.h"
#include "TSRToLeds.h"

generic module TSRToLedsStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
  uses interface Leds;
} implementation {

  command error_t PixieStage.init() {
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      memref_t newMR;
      tsr_leds_msg_t *msgPtr;
      uint16_t* TSRVal;
      uint8_t LED_MASK = TOS_NODE_ID;

      newMR = call PixieMemAlloc.allocate(sizeof(tsr_leds_msg_t));
      msgPtr = (tsr_leds_msg_t*) call PixieMemAlloc.data(newMR);


      TSRVal = (uint16_t*) call PixieMemAlloc.data(ref);
      
      if (*TSRVal > 10) {
        if (LED_MASK & 1) call Leds.led0On();
	if (LED_MASK & 2) call Leds.led1On();
	if (LED_MASK & 4) call Leds.led2On();

	if (msgPtr != NULL) {
	  printf("LED_MASK: %d, on? %d\n", LED_MASK, 1);
	  msgPtr->led_mask = LED_MASK;
	  msgPtr->on = 1; 
	}	

      } else {
        if (LED_MASK & 1) call Leds.led0Off();
	if (LED_MASK & 2) call Leds.led1Off();
	if (LED_MASK & 4) call Leds.led2Off();

	if (msgPtr != NULL) {
	  printf("LED_MASK: %d, on? %d\n", LED_MASK, 0);
	  msgPtr->led_mask = LED_MASK;
	  msgPtr->on = 0;
	}

      }
      printfflush();
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);
      call PixieMemAlloc.release(ref);
      return SUCCESS;
    }
  } 
}