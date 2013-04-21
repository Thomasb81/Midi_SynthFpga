#ifndef _TUNE_H_
#define _TUNE_H_

#include <stdint.h>
#include "serialib.h"

#define MAX_TUNE 128

#define SYNTH_MIDI0 0
#define SYNTH_MIDI1 1
#define SYNTH_MIDI2 2
#define SYNTH_MIDI3 3



using namespace std;

class key {
  
  public:
    uint8_t _channel;
    uint8_t _note;

  public:
    key() {
      _channel = 1<<7;
      _note =  1<<7;
    }
    key(uint8_t channel, uint8_t note): _channel(channel), _note(note){};
    ~key(){};
    
    inline bool operator== (const key& a) {
      return (_channel == a._channel) && (_note == a._note);
    };

    inline bool operator != (const key& a) {
      return (_channel != a._channel) || (_note != a._note);
    };

};

class tune {

  private:
    key _data[MAX_TUNE];
    uint16_t _cpt_add;

  public:
    tune(){
      _cpt_add = 0;
    };
    ~tune(){
    };

    void note_on(uint8_t channel, uint8_t note, uint8_t value);
    void note_off(uint8_t channel, uint8_t note, uint8_t value);
    //uint8_t find_tune (uint8_t channel, uint8_t note);
    void apply_keypress(uint8_t channel, uint8_t note, uint8_t value);
    void apply_channelpress(uint8_t channel, uint8_t value);
   
};

#endif
