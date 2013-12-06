#ifndef _STATS_H_
#define _STATS_H_


#include <list>
#include <set>
#include <stdint.h>
#include <string>
#include<stdio.h>
#define CHANNEL_NB 16

using namespace std;

struct midi_drum  {
  const uint8_t note;
  const string drum_name;
}  ;



class stats {

  private :
    list<uint8_t> sound[16];
    set<uint8_t> note_channel9;

    static const midi_drum midi_drum_data_set[61]; 


  
  public : 
    uint32_t note_channel_max[16];
    uint32_t all_channel;
    
    stats();
    ~stats();
    void reset();
    void note_on(uint8_t channel, uint8_t note);
    void note_off(uint8_t channel, uint8_t note);
    void display_note_channel9();
    
};




#endif
