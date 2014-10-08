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


const static midi_drum_map midi_drum_map_set[61] = {
/* Map= 0x80 sample unavailable */
{27,"(Midi Level 2) High Q", 0x80},
{28,"(Midi Level 2) Slap", 0x80 },
{29,"(Midi Level 2) Scratch", 0x80},
{30,"(Midi Level 2) Scratch", 0x80},
{31,"(Midi Level 2) Sticks", 0x80},
{32,"(Midi Level 2) Square", 0x80},
{33,"(Midi Level 2) Metronome", 0x80},
{34,"(Midi Level 2) Metronome", 0x80},
{35,"Bass Drum 2", 0x0 },
{36,"Bass Drum 1", 0x1 },
{37,"Side Stick/Rimshot", 0x2},
{38,"Snare Drum 1", 0x3},
{39,"Hand Clap", 0x4},
{40,"Snare Drum 2", 0x5},
{41,"Low Tom 2",0x6},
{42,"Closed Hi-hat",0x7},
{43,"Low Tom 1", 0x8},
{44,"Pedal Hi-hat",0x9},
{45,"Mid Tom 2",0xA},
{46,"Open Hi-hat",0xB},
{47,"Mid Tom 1",0xC},
{48,"High Tom 2",0xD},
{49,"Crash Cymbal 1",0xE},
{50,"High Tom 1",0xF},
{51,"Ride Cymbal 1",0x80},
{52,"Chinese Cymbal",0x80},
{53,"Ride Bell",0x80},
{54,"Tambourine",0x80},
{55,"Splash Cymbal",0x80},
{56,"Cowbell",0x80},
{57,"Crash Cymbal 2",0x80},
{58,"Vibra Slap",0x80},
{59,"Ride Cymbal 2",0x80},
{60,"High Bongo",0x80},
{61,"Low Bongo",0x80},
{62,"Mute High Conga",0x80},
{63,"Open High Conga",0x80},
{64,"Low Conga",0x80},
{65,"High Timbale",0x80},
{66,"Low Timbale",0x80},
{67,"High Agogô",0x80},
{68,"Low Agogô",0x80},
{69,"Cabasa",0x80},
{70,"Maracas",0x80},
{71,"Short Whistle",0x80},
{72,"Long Whistle",0x80},
{73,"Short Güiro",0x80},
{74,"Long Güiro",0x80},
{75,"Claves",0x80},
{76,"High Wood Block",0x80},
{77,"Low Wood Block",0x80},
{78,"Mute Cuíca",0x80},
{79,"Open Cuíca",0x80},
{80,"Mute Triangle",0x80},
{81,"Open Triangle",0x80},

{82,"(Midi Level 2) Shaker",0x80},
{83,"(Midi Level 2) Jingle Bell",0x80},
{84,"(Midi Level 2) Belltree",0x80},
{85,"(Midi Level 2) Castanets",0x80},
{86,"(Midi Level 2) Mute Surdo",0x80},
{87,"(Midi Level 2) Open Surdo ",0x80}




};


uint8_t tune::translate_drum(uint8_t note) {
  printf("%i translate to %i\n",note,note-27);
  return midi_drum_map_set[note-27].map;
}
