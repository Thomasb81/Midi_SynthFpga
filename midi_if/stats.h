#ifndef _STATS_H_
#define _STATS_H_


#include <list>
#include <stdint.h>

#define CHANNEL_NB 16

using namespace std;

class stats {

  private :
    list<uint8_t> sound[16];
  
  public : 
    uint32_t note_channel_max[16];
    uint32_t all_channel;
    
    stats();
    ~stats();
    void reset();
    void note_on(uint8_t channel, uint8_t note);
    void note_off(uint8_t channel, uint8_t note);
    
};




#endif
