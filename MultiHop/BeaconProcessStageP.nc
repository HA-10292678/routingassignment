#include "Pixie.h"
#include "MultiHop.h"

generic module BeaconProcessStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
  uses interface CC2420Packet;
  uses interface Packet;
  uses interface RoutingTable;

} implementation {
  
  command error_t PixieStage.init() {
    return SUCCESS;
  }

  command error_t PixieStage.run(memref_t ref) {
    if (ref == PIXIE_NULL_MEMREF) {
      return FAIL;
    } else {
      
      memref_t newMR;
      BeaconMsg* newBeacon;
      message_t* receivedMessage;
      BeaconMsg* receivedBeacon;
      uint8_t lqi;
      uint16_t treedepth;
      uint16_t source;
      uint16_t current_parent;
      uint16_t current_treedepth;
      
      receivedMessage = (message_t*) call PixieMemAlloc.data(ref);	
      receivedBeacon = (BeaconMsg*) call Packet.getPayload(receivedMessage, sizeof(BeaconMsg));
      
      newMR = call PixieMemAlloc.allocate(sizeof(BeaconMsg));
      newBeacon = (BeaconMsg*) call PixieMemAlloc.data(newMR);
      
      
      //Access signal strength
      lqi = call CC2420Packet.getLqi(receivedMessage);
      
      //Access treedepth and id
      treedepth = receivedBeacon->treedepth;
      source = receivedBeacon->source;
      
      //store in table (also chooses parent)
      call RoutingTable.insertNode(source, treedepth, lqi);
      
      //create new beacon message
      current_parent = call RoutingTable.getCurrentParent();
      current_treedepth = call RoutingTable.getCurrentTreeDepth();
      
      newBeacon->source = current_parent;
      newBeacon->treedepth = current_treedepth;
      
      //send it off
      call PixieSink.enqueue(newMR);
      call PixieMemAlloc.release(newMR);
      call PixieMemAlloc.release(ref);
      return SUCCESS;
    }
  }


}
