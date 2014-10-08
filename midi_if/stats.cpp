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
  note_channel9.clear();
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

  if (channel == 9) {
    note_channel9.insert(note);
  }
}

void stats::note_off(uint8_t channel,uint8_t note) {
  sound[channel].remove(note);
}

void stats::display_note_channel9() {
  set<uint8_t>::iterator it = note_channel9.begin();

  printf("number of drum sample : %ld\n",note_channel9.size());
  while( it !=note_channel9.end() ) {
    printf("%i : %s\n", *it, midi_drum_data_set[*it-27].drum_name.c_str());    

    it++; 
  }

}

const midi_drum stats::midi_drum_data_set[61] = {

{27,"(Midi Level 2) High Q"},
{28,"(Midi Level 2) Slap"},
{29,"(Midi Level 2) Scratch"},
{30,"(Midi Level 2) Scratch"},
{31,"(Midi Level 2) Sticks"},
{32,"(Midi Level 2) Square"},
{33,"(Midi Level 2) Metronome"},
{34,"(Midi Level 2) Metronome"},

	


{35,"Bass Drum 2"},
{36,"Bass Drum 1"},
{37,"Side Stick/Rimshot"},
{38,"Snare Drum 1"},
{39,"Hand Clap"},
{40,"Snare Drum 2"},
{41,"Low Tom 2"},
{42,"Closed Hi-hat"},
{43,"Low Tom 1"},
{44,"Pedal Hi-hat"},
{45,"Mid Tom 2"},
{46,"Open Hi-hat"},
{47,"Mid Tom 1"},
{48,"High Tom 2"},
{49,"Crash Cymbal 1"},
{50,"High Tom 1"},
{51,"Ride Cymbal 1"},
{52,"Chinese Cymbal"},
{53,"Ride Bell"},
{54,"Tambourine"},
{55,"Splash Cymbal"},
{56,"Cowbell"},
{57,"Crash Cymbal 2"},
{58,"Vibra Slap"},
{59,"Ride Cymbal 2"},
{60,"High Bongo"},
{61,"Low Bongo"},
{62,"Mute High Conga"},
{63,"Open High Conga"},
{64,"Low Conga"},
{65,"High Timbale"},
{66,"Low Timbale"},
{67,"High Agogô"},
{68,"Low Agogô"},
{69,"Cabasa"},
{70,"Maracas"},
{71,"Short Whistle"},
{72,"Long Whistle"},
{73,"Short Güiro"},
{74,"Long Güiro"},
{75,"Claves"},
{76,"High Wood Block"},
{77,"Low Wood Block"},
{78,"Mute Cuíca"},
{79,"Open Cuíca"},
{80,"Mute Triangle"},
{81,"Open Triangle"},

{82,"(Midi Level 2) Shaker"},
{83,"(Midi Level 2) Jingle Bell"},
{84,"(Midi Level 2) Belltree"},
{85,"(Midi Level 2) Castanets"},
{86,"(Midi Level 2) Mute Surdo"},
{87,"(Midi Level 2) Open Surdo "}




};

