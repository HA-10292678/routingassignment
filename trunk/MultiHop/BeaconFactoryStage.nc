#include "Pixie.h"

generic configuration BeaconFactoryStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
} implementation {
  
  components new BeaconFactoryStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "BeaconFactoryStage") as Wrapper;

  Input = Wrapper.Input;
  Output = BeaconFactoryStageP.PixieSink;

  Wrapper.PixieStage -> BeaconFactoryStageP;

  components PixieC;
  BeaconFactoryStageP.PixieMemAlloc -> PixieC;

}
