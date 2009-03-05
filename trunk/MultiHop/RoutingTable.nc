#include "MultiHop.h"

generic module RoutingTable() {
  provides interface RoutingTable;
  provides interface Init;
} implementation {

  uint16_t node_id[ROUTING_TABLE_SIZE];
  uint16_t tree_depth[ROUTING_TABLE_SIZE];
  uint8_t lqi[ROUTING_TABLE_SIZE];
  uint8_t score[ROUTING_TABLE_SIZE];

  uint16_t current_parent;
  uint16_t current_treedepth;

  command error_t Init.init(){
    int i;
    for(i = 0; i < ROUTING_TABLE_SIZE; i++){
      node_id[i] = 0;
      tree_depth[i] = 0;
      lqi[i] = 0;
      score[i] = 0;
    }
    current_parent = 0;
    current_treedepth = 0;
    
    return SUCCESS;
  }

  async command uint16_t RoutingTable.getCurrentParent() {
    return current_parent;   
  }

  async command uint16_t RoutingTable.getCurrentTreeDepth() {
    return current_treedepth;
  }
  
  //Calculate score. Should probably change to something better
  uint8_t calculateScore(uint16_t treedepth, uint8_t lqi_in) {
    return (lqi_in - treedepth);
  }

  void changeParent(){
    uint8_t best_parent_index = 0;
    uint8_t max_score = 0;
    int i;

    for (i = 0; i < ROUTING_TABLE_SIZE; i++) {
      if (score[i] > max_score) {
	best_parent_index = i;
	max_score = score[i];
      }
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
    if (treedepth > current_treedepth){
      return;
    }
    
    //Calculate node score
    node_score = calculateScore(treedepth, lqi_in);
    
    
    //Look if node is in table already
    
    for (i = 0; i < ROUTING_TABLE_SIZE; i++) {
      if (node_id[i] == id){
        is_in_table = 1;
      	tree_depth[i] = treedepth;
	lqi[i] = lqi_in; 
        score[i] = node_score;
      }
    }      
    

    //Insert into table. evict the node with the lowest score
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
    
    //Make parent decision
    changeParent();
  }
  
}
