
CCFLAGS = -Wall -g
INC = -Iserialib/
LDFLAGS = -lasound


all : midi_papilio_if

midi_papilio_if : midi_papilio_if.o serialib.o stats.o
	g++ -o $@ $(INC) $(CCFLAGS) $^ $(LDFLAGS) 

%.o : %.cpp 
	g++ -o $@ $(CCFLAGS) $(INC) -c $<  

%.o : %.c
	g++ -o $@ $(CCFLAGS) $(INC) -c $<  

%.o : serialib/%.cpp
	g++ -o $@ $(CCFLAGS) $(INC) -c $^  

clean :
	rm -rf *.o midi_papilio_if
