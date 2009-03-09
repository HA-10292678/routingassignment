#include "printf.h"
#include "Pixie.h"
#include "MultiHop.h"

generic module BeaconProcessStageP() {
  provides interface PixieStage;
  uses interface PixieSink;
  uses interface PixieMemAlloc;
  uses interface CC2420Packet;
  uses interface Packet;
  uses interface RoutingTable;
  uses interface Leds;

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
      uint32_t max_seq_num;

      //If i'm the root, don't process beacons
      if (TOS_NODE_ID == ROOT_ID) {
	call PixieMemAlloc.release(ref);
	return SUCCESS;
      } else {
      
	receivedMessage = (message_t*) call PixieMemAlloc.data(ref);	
	receivedBeacon = (BeaconMsg*) call Packet.getPayload(receivedMessage, sizeof(BeaconMsg));
	
	max_seq_num = call RoutingTable.getMaxBeaconSeqnum();

	if ((receivedBeacon->seqnum) <= max_seq_num){
	  call PixieMemAlloc.release(ref);
	  return SUCCESS;
	}

	//Set max seqnum
	call RoutingTable.setMaxBeaconSeqnum(receivedBeacon->seqnum);
	
	newMR = call PixieMemAlloc.allocate(sizeof(BeaconMsg));
	newBeacon = (BeaconMsg*) call PixieMemAlloc.data(newMR);
	
	
	//Access signal strength
	lqi = call CC2420Packet.getLqi(receivedMessage);
	//printf("ID: %d, BeaconProcessStageP, lqi: %d\n", TOS_NODE_ID, lqi);
	
	//Access treedepth and id
	treedepth = receivedBeacon->treedepth;
	source = receivedBeacon->source;
	printf("Recieved a beacon from: %d, with treedepth: %d, and seqnum: %d\n", source, treedepth, (receivedBeacon->seqnum));
	
	//store in table (also chooses parent)
	call RoutingTable.insertNode(source, treedepth, lqi);
	
	//create new beacon message
	current_parent = call RoutingTable.getCurrentParent();
	current_treedepth = call RoutingTable.getCurrentTreeDepth();
	
	newBeacon->source = current_parent;
	newBeacon->treedepth = current_treedepth;
	newBeacon->seqnum = receivedBeacon->seqnum;

	//printf("ID: %d, BeaconProcessStageP, new_source: %d, new_treedepth: %d, new parent %d \n", TOS_NODE_ID, newBeacon->source, newBeacon->treedepth, current_parent);
	call Leds.set(current_treedepth & 0xFF);
	
	//send it off
	printfflush();
	call PixieSink.enqueue(newMR);
	call PixieMemAlloc.release(newMR);
	call PixieMemAlloc.release(ref);
	return SUCCESS;

      }

    }
  }


}
