#include "tune.h"

#include <stdio.h>

extern serialib ttyusb1;
char buffer[7];

const key none(1<<7,1<<7);

void tune::note_on(uint8_t channel, uint8_t note, uint8_t value) {
  key new_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {

    if ( _data[_cpt_add%MAX_TUNE] == none) {
      _data[_cpt_add%MAX_TUNE] = new_key;
      buffer[SYNTH_MIDI0] = (uint8_t) (0x9 << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI2] = (uint8_t) value & 0x7f;
      buffer[SYNTH_MIDI3] = _cpt_add%MAX_TUNE;
      if (channel != 9) {
          ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      }

      return ;
    }
    _cpt_add++;
    i++;
  }
  return;
}

void tune::note_off(uint8_t channel, uint8_t note, uint8_t value) {
  key search_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i] == search_key) {
      _data[i] = none;
      buffer[SYNTH_MIDI0] = (uint8_t) (0x8 << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI2] = (uint8_t) value & 0x7f;
      buffer[SYNTH_MIDI3] = i;
      if (channel != 9) {
          ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      }
      
      return ;
    }
    i++;
  }
  return ; // dirty !
} 
/*
uint8_t tune::find_tune(uint8_t channel, uint8_t note) {
  key search_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i] == search_key) {
      return i;
    }
    i++;
  }
  return 0; // dirty !
} 
*/
void tune::apply_channelpress(uint8_t channel, uint8_t value) {

  uint16_t i=0;
  uint8_t buffer[4];

  while(i<MAX_TUNE) {
    if (_data[i]._channel == channel) {
      buffer[0] = (uint8_t) (0xa<<4) | channel;
      buffer[1] = _data[i]._note;
      buffer[2] = value;
      buffer[3] = i;
      if (channel != 9) {
          ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      }
      ;
    }
    i++;
  }


}

void tune::apply_keypress(uint8_t channel, uint8_t note, uint8_t value) {
  key search_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i] == search_key) {
      _data[i] = none;
      buffer[SYNTH_MIDI0] = (uint8_t) (0xa << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI2] = (uint8_t) value & 0x7f;
      buffer[SYNTH_MIDI3] = i;
      if (channel != 9) {
          ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      }
      
      return ;
    }
    i++;
  }
  return ; // dirty !
} 

void tune::apply_pitchbender(uint8_t channel, int16_t value) {

  uint16_t local_value = value + 0x2000;
  buffer[SYNTH_MIDI0] = (uint8_t) (0xe << 4) | (channel & 0xf);
  buffer[SYNTH_MIDI1] = (uint8_t) (local_value>>8);
  buffer[SYNTH_MIDI2] = (uint8_t) (local_value);
  buffer[SYNTH_MIDI3] = 0;
  printf("%02x %02x %02x %02x\n", 
  (uint8_t) buffer[SYNTH_MIDI0],
  (uint8_t) buffer[SYNTH_MIDI1],
  (uint8_t) buffer[SYNTH_MIDI2],
  (uint8_t) buffer[SYNTH_MIDI3]
  );
  if (channel != 9) {
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
  }
}
