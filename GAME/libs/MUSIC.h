#define STOP_PLAY		-1
#define REPEATE_PLAY	-2
#define NEXT_PLAY		-3

typedef struct _MELODY {
	unsigned short far** tones;
	unsigned int index, total, n;
	unsigned short delay;
	char is_playing;
} MELODY;

MELODY M_melody;

void M_play(unsigned short far** tones, unsigned int n) {
	M_melody.tones = tones;
	M_melody.index = 0;
	M_melody.n = 0;
	M_melody.is_playing = 1;
	M_melody.total = n;
	M_melody.delay = 1;
	outp(0x43, 0xB6);
}

void M_stop() {
	outp(0x61, inp(0x61) & 252);
	M_melody.is_playing = 0;
}

void M_handler() {
	if (!M_melody.is_playing) {
		return;
	}
	M_melody.delay--;
	if (M_melody.delay == 0) {
		unsigned int freq = M_melody.tones[M_melody.n][M_melody.index];
		M_melody.delay = M_melody.tones[M_melody.n][M_melody.index + 1] * 10;
		M_melody.index += 2;
		switch (freq) {
			case 0:
				outp(0x61, inp(0x61) & 252);
				break;
			case STOP_PLAY:
				M_stop();
				break;
			case NEXT_PLAY:
				M_melody.n = (M_melody.n + 1) % M_melody.total;
			case REPEATE_PLAY:
				freq = M_melody.tones[M_melody.n][0];
				M_melody.delay = M_melody.tones[M_melody.n][1];
				M_melody.index = 2;
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
