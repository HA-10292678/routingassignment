#include "Pixie.h"

generic configuration BeaconProcessStage() {
  provides interface PixieSink as Input;
  provides interface RoutingTable as InputTable;
  uses interface PixieSink as Output;
  uses interface RoutingTable as OutputTable;
  
} implementation {
  
  components new BeaconProcessStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "BeaconProcessStage") as Wrapper;

  Input = Wrapper.Input;
  Output = BeaconProcessStageP.PixieSink;

  Wrapper.PixieStage -> BeaconProcessStageP;

  InputTable = OutputTable;

  components PixieC;
  BeaconProcessStageP.PixieMemAlloc -> PixieC;

}
