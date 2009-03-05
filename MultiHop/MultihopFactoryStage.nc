#include "Pixie.h"

generic configuration MultihopFactoryStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
} implementation {
  
  components new MultihopFactoryStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "MultihopFactoryStage") as Wrapper;

  Input = Wrapper.Input;
  Output = MultihopFactoryStageP.PixieSink;

  Wrapper.PixieStage -> MultihopFactoryStageP;

  components PixieC;
  MultihopFactoryStageP.PixieMemAlloc -> PixieC;

}
