#include <math.h>
#include <stdio.h>
#include <stdint.h>

/*
http://en.wikipedia.org/wiki/Note
http://subsynth.sourceforge.net/midinote2freq.html

*/

int main () {

  double midi[1024];
  uint32_t midi2[1024];

  for (int x = 0; x < 1024; x++)
  {
    midi[x] = pow(2.0,(x+24) / (12.0*8))*440/(32*2);
  }

  
  for (int x = 0; x < 1024; ++x) {
    double value = ceil(midi[x]*pow(2,19)/48000);
      midi2[x] = (uint64_t) value;
  }

  for (int x = 0; x < 1024; x++) {
    printf("%i %f %d 0x%05x\n",x,midi[x], midi2[x], midi2[x] );
  }

  return 0;

}
