
CCFLAGS = -Wall -g
INC = -Iserialib/
LDFLAGS = -lasound


all : midi_papilio_if

midi_papilio_if : midi_papilio_if.o serialib.o stats.o tune.o
	g++ -o $@ $(INC) $(CCFLAGS) $^ $(LDFLAGS) 

%.o : %.cpp 
	g++ -o $@ $(CCFLAGS) $(INC) -c $<  

%.o : %.c
	g++ -o $@ $(CCFLAGS) $(INC) -c $<  

%.o : serialib/%.cpp
	g++ -o $@ $(CCFLAGS) $(INC) -c $^  

compute_freq : compute_freq.c
	gcc -o compute_freq -std=gnu99 -Wall -g compute_freq.c  -lm

clean :
	rm -rf *.o midi_papilio_if compute_freq
