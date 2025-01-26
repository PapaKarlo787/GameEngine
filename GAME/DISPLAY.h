#define H 200
#define W 320

typedef struct RGB {
	unsigned char r;
	unsigned char g;
	unsigned char b;
} RGB;

typedef struct SPRITE {
	unsigned short w, h;
	unsigned char far* bmp;
} SPRITE;

typedef struct ENTITY{
	short x, y;
	unsigned char cur_sprite;
	SPRITE far** sprites;
} ENTITY;

unsigned char far* G_MEMORY;
unsigned char far* G_BUFFER;
unsigned char far* G_backs;
SPRITE far* G_sprites;
unsigned short G_backs_cnt;
unsigned short G_sprites_cnt;
unsigned short G_back_rotation;

void init_display(const char* resources) {
	int i;
	int fd = open(resources);
	RGB palete[256];
	G_BUFFER = (unsigned char far*)farmalloc(H * W);
	G_MEMORY = (unsigned char far*)MK_FP(0xA000,0x0000);
	read(fd, palete, sizeof(palete));
	read(fd, &G_backs_cnt, 2);
	read(fd, &G_sprites_cnt, 2);
	G_backs = (unsigned char far*)farmalloc(G_backs_cnt * H * W);
	G_sprites = (SPRITE far*)farmalloc(sizeof(SPRITE) * G_sprites_cnt);
	read(fd, &G_backs, G_backs_cnt * H * W);
	for (i = 0; i < G_sprites_cnt; i++) {
		read(fd, &G_sprites[i].w, 2);
		read(fd, &G_sprites[i].h, 2);
		G_sprites[i].bmp = (unsigned char far*)farmalloc(G_sprites[i].w * G_sprites[i].h);
		read(fd, G_sprites[i].bmp, 2);
	}

	outp(0x03C8, 0);
	for (i = 0; i < 256; i++) {
		outp(0x3C9, palete[i].r >> 2);
		outp(0x3C9, palete[i].g >> 2);
		outp(0x3C9, palete[i].b >> 2);
	}
	
	asm {
		mov ax, 0x13
		int 10h
	}
}

void set_back(unsigned char n) {
	int i, l;
	for (i = 0; i < H; i++) {
		for (l = 0; l < W; l++) {
			G_BUFFER[i * W + (l + G_back_rotation) % W] = G_backs[n * H * W + i * W + l];
		}
	}
}

void set_back_rotation(unsigned short rotation) {
	G_back_rotation = rotation % W;
}

void set_entity(ENTITY far* ent) {
	SPRITE far* spr = ent->sprites[ent->cur_sprite];
	int i, l;
	for (i = 0; i < spr->h; i++) {
		for (l = 0; l < spr->w; l++) {
			if (spr->bmp[i * spr->w + l]) {
				int ind = (ent->y + i) * W + ent->x + l;
				G_BUFFER[ind] = spr->bmp[i * spr->w + l];
			}
		}
	}
}

void refresh_screen() {
	memcpy(G_MEMORY, G_BUFFER, H * W);
}

int intersects(struct ENTITY* ent1, struct ENTITY* ent2) {
	return 0;
}
