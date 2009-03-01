#include "Pixie.h"

generic configuration RadioToLedsStage(priority_t PRIORITY) {
  provides interface PixieSink as Input;

} implementation {

  components new RadioToLedsStageP();
  components new PixieStageWrapperC(PRIORITY, "RadioToLedsStage") as Wrapper;

  Input = Wrapper.Input;

  Wrapper.PixieStage -> RadioToLedsStageP;

  components PixieC;
  RadioToLedsStageP.PixieMemAlloc -> PixieC;

  components LedsC;
  RadioToLedsStageP.Leds -> LedsC;
}
