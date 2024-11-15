struct MELODY {
	unsigned short far* tones;
	unsigned int index;
};

MELODY M_melody;

void M_play(unsigned short far* tones) {
	M_melody.tones = tones;
	M_melody.index = 0;
}

void M_stop() {
	
}

void M_handler() {
	
}
