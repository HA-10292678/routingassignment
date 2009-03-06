#ifndef CS263_MULTIHOP_H
#define CS263_MULTIHOP_H

#define ROOT_ID 0
#define ROUTING_TABLE_SIZE 10

enum {
  AM_MULTIHOP_MSG = 42,
  AM_BEACON_MSG = 43
};

/* The message fields have the following semantics:
 *
 * source - TOS_NODE_ID of the source node producing the sensor reading
 * 
 * seqnum - the sequence number for this packet. These should start at 0
 * and increase by 1 for each data packet sent by the mote.
 *
 * treedepth - the current depth of the sender in the routing tree.
 *
 * data - the current sensor value of the light sensor.
 */
typedef struct MultihopMsg {
  nx_uint16_t source;
  nx_uint32_t seqnum;
  nx_uint16_t treedepth;
  nx_uint16_t data;
} MultihopMsg;

typedef struct BeaconMsg {
  nx_uint16_t source;
  nx_uint16_t treedepth;
  nx_uint32_t seqnum;
} BeaconMsg;
#endif
