#define STOP_PLAY		-1
#define REPEATE_PLAY	-2
#define NEXT_PLAY		-3
#define M_QUEUE_SIZE	16

typedef struct _MELODY {
	unsigned short far** tones;
	unsigned int index, total, n;
	unsigned short delay;
} MELODY;

MELODY M_melody[M_QUEUE_SIZE];
char cur_m = -1;


void M_play(unsigned short** tones, unsigned int n) {
	if (cur_m > M_QUEUE_SIZE) return;
	cur_m++;
	M_melody[cur_m].tones = tones;
	M_melody[cur_m].index = 0;
	M_melody[cur_m].n = 0;
	M_melody[cur_m].total = n;
	M_melody[cur_m].delay = 1;
	outp(0x43, 0xB6);
}

void M_stop() {
	if (cur_m == -1) {
		outp(0x61, inp(0x61) & 252);
	} else {
		cur_m--;
	}
}

void M_handler() {
	if (cur_m == -1) {
		return;
	}
	M_melody[cur_m].delay--;
	if (M_melody[cur_m].delay == 0) {
		unsigned int freq = M_melody[cur_m].tones[M_melody[cur_m].n][M_melody[cur_m].index];
		M_melody[cur_m].delay = M_melody[cur_m].tones[M_melody[cur_m].n][M_melody[cur_m].index + 1];
		M_melody[cur_m].index += 2;
		switch (freq) {
			case 0:
				outp(0x61, inp(0x61) & 252);
				break;
			case STOP_PLAY:
				M_stop();
				break;
			case NEXT_PLAY:
				M_melody[cur_m].n = (M_melody[cur_m].n + 1) % M_melody[cur_m].total;
			case REPEATE_PLAY:
				freq = M_melody[cur_m].tones[M_melody[cur_m].n][0];
				M_melody[cur_m].delay = M_melody[cur_m].tones[M_melody[cur_m].n][1];
				M_melody[cur_m].index = 2;
				break;
			default:
				freq = 1193180 / freq;
				outp(0x61, inp(0x61) & 252);
				outp(0x42, freq & 255);
				outp(0x42, freq >> 8);
				outp(0x61, inp(0x61) | 3);
		}
	}
}
