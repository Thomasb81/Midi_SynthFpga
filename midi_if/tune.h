#ifndef _TUNE_H_
#define _TUNE_H_

#include <stdint.h>
#include "serialib.h"
#include "drum.h"

#define MAX_TUNE 128

#define SYNTH_MIDI0 0
#define SYNTH_MIDI1 1
#define SYNTH_MIDI2 2
#define SYNTH_MIDI3 3


using namespace std;

class key {
  
  public:
    enum status_e {
    NOTE_ON,
    NOTE_OFF
    };

    uint8_t _channel;
    uint8_t _note;
    status_e _status; 
    uint32_t _time_stop;

  public:


    key() {
      _channel = 1<<7;
      _note =  1<<7;
      _status = NOTE_OFF;
      _time_stop = 0;
    }
    key(uint8_t channel, uint8_t note): _channel(channel), _note(note){ _status = NOTE_OFF; _time_stop = 0;};
    key(uint8_t channel, uint8_t note, status_e status, uint32_t time_stop): _channel(channel), _note(note),_status(status),_time_stop(time_stop){};
    ~key(){};
    
    inline bool operator== (const key& a) {
      return (_channel == a._channel) && (_note == a._note) ;
    };

    inline bool operator != (const key& a) {
      return (_channel != a._channel) || (_note != a._note) ;
    };
    
    inline bool identical (const key& a) {
      return (_channel == a._channel) && (_note == a._note) && (_time_stop == a._time_stop);
    };

};

class tune {

  private:
    key _data[MAX_TUNE];
    uint16_t _cpt_add;
    key _filter;


  public:
    tune(){
      _cpt_add = 0;
    };
    ~tune(){
    };

    void note_on(uint8_t channel, uint8_t note, uint8_t value, uint32_t timestamp, uint32_t duration);
    void note_off(uint8_t channel, uint8_t note, uint8_t value, uint32_t timestamp);
    //uint8_t find_tune (uint8_t channel, uint8_t note);
    void apply_keypress(uint8_t channel, uint8_t note, uint8_t value);
    void apply_channelpress(uint8_t channel, uint8_t value);
    void apply_pitchbender(uint8_t channel, int16_t value);
   
    void remove(uint8_t addr);
    void set_filter(uint8_t channel, uint8_t note);
    void check_for_note_on();
    uint8_t translate_drum(uint8_t note);
};



#endif
