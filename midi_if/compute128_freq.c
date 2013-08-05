#include <math.h>
#include <stdio.h>
#include <stdint.h>

/*
http://en.wikipedia.org/wiki/Note
http://subsynth.sourceforge.net/midinote2freq.html

*/

int main () {

  double midi[128];
  uint32_t midi2[128];

  for (int x = 0; x < 128; x++)
  {
    midi[x] = pow(2.0,(x-9) / (12.0))*440/(32);
  }

  
  for (int x = 0; x < 128; ++x) {
    double value = ceil(midi[x]*pow(2,19)/48000);
      midi2[x] = (uint64_t) value;
  }

  for (int x = 0; x < 128; x++) {
    printf("%i %f %d 0x%05x\n",x,midi[x], midi2[x], midi2[x] );
  }

  return 0;

}
