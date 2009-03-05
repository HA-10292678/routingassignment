#include "Pixie.h"
#include "message.h"

configuration MultiHopC
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

  /* Routing table */
  components new RoutingTableP() as RoutingTable;

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
  BeaconProcessStage.RTable -> RoutingTable;
  
  /* MultiHop recieve msg */
  components new RecieveMessageStage(MultihopMsg, AM_MULTIHOP_MSG) as MultiHopRecieveMessageStage;
  components new MultihopProcessStage() as MultihopProcessStage;
  components new SendStage(PIXIE_PRIORITY_NORM, TOS_BCAST_ADDR, MultihopMsg, AM_Multihop_MSG) as MultihopProcessSendStage; 
  
  MultihopRecieveMessageStage.Output -> MultihopProcessStage.Input;
  MultihopProcessStage.Output -> MultihopProcessSendStage.Input;


  /* Multihop take sample and send packet*/
  components new TimerStage(10000) as MultihopTXTimerStage;
  components new TSRSensorStage(PIXIE_PRIORITY_NORM);
  components new MultihopFactoryStage() as MultihopFactoryStage;
  components new SendStage(PIXIE_PRIORITY_NORM, TOS_BCAST_ADDR, MultihopMsg, AM_MULTIHOP_MSG) as MultihopFactorySendStage;

  MultihopTXTimerStage.Output -> TSRSensorStage.Input;
  TSRSensorStage.Output -> MultihopFactoryStage.Input;
  MultihopFactoryStage.Output -> MultihopFactorySendStage.Input;

}

