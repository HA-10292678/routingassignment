interface RoutingTable {

  async command uint16_t getCurrentParent();

  async command uint16_t getCurrentTreeDepth();

  async command void insertNode(uint16_t id, uint16_t treedepth, uint8_t lqi_in);
  async command uint32_t getCurrentSeqnum();

  async command uint32_t getMaxBeaconSeqnum();

  async command void setMaxBeaconSeqnum(uint32_t seqnum);
}
