#include "MultiHop.h"

module RoutingTableP {
  provides interface RoutingTable;
  uses interface Boot;
} implementation {

  uint16_t node_id[ROUTING_TABLE_SIZE];
  uint16_t tree_depth[ROUTING_TABLE_SIZE];
  uint8_t lqi[ROUTING_TABLE_SIZE];
  uint8_t score[ROUTING_TABLE_SIZE];

  uint16_t current_parent;
  uint16_t current_treedepth;
  uint32_t current_seqnum; 
  uint32_t max_beacon_seqnum;

  event void Boot.booted(){
    int i;
    atomic {
      for(i = 0; i < ROUTING_TABLE_SIZE; i++){
	node_id[i] = 0;
	tree_depth[i] = 0;
	lqi[i] = 0;
	score[i] = 0;
      }
      current_parent = 0;
      current_treedepth = -1;
      current_seqnum = 0;    
      max_beacon_seqnum = 0;
    }
    
  }
  async command uint16_t RoutingTable.getCurrentParent() {
    atomic {
      return current_parent;   
    }  
  }
  
  async command uint32_t RoutingTable.getCurrentSeqnum() {
    atomic {
      current_seqnum = current_seqnum + 1;
      return current_seqnum;
    }  
  }

  async command uint32_t RoutingTable.getMaxBeaconSeqnum() {
    atomic {
      return max_beacon_seqnum;
    }  
  }

  async command void RoutingTable.setMaxBeaconSeqnum(uint32_t seqnum) {
    atomic {
      if (seqnum > max_beacon_seqnum){
	max_beacon_seqnum = seqnum;
      }
    }
  }
  async command uint16_t RoutingTable.getCurrentTreeDepth() {
    atomic {
      return current_treedepth;
    }  
  }
  
  uint8_t calculateScore(uint16_t treedepth, uint8_t lqi_in) {
    return (lqi_in - treedepth);
  }

  void changeParent(){
    uint8_t best_parent_index = 0;
    uint8_t max_score = 0;
    int i;
    //printf("Current Routing Table is:\n");
    atomic {
      for (i = 0; i < ROUTING_TABLE_SIZE; i++) {
	//printf("NodeID: %d has score of %d",node_id[i],score[i]);
	if (score[i] > max_score) {
	  best_parent_index = i;
	  max_score = score[i];

	}
      }
    //printfflush();
    }
    atomic {
      current_parent = node_id[best_parent_index];
      current_treedepth = tree_depth[best_parent_index] + 1;
    }
  }
  
  async command void RoutingTable.insertNode(uint16_t id, uint16_t treedepth, uint8_t lqi_in) {
    
    uint8_t node_score;
    int i;
    bool is_in_table = 0;
    uint8_t min_score = 255;
    uint16_t min_score_index = 0;
    
    //This will avoid loops
    atomic {
      if ((treedepth >= current_treedepth)&&(current_treedepth > 0)){
	return;
      }
    }    

    //Calculate node score
    atomic {
      node_score = calculateScore(treedepth, lqi_in);
    }
    
    //Look if node is in table already
    atomic {
      for (i = 0; i < ROUTING_TABLE_SIZE; i++) {
	if (node_id[i] == id){
	  is_in_table = 1;
	  tree_depth[i] = treedepth;
	  lqi[i] = lqi_in; 
	  score[i] = node_score;
	}
      }      
    }

    //Insert into table. evict the node with the lowest score
    atomic {
      if (!is_in_table){
	for (i = 0; i < ROUTING_TABLE_SIZE; i++) {
	  if (score[i] < min_score) {
	    min_score = score[i];
	    min_score_index = i;
	  }
	}
	
	if (node_score > min_score){
	  node_id[min_score_index] = id;
	  score[min_score_index] = node_score;
	  tree_depth[min_score_index] = treedepth;
	  lqi[min_score_index] = lqi_in;
	}
      }
    }
    //Make parent decision
    changeParent();
  }
  
}
