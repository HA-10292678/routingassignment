#include "Pixie.h"

generic configuration MultihopProcessStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
  
} implementation {
  
  components new MultihopProcessStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "MultihopProcessStage") as Wrapper;

  Input = Wrapper.Input;
  Output = MultihopProcessStageP.PixieSink;

  Wrapper.PixieStage -> MultihopProcessStageP;

  components PixieC;
  MultihopProcessStageP.PixieMemAlloc -> PixieC;

}

