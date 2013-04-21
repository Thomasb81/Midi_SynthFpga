#include <math.h>
#include <stdio.h>
#include <stdint.h>

#define INIT_LINE_SIZE 64

int main () {

  double midi[128];
  uint32_t midi2[1024];

  for (int x = 0; x < 128; x++)
  {
    midi[x] = pow(2.0,(x-9) / 12.0)*440/32;
  }

  
  for (int x = 0; x < 128; ++x) {
    double value = ceil(midi[x]*pow(2,19)/48000);
      midi2[x] = (uint64_t) value;
  }
  for (int x = 128; x < 1024; ++x) {
    midi2[x] = 0;
  }

#if 0  
  for (int x = 0; x < 128; x++) {
    printf("%i %f %d 0x%05x\n",x,midi[x], midi2[x], midi2[x] );
  }
#endif

  int offset;

  printf("RAMB16_S18_inst : RAMB16_S18\n");
  printf("   generic map (\n");
  printf("      INIT => X\"000\",\n");
  printf("      SRVAL => X\"000\",\n");

  offset = 0;
  while(offset < sizeof(midi2)/sizeof(int))
  {
    int i = INIT_LINE_SIZE/4;
    printf("      INIT_%02X => X\"", offset / (INIT_LINE_SIZE / 4));
    while( i > 0)
    {
      i--;
      printf("%04x",midi2[offset+i]&0xFFFF);
    }
    printf("\",\n");
    offset += INIT_LINE_SIZE / 4;
  }

  offset=0;
  while(offset < sizeof(midi2)/sizeof(int))
  {
    int i = INIT_LINE_SIZE;
    printf("      INITP_%02X => X\"", offset / (INIT_LINE_SIZE*2));
    while( i > 0)
    {
      int d;
      i--;
      d =  ((midi2[offset+i*2+0]>>16)&0x03) | ((midi2[offset+i*2+1]>>14)&0x0C);
      printf("%01x",d);
    }
    printf("\",\n");
    offset += INIT_LINE_SIZE *2;
  }

  printf("      WRITE_MODE => \"WRITE_FIRST\")\n");
  printf("   port map (\n");
  printf("      DO   => DO,   -- 16-bit Data Output\n");
  printf("      DOP  => DOP,  -- 2-bit parity Output\n");
  printf("      ADDR => ADDR, -- 10-bit Address Input\n");
  printf("      CLK  => CLK,  -- Clock\n");
  printf("      DI   => DI,   -- 16-bit Data Input\n");
  printf("      DIP  => DIP,  -- 2-bit parity Input\n");
  printf("      EN   => EN,   -- RAM Enable Input\n");
  printf("      SSR  => SSR,  -- Synchronous Set/Reset Input\n");
  printf("      WE   => WE    -- Write Enable Input\n");
  printf("   );\n");
  return 0;


}
