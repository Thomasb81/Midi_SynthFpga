#ifndef _DRUM_H_
#define _DRUM_H_

#include <string>

struct midi_drum_map {
  const uint8_t note;
  const std::string drum_name;
  const uint8_t map;
};

extern const midi_drum_map midi_drum_map_set[128];

#endif
