#include "Pixie.h"

generic configuration BeaconProcessStage() {
  provides interface PixieSink as Input;
  uses interface PixieSink as Output;
  
} implementation {
  
  components new BeaconProcessStageP();
  components new PixieStageWrapperC(PIXIE_PRIORITY_NORM, "BeaconProcessStage") as Wrapper;

  Input = Wrapper.Input;
  Output = BeaconProcessStageP.PixieSink;

  Wrapper.PixieStage -> BeaconProcessStageP;

  components RoutingTableP;
  BeaconProcessStageP.RoutingTable -> RoutingTableP;

  components PixieC;
  components CC2420PacketC;

  BeaconProcessStageP.PixieMemAlloc -> PixieC;
  BeaconProcessStageP.Packet -> PixieC;
  BeaconProcessStageP.CC2420Packet -> CC2420PacketC;

  components LedsC;
  BeaconProcessStageP.Leds -> LedsC;
}
