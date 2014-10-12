#include "tune.h"

#include <stdio.h>

extern serialib ttyusb1;
char buffer[7];

const key none(1<<7,1<<7);

void tune::note_on(uint8_t channel, uint8_t note, uint8_t value, uint32_t timestamp, uint32_t duration) {
  key new_key(channel,note,key::NOTE_ON,timestamp+duration);
  uint16_t i=0;


  _cpt_add = 0;
  while(i<MAX_TUNE) {

    // If we found the same note and channel but that have already received a note off
    if ( _data[_cpt_add%MAX_TUNE] == new_key && _data[_cpt_add%MAX_TUNE]._status != key::NOTE_ON ) {
      _data[_cpt_add%MAX_TUNE] = new_key;
      buffer[SYNTH_MIDI0] = (uint8_t) (0x9 << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = _cpt_add%MAX_TUNE;
      buffer[SYNTH_MIDI2] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI3] = (uint8_t) value & 0x7f;
      if (channel == 9) {
        buffer[SYNTH_MIDI2] = translate_drum(note);
	
        if (buffer[SYNTH_MIDI2] == 0x80 ) {
	  printf("Drum note %d do not exist : ignored\n",note);
          // sample do not exist. So finally mark it as note off
          _data[_cpt_add%MAX_TUNE]._status = key::NOTE_OFF;
          // Nothing is send.
          return;
        }
      }
//      if (new_key == _filter) {
        printf("@ note on(bis) 0x%02x  0x%02x 0x%02x 0x%02x \n", (uint8_t) buffer[SYNTH_MIDI0],
                                                            (uint8_t) buffer[SYNTH_MIDI1],
                                                            (uint8_t) buffer[SYNTH_MIDI2],
                                                            (uint8_t) buffer[SYNTH_MIDI3] );
//      }
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      return;
    }
    _cpt_add++;
    i++;
  }
  // If we don't find any thing, we are looking for the first place free.
  i=0;
  _cpt_add = 0;
  while(i<MAX_TUNE) {

    if ( _data[_cpt_add%MAX_TUNE] == none ) {
      _data[_cpt_add%MAX_TUNE] = new_key;
      buffer[SYNTH_MIDI0] = (uint8_t) (0x9 << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = _cpt_add%MAX_TUNE;
      buffer[SYNTH_MIDI2] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI3] = (uint8_t) value & 0x7f;
      if (channel == 9) {
        buffer[SYNTH_MIDI2] = translate_drum(note);
        if (buffer[SYNTH_MIDI2] == 0x80) {
          // sample do not exist. So finally mark it as note off
          _data[_cpt_add%MAX_TUNE]._status = key::NOTE_OFF;
          // Nothing is send.
          return;
        }
      }
//      if (new_key == _filter) {
        printf("@ note on 0x%02x 0x%02x 0x%02x 0x%02x \n", (uint8_t) buffer[SYNTH_MIDI0],
                                                            (uint8_t) buffer[SYNTH_MIDI1],
                                                            (uint8_t) buffer[SYNTH_MIDI2],
                                                            (uint8_t) buffer[SYNTH_MIDI3] );
//      }
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      return;
    }
    _cpt_add++;
    i++;
  }

  printf ("Error do not achive to record a note!\n");
  exit(-1);
  return;
}

void tune::note_off(uint8_t channel, uint8_t note, uint8_t value, uint32_t timestamp) {
  key search_key(channel,note,key::NOTE_OFF,timestamp);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i].identical(search_key) && _data[i]._status == key::NOTE_ON) {
      buffer[SYNTH_MIDI0] = (uint8_t) (0x8 << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = i;
      buffer[SYNTH_MIDI2] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI3] = (uint8_t) value & 0x7f;
      if (search_key == _filter) {
        printf("@ note off 0x%02x 0x%02x 0x%02x 0x%02x \n", (uint8_t) buffer[SYNTH_MIDI0],
                                                            (uint8_t) buffer[SYNTH_MIDI1],
                                                            (uint8_t) buffer[SYNTH_MIDI2],
                                                            (uint8_t) buffer[SYNTH_MIDI3] );
      }
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      _data[i]._status = key::NOTE_OFF;
      
      return ;
    }
    i++;
  }
 
  printf("do not found note: 0x%02x channel: 0x%02x\n",note,channel);
  exit(-1);
 
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
      buffer[1] = i;
      buffer[2] = _data[i]._note;
      buffer[3] = value;
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
    }
    i++;
  }


}

void tune::apply_keypress(uint8_t channel, uint8_t note, uint8_t value) {
  key search_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i] == search_key) {
      
      buffer[SYNTH_MIDI0] = (uint8_t) (0xa << 4) | (channel & 0xf);
      buffer[SYNTH_MIDI1] = i;
      buffer[SYNTH_MIDI2] = (uint8_t) note & 0x7f;
      buffer[SYNTH_MIDI3] = (uint8_t) value & 0x7f;
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
      
      return ;
    }
    i++;
  }
  return ; // dirty !
} 

void tune::apply_pitchbender(uint8_t channel, int16_t value) {

  uint16_t local_value = value + 0x2000;
  buffer[SYNTH_MIDI0] = (uint8_t) (0xe << 4) | (channel & 0xf);
  buffer[SYNTH_MIDI1] = 0;
  buffer[SYNTH_MIDI2] = (uint8_t) (local_value>>8);
  buffer[SYNTH_MIDI3] = (uint8_t) (local_value);
//  printf("%02x %02x %02x %02x\n", 
//  (uint8_t) buffer[SYNTH_MIDI0],
//  (uint8_t) buffer[SYNTH_MIDI1],
//  (uint8_t) buffer[SYNTH_MIDI2],
//  (uint8_t) buffer[SYNTH_MIDI3]
//  );
  if (channel != 9) {
      ttyusb1.Write(&(buffer[SYNTH_MIDI0]),4);
  }
}
void tune::remove(uint8_t addr) {
  // If we get a response. We must check that we are still waiting it.
  // Because is we had reuse the key for a new tune, we will got missing keys
  if (_data[addr]._status == key::NOTE_OFF) {
    printf ("@ return: 0x%02x\n", addr );
    _data[addr] = none;
  } 
  else {
    printf ("@ return: 0x%02x (but ignored)\n", addr );
  }
}

void tune::set_filter(uint8_t channel, uint8_t note) {
  _filter._channel = channel;
  _filter._note = note; 
}

void tune::check_for_note_on() {
  uint16_t i =0;
  while (i< MAX_TUNE) {
    if (_data[i] != none && _data[i]._status == key::NOTE_ON) {
      printf(" still on : channel : 0x%02x note 0x%02x at address 0x%02x\n",_data[i]._channel, _data[i]._note,i);
    }
    i++;
  }
}


uint8_t tune::translate_drum(uint8_t note) {
  return midi_drum_map_set[note].map;
}
