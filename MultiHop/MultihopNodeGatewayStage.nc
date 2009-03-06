#include "Pixie.h"

generic configuration MultihopNodeGatewayStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
} implementation {
  
  components new MultihopNodeGatewayStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "MultihopNodeGatewayStage") as Wrapper;

  Input = Wrapper.Input;
  Output = MultihopNodeGatewayStageP.PixieSink;

  Wrapper.PixieStage -> MultihopNodeGatewayStageP;

  components PixieC;
  MultihopNodeGatewayStageP.PixieMemAlloc -> PixieC;
}
