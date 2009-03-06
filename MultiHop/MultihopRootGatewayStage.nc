#include "Pixie.h"

generic configuration MultihopRootGatewayStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
} implementation {
  
  components new MultihopRootGatewayStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "MultihopRootGatewayStage") as Wrapper;

  Input = Wrapper.Input;
  Output = MultihopRootGatewayStageP.PixieSink;

  Wrapper.PixieStage -> MultihopRootGatewayStageP;

  components PixieC;
  MultihopRootGatewayStageP.PixieMemAlloc -> PixieC;
