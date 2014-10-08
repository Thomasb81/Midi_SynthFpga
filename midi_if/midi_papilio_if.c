/* 
 * Inspirate from http://alsamodular.sourceforge.net/seqdemo.c
 * seqdemo.c by Matthias Nagorni */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <alsa/asoundlib.h>
#include <stdint.h>

#include "serialib.h"
#include "stats.h"
#include "tune.h"





//#define FPRINTF_MIDI_EVENT(...) fprintf(stdout,__VA_ARGS__)
#define FPRINTF_MIDI_EVENT(...) 


serialib ttyusb1;


stats db;
tune db_tune;
uint8_t read_buff[256];

void printf_m(char * buf) {
//  fprintf(stdout,"## begin ##\n");
//  for (uint8_t i=0; i<7; i++) { 
//    fprintf(stdout,"ser.write(struct.pack('B',0x%02x))\n",(uint8_t) (0xff & buf[i]));
//  }
//  fprintf(stdout,"## end ##\n");
}




snd_seq_t *open_seq();
void midi_action(snd_seq_t *seq_handle);

snd_seq_t *open_seq() {

  snd_seq_t *seq_handle;
  int portid;

  if (snd_seq_open(&seq_handle, "default", SND_SEQ_OPEN_INPUT, 0) < 0) {
    fprintf(stdout, "Error opening ALSA sequencer.\n");
    exit(1);
  }
  snd_seq_set_client_name(seq_handle, "ALSA midi papilio interface");
  if ((portid = snd_seq_create_simple_port(seq_handle, "ALSA midi papilio interface",
            SND_SEQ_PORT_CAP_WRITE|SND_SEQ_PORT_CAP_SUBS_WRITE,
            SND_SEQ_PORT_TYPE_APPLICATION)) < 0) {
    fprintf(stdout, "Error creating sequencer port.\n");
    exit(1);
  }
  return(seq_handle);
}

void midi_action(snd_seq_t *seq_handle) {

  snd_seq_event_t *ev;

  do {
    snd_seq_event_input(seq_handle, &ev);
    switch (ev->flags & SND_SEQ_TIME_STAMP_MASK) {
	case SND_SEQ_TIME_STAMP_TICK:
		FPRINTF_MIDI_EVENT(", time = %d ticks ",
		       ev->time.tick);
		break;
	case SND_SEQ_TIME_STAMP_REAL:
		FPRINTF_MIDI_EVENT(", time = %d.%09d ",
		       (int)ev->time.time.tv_sec,
		       (int)ev->time.time.tv_nsec);
		break;
	}

    switch (ev->type) {
      case SND_SEQ_EVENT_SYSTEM:
        FPRINTF_MIDI_EVENT("System event on Channel %2d: 0x%8x\n", ev->data.control.channel, ev->data.result.event);
        break;
      case SND_SEQ_EVENT_RESULT:
        FPRINTF_MIDI_EVENT( "result event on Channel %2d: 0x%8x\n",
                ev->data.control.channel, ev->data.result.result);
        break;
      case SND_SEQ_EVENT_NOTE:
        FPRINTF_MIDI_EVENT( "note event on Channel %2d: note channel %2d, note %2d, velocity %2d, off_velocity %2d, duration %d\n",
                ev->data.control.channel, ev->data.note.channel,
                ev->data.note.note, ev->data.note.velocity, 
                ev->data.note.off_velocity, ev->data.note.duration);
        break;
      case SND_SEQ_EVENT_NOTEON:
        FPRINTF_MIDI_EVENT( "note on event on Channel %2d: note channel %2d, note %2d, velocity %2d, off_velocity %2d, duration %d\n",
                ev->data.control.channel, ev->data.note.channel,
                ev->data.note.note, ev->data.note.velocity, 
                ev->data.note.off_velocity, ev->data.note.duration);
        
        db_tune.note_on(ev->data.control.channel,ev->data.note.note,ev->data.note.velocity,
                       ev->time.tick,
                       ev->data.note.duration
                       );
        db.note_on( ev->data.control.channel,ev->data.note.note);
        if (ev->data.control.channel == 9) {
          printf( "note on event on Channel %2d: note channel %2d, note %2d, velocity %2d, off_velocity %2d, duration %d\n",
                ev->data.control.channel, ev->data.note.channel,
                ev->data.note.note, ev->data.note.velocity, 
                ev->data.note.off_velocity, ev->data.note.duration);
        }
        break;        
      case SND_SEQ_EVENT_NOTEOFF: 
        FPRINTF_MIDI_EVENT( "note off event on Channel %2d: note channel %2d, note %2d, velocity %2d, off_velocity %2d, duration %d\n",
                ev->data.control.channel, ev->data.note.channel,
                ev->data.note.note, ev->data.note.velocity, 
                ev->data.note.off_velocity, ev->data.note.duration);
        
        db_tune.note_off(ev->data.control.channel,ev->data.note.note,ev->data.note.velocity,ev->time.tick);
        db.note_off( ev->data.control.channel,ev->data.note.note);
        if (ev->data.control.channel == 9) {
          printf( "note off event on Channel %2d: note channel %2d, note %2d, velocity %2d, off_velocity %2d, duration %d\n",
                ev->data.control.channel, ev->data.note.channel,
                ev->data.note.note, ev->data.note.velocity, 
                ev->data.note.off_velocity, ev->data.note.duration);
        }
        break;        
      case SND_SEQ_EVENT_KEYPRESS:
        FPRINTF_MIDI_EVENT( "keypress event on Channel %2d, note: %5d, velocity %d       \n",
                ev->data.note.channel, ev->data.note.note, ev->data.note.velocity);
        
        db_tune.apply_keypress(ev->data.control.channel,ev->data.note.note,ev->data.note.velocity);
        break;
      case SND_SEQ_EVENT_CONTROLLER: 
        FPRINTF_MIDI_EVENT( "Control event on Channel %2d: %5d       \n",
                ev->data.control.channel, ev->data.control.value);
        break;
      case SND_SEQ_EVENT_PGMCHANGE :
        FPRINTF_MIDI_EVENT( "program change event on Channel %2d: %5d       \n",
                ev->data.control.channel, ev->data.control.value);
      case SND_SEQ_EVENT_CHANPRESS :
        FPRINTF_MIDI_EVENT( "channel pressure change event on Channel %2d: %5d       \n",
                ev->data.control.channel, ev->data.control.value);
        db_tune.apply_channelpress(ev->data.note.channel, ev->data.control.value);
        break;
      case SND_SEQ_EVENT_PITCHBEND:
        FPRINTF_MIDI_EVENT( "Pitchbender event on Channel %2d: %5d   \n", 
                ev->data.control.channel, ev->data.control.value);
        db_tune.apply_pitchbender(ev->data.control.channel, ev->data.control.value);
	break;
      case SND_SEQ_EVENT_CONTROL14 :
        FPRINTF_MIDI_EVENT( "14bit controller event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_NONREGPARAM :
        FPRINTF_MIDI_EVENT( "14bit non reg param event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_REGPARAM :
        FPRINTF_MIDI_EVENT( "14bit reg param event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SONGPOS :
        FPRINTF_MIDI_EVENT( "lsb and msb song position event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SONGSEL :
        FPRINTF_MIDI_EVENT( "Song select with ID number event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_QFRAME :
        FPRINTF_MIDI_EVENT( "midi time code quarter frame event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_TIMESIGN :
        FPRINTF_MIDI_EVENT( "SMF Time Signature event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_KEYSIGN :
        FPRINTF_MIDI_EVENT( "SMF Key Signature event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_START :
        FPRINTF_MIDI_EVENT( "MIDI Real Time Start message event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_CONTINUE :
        FPRINTF_MIDI_EVENT( "MIDI Real Time Continue message event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_STOP :
        FPRINTF_MIDI_EVENT( "MIDI Real Time Stop message event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SETPOS_TICK :
        FPRINTF_MIDI_EVENT( "Set tick queue position event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SETPOS_TIME :
        FPRINTF_MIDI_EVENT( "Set real-time queue position event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_TEMPO :
        FPRINTF_MIDI_EVENT( "(SMF) Tempo event event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_CLOCK :
        FPRINTF_MIDI_EVENT( "MIDI Real Time clock message event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_TICK :
        FPRINTF_MIDI_EVENT( "MIDI Real Time tick message event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_QUEUE_SKEW :
        FPRINTF_MIDI_EVENT( "Queue timer skew event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SYNC_POS :
        FPRINTF_MIDI_EVENT( "Sync position change event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_TUNE_REQUEST :
        FPRINTF_MIDI_EVENT( "Tune request event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_RESET :
        FPRINTF_MIDI_EVENT( "Reset to power-on state event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SENSING :
        FPRINTF_MIDI_EVENT( "Active sensing event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_ECHO :
        FPRINTF_MIDI_EVENT( "Echo-back event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_OSS :
        FPRINTF_MIDI_EVENT( "OSS emulation raw event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_CLIENT_START :
        FPRINTF_MIDI_EVENT( "New client has connect event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_CLIENT_EXIT :
        FPRINTF_MIDI_EVENT( "Client has left the system event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_CLIENT_CHANGE :
        FPRINTF_MIDI_EVENT( "Client status/info has change event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_PORT_START :
        FPRINTF_MIDI_EVENT( "New port was created event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_PORT_EXIT :
        FPRINTF_MIDI_EVENT( "Port was delected from system event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_PORT_CHANGE :
        FPRINTF_MIDI_EVENT( "Port status/info has changed event on Channel %2d\n", 
                ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_PORT_SUBSCRIBED :
        FPRINTF_MIDI_EVENT( "Ports connected event on Channel %2d\n", 
                ev->data.control.channel);
        db.reset();
	break;
      case SND_SEQ_EVENT_PORT_UNSUBSCRIBED :
	FPRINTF_MIDI_EVENT( "Ports disconnected event on Channel %2d\n", 
			ev->data.control.channel);
	for (uint8_t i=0; i<16; i++){
		fprintf(stdout,"channel[%i] max note(%i)\n",
                        i,db.note_channel_max[i]);
	}
        fprintf(stdout,"Max number of note all channel, in the same time : %i\n",db.all_channel);
        db.display_note_channel9();
        db_tune.check_for_note_on();
        
	break;
      case SND_SEQ_EVENT_USR0 :
	FPRINTF_MIDI_EVENT( "USR0 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR1 :
	FPRINTF_MIDI_EVENT( "USR1 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR2 :
	FPRINTF_MIDI_EVENT( "USR2 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR3 :
	FPRINTF_MIDI_EVENT( "USR3 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR4 :
	FPRINTF_MIDI_EVENT( "USR4 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR5 :
	FPRINTF_MIDI_EVENT( "USR5 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR6 :
	FPRINTF_MIDI_EVENT( "USR6 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR7 :
	FPRINTF_MIDI_EVENT( "USR7 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR8 :
	FPRINTF_MIDI_EVENT( "USR8 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR9 :
	FPRINTF_MIDI_EVENT( "USR9 defined event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_SYSEX :
	FPRINTF_MIDI_EVENT( "System exclusive data event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_BOUNCE :
	FPRINTF_MIDI_EVENT( "Error event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR_VAR0 :
	FPRINTF_MIDI_EVENT( "Reserved for user apps0 event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR_VAR1 :
	FPRINTF_MIDI_EVENT( "Reserved for user apps1 event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR_VAR2 :
	FPRINTF_MIDI_EVENT( "Reserved for user apps2 event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR_VAR3 :
	FPRINTF_MIDI_EVENT( "Reserved for user apps3 event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_USR_VAR4 :
	FPRINTF_MIDI_EVENT( "Reserved for user apps4 event on Channel %2d\n", 
			ev->data.control.channel);
	break;
      case SND_SEQ_EVENT_NONE :
	FPRINTF_MIDI_EVENT( "NOP event on Channel %2d\n", 
			ev->data.control.channel);
	break;
    }
    snd_seq_free_event(ev);
  } while (snd_seq_event_input_pending(seq_handle, 0) > 0);
}


int main(int argc, char *argv[]) {

  snd_seq_t *seq_handle;
  int npfd;
  int serial_fd = 1;
  struct pollfd *pfd;

  seq_handle = open_seq();
  npfd = snd_seq_poll_descriptors_count(seq_handle, POLLIN);
  pfd = (struct pollfd *)alloca((npfd+serial_fd) * sizeof(struct pollfd));
  snd_seq_poll_descriptors(seq_handle, pfd, npfd, POLLIN);
  
  ttyusb1.Open("/dev/ttyUSB1",3000000);
//  ttyusb1.Open("/dev/ttyUSB2",3000000);
  pfd[npfd].fd = ttyusb1.return_filedes();
  pfd[npfd].events = POLLIN;

  db_tune.set_filter(0x9,0x35);   

  while (1) {
    if (poll(pfd, (npfd+serial_fd), 100000) > 0) {
      if (pfd[npfd].revents & POLLIN ) {
        uint16_t read_return = read(pfd[npfd].fd,read_buff,256);
        if (read_return > 0) {
          for (uint16_t i=0; i < read_return; i++) {
            db_tune.remove(read_buff[i]);
          }
        }
      }
      midi_action(seq_handle);
    }  
  }

      ttyusb1.Close();

}
