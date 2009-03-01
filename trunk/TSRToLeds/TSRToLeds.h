#ifndef TSR_TO_LEDS_H
#define TSR_TO_LEDS_H

typedef nx_struct tsr_leds_msg {
  nx_uint8_t led_mask;
  nx_uint8_t on;
} tsr_leds_msg_t;

enum {
  AM_TSR_LEDS_MSG = 6,
};

#endif
