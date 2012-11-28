#include "stats.h"

stats::stats() {
  reset();
}

stats::~stats() {
  
}

void stats::reset() {
  for(uint8_t i=0; i < CHANNEL_NB; i++) {
    note_channel_max[i] = 0;
    sound[i].clear();
  }
  all_channel = 0;
}

void stats::note_on(uint8_t channel,uint8_t note) {
  sound[channel].push_back(note);
  if (sound[channel].size() > note_channel_max[channel]) {
    note_channel_max[channel] = sound[channel].size();
  }
  uint32_t tmp =0;
  for (uint8_t i =0; i < CHANNEL_NB ; i++) {
    tmp += sound[i].size();
  }
  if (tmp > all_channel ) {
    all_channel = tmp;
  }


}

void stats::note_off(uint8_t channel,uint8_t note) {
  sound[channel].remove(note);
}
