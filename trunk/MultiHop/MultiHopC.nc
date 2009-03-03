#include "Pixie.h"
#include "message.h"

configuration TSRToLedsC
{
}

/* This is mostly a first step for the overall wiring.
Many of these stages will not yet be implemented and
we need to implement them.                          
*/

/* I think we can manage to write one code base for all
nodes and have node ID 0 act as the base station. 
*/
implementation
{

  /* Root beacon tx */
  components new TimerStage(1000) as BeaconTXTimerStage;
  components new BeaconFactoryStage() as BeaconFactoryStage;
  components new SendStage(PIXIE_PRIORITY_NORM, TOS_BCAST_ADDR, BeaconMsg, AM_BEACON_MSG) as BeaconFactorySendStage;
  
  BeaconTXTimerStage.Output -> BeaconFactoryStage.Input;
  BeaconFactoryStage.Output -> BeaconFactorySendStage.Input;

  /* Receive beacon */
  components new ReceiveMessageStage(BeaconMsg, AM_BEACON_MSG) as BeaconReceiveMessageStage;
  components new BeaconProcessStage() as BeaconProcessStage;
  components new SendStage(PIXIE_PRIORITY_NORM, TOS_BCAST_ADDR, BeaconMsg, AM_BEACON_MSG) as BeaconProcessSendStage; 
  
  BeaconReceiveMessageStage.Output -> BeaconProcessStage.Input;
  BeaconProcessStage.Output -> BeaconProcessSendStage.Input;


}