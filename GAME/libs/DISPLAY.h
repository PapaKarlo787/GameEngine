#define H 200
#define W 320
#define BG_CNT 8
#define ENT_CNT 32
#define EMPTY_FRAMES 100

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
	unsigned short cur_sprite, spr_cnt;
	unsigned short far* sprite_indexes;
	void far(*step)(void far*);
	char sx, sy;
	unsigned char hp, type;
} ENTITY;

unsigned char far *G_MEMORY;
unsigned char far *G_BUFFER;
unsigned char far *G_backs[BG_CNT];
SPRITE far* G_sprites;
ENTITY far* G_entityes[ENT_CNT];
unsigned short G_sprites_cnt, G_backs_cnt, G_back_rotation;
unsigned char G_skip_frames, G_cur_back, G_entityes_cnt;

void init_display(const char* resources) {
	int i;
	FILE* f = fopen(resources, "rb");
	RGB palete[256];
	G_skip_frames = EMPTY_FRAMES;
	G_entityes_cnt = 0;
	G_cur_back = 0;
	G_BUFFER = (unsigned char far*)MK_FP(0xB000, 0x0000);
	G_MEMORY = (unsigned char far*)MK_FP(0xA000, 0x0000);
	fread(palete, sizeof(RGB), 256, f);
	fread(&G_backs_cnt, 2, 1, f);
	fread(&G_sprites_cnt, 2, 1, f);
	for (i = 0; i < G_backs_cnt; i++) {
		G_backs[i] = (unsigned char far*)malloc(H * W);
		fread(G_backs[i], W, H, f);
	}
	G_sprites = (SPRITE far*)malloc(sizeof(SPRITE) * G_sprites_cnt);
	for (i = 0; i < G_sprites_cnt; i++) {
		fread(&G_sprites[i].h, 2, 1, f);
		fread(&G_sprites[i].w, 2, 1, f);
		G_sprites[i].bmp = (unsigned char far*)malloc(G_sprites[i].w * G_sprites[i].h);
		fread(G_sprites[i].bmp, G_sprites[i].w, G_sprites[i].h, f);
	}
	
	fclose(f);
	
	asm {
		mov ax, 0x13
		int 10h
	}

	outp(0x03C8, 0);
	for (i = 0; i < 256; i++) {
		outp(0x3C9, palete[i].r >> 2);
		outp(0x3C9, palete[i].g >> 2);
		outp(0x3C9, palete[i].b >> 2);
	}
}

void create_entity(short x, short y, char sx, char sy, unsigned short* sprite_indexes, unsigned short cnt, void (*step)(ENTITY far*)) {
	G_entityes[G_entityes_cnt] = (ENTITY far*)malloc(sizeof(ENTITY));
	G_entityes[G_entityes_cnt]->x = x;
	G_entityes[G_entityes_cnt]->y = y;
	G_entityes[G_entityes_cnt]->sx = sx;
	G_entityes[G_entityes_cnt]->sy = sy;
	G_entityes[G_entityes_cnt]->sprite_indexes = sprite_indexes;
	G_entityes[G_entityes_cnt]->spr_cnt = cnt;
	G_entityes[G_entityes_cnt]->cur_sprite = 0;
	G_entityes[G_entityes_cnt]->step = step;
	G_entityes[G_entityes_cnt]->hp = 255;
	G_entityes_cnt++;
}

void set_back(unsigned char n) {
	G_cur_back = n;
}

void set_back_rotation(unsigned short rotation) {
	G_back_rotation = rotation % W;
}

void refresh_screen() {
	int i, l, k, ind;
	SPRITE far* spr;
	if (G_skip_frames == 0) {
		for (i = 0; i < H; i++) {
			for (l = 0; l < W; l++) {
				G_BUFFER[i * W + (l + G_back_rotation) % W] = G_backs[G_cur_back][i * W + l];
			}
		}
		for (k = 0; k < G_entityes_cnt; k++) {
			if (!G_entityes[k]->hp) continue;
			spr = &G_sprites[G_entityes[k]->sprite_indexes[G_entityes[k]->cur_sprite]];
			for (i = 0; i < spr->h; i++) {
				for (l = 0; l < spr->w; l++) {
					if (spr->bmp[i * spr->w + l]) {
						ind = (G_entityes[k]->y + i) * W + G_entityes[k]->x + l;
						G_BUFFER[ind] = spr->bmp[i * spr->w + l];
					}
				}
			}
			G_entityes[k]->cur_sprite = (G_entityes[k]->cur_sprite + 1) % G_entityes[k]->spr_cnt;
			G_entityes[k]->x += G_entityes[k]->sx;
			G_entityes[k]->y += G_entityes[k]->sy;
			if (G_entityes[k]->step)
				G_entityes[k]->step(G_entityes[k]);
		}
		memcpy(G_MEMORY, G_BUFFER, H * W);
		G_skip_frames = EMPTY_FRAMES;
	} else {
		G_skip_frames--;
	}
}

int intersects(struct ENTITY* ent1, struct ENTITY* ent2) {
	return 0;
}
