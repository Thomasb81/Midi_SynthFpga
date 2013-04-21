#include "tune.h"

const key none(1<<7,1<<7);

uint8_t tune::add_tune(uint8_t channel, uint8_t note) {
  key new_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {

    if ( _data[_cpt_add%MAX_TUNE] == none) {
      _data[_cpt_add%MAX_TUNE] = new_key;
      return _cpt_add%MAX_TUNE;
    }
    _cpt_add++;
    i++;
  }
  return 0; // dirty !
}

uint8_t tune::remove_tune(uint8_t channel, uint8_t note) {
  key search_key(channel,note);
  uint16_t i=0;

  while(i<MAX_TUNE) {
    if (_data[i] == search_key) {
      _data[i] = none;
      return i;
    }
    i++;
  }
  return 0; // dirty !
} 
