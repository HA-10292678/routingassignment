#include "Pixie.h"
#include "TSRToLeds.h"

generic module RadioToLedsStageP() {
  provides interface PixieStage;
  uses interface PixieMemAlloc;
  uses interface Leds;
} implementation {
  command error_t PixieStage.init() {
    return SUCCESS;
  }
  
  command error_t PixieStage.run(memref_t memref) {
    
    tsr_leds_msg_t* msgPtr;
    uint8_t led_mask;
    uint8_t on;

    if (memref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      msgPtr = (tsr_leds_msg_t *) call PixieMemAlloc.data(memref);
      led_mask = msgPtr->led_mask;
      on = msgPtr->on;

      if (on == 1) {
        if (led_mask & 1) call Leds.led0On();
	if (led_mask & 2) call Leds.led1On();
	if (led_mask & 4) call Leds.led2On();
      } else {
      	if (led_mask & 1) call Leds.led0Off();
	if (led_mask & 2) call Leds.led1Off();
	if (led_mask & 4) call Leds.led2Off();
      }
      
      call PixieMemAlloc.release(memref);
    }
  } 

}