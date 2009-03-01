#include "Pixie.h"

generic configuration TSRToLedsStage(priority_t PRIORITY) {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
} implementation {
  
  components new TSRToLedsStageP();
  components new PixieStageWrapperC(PRIORITY, "BlinkStage") as Wrapper;

  Input = Wrapper.Input;
  Output = TSRToLedsStageP.PixieSink;

  Wrapper.PixieStage -> TSRToLedsStageP;

  components PixieC;
  TSRToLedsStageP.PixieMemAlloc -> PixieC;

  components LedsC;
  TSRToLedsStageP.Leds -> LedsC;

}