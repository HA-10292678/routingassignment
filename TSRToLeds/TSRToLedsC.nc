#include "Pixie.h"
#include "message.h"

configuration TSRToLedsC
{
}

implementation
{
  components new TimerStage(32) as TimerStage;
  components new TSRSensorStage(PIXIE_PRIORITY_NORM);
  components new TSRToLedsStage(PIXIE_PRIORITY_NORM) as TSRToLedsStage;
  components new SendStage(PIXIE_PRIORITY_NORM, TOS_BCAST_ADDR, tsr_leds_msg_t, AM_TSR_LEDS_MSG);
  components new ReceiveStage(tsr_leds_msg_t, AM_TSR_LEDS_MSG);
  components new RadioToLedsStage(PIXIE_PRIORITY_NORM);
  components new SerialSendStage(PIXIE_PRIORITY_NORM, tsr_leds_msg_t, AM_TSR_LEDS_MSG);

  /* TX Path */
  TimerStage.Output -> TSRSensorStage.Input;
  TSRSensorStage.Output -> TSRToLedsStage.Input;
  TSRToLedsStage.Output -> SendStage.Input;
  //TSRToLedsStage.Output -> SerialSendStage.Input;

  /* RX Path */
  ReceiveStage.Output -> RadioToLedsStage.Input;

}