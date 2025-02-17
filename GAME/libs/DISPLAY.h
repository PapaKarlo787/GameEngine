#define H 200
#define W 320
#define ENT_CNT 32

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
	unsigned short cur_sprite, spr_cnt, id;
	unsigned short far* sprite_indexes;
	void far(*step)(void far*);
	char sx, sy;
	unsigned char hp, type;
} ENTITY;

unsigned char far *G_MEMORY;
unsigned char far *G_BUFFER;
unsigned char far **G_backs;
SPRITE far* G_sprites;
ENTITY G_entityes[ENT_CNT];
unsigned char G_ent_free[ENT_CNT];
unsigned short G_sprites_cnt, G_backs_cnt;
unsigned char G_cur_back;
short G_back_rotation;

void init_display(const char* resources) {
	int i;
	FILE* f = fopen(resources, "rb");
	RGB palete[256];
	for (i = 0; i < ENT_CNT; i++) {
		G_ent_free[i] = 1;
	}
	G_cur_back = 0;
	G_BUFFER = (unsigned char far*)malloc(W * H);
	G_MEMORY = (unsigned char far*)MK_FP(0xA000, 0x0000);
	fread(palete, sizeof(RGB), 256, f);
	fread(&G_backs_cnt, 2, 1, f);
	fread(&G_sprites_cnt, 2, 1, f);
	G_backs = (unsigned char far**)malloc(G_backs_cnt * sizeof(unsigned char far*));
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

ENTITY far* create_entity(short x, short y, 
							char sx, char sy, 
							unsigned char type, 
							unsigned char size, 
							unsigned short* sprite_indexes, 
							unsigned short cnt, 
							void (*step)(ENTITY far*)) {
	int i;
	for (i = 0; i < ENT_CNT; i++) {
		if (G_ent_free[i]) {
			G_ent_free[i] = 0;
			break;
		}
	}
	if (i == ENT_CNT) return 0;
	G_entityes[i].x = x;
	G_entityes[i].y = y;
	G_entityes[i].sx = sx;
	G_entityes[i].sy = sy;
	G_entityes[i].sprite_indexes = sprite_indexes;
	G_entityes[i].spr_cnt = cnt;
	G_entityes[i].cur_sprite = 0;
	G_entityes[i].step = step;
	G_entityes[i].hp = 255;
	G_entityes[i].type = type;
	G_entityes[i].id = i;
	return &G_entityes[i];
}

void delete_entity(ENTITY far* ent) {
	G_ent_free[ent->id] = 1;
}

void set_back(unsigned char n) {
	G_cur_back = n;
}

void set_back_rotation(short rotation) {
	int i, new_back_rot = abs(rotation) % W * (rotation > 0 ? 1 : -1) + W;
	short difference = (new_back_rot - G_back_rotation + W) % W;
	short delta = difference < (W >> 1) ? difference : difference - W;
	for (i = 0; i < ENT_CNT; i++) {
		G_entityes[i].x += delta;
	}
	G_back_rotation = new_back_rot;
}

void refresh_screen() {
	int i, l, k, ind;
	SPRITE far* spr;
	ENTITY far* ent;
	for (i = 0; i < H; i++) {
		for (l = 0; l < W; l++) {
			G_BUFFER[i * W + (l + G_back_rotation) % W] = G_backs[G_cur_back][i * W + l];
		}
	}
	for (k = 0; k < ENT_CNT; k++) {
		if (G_ent_free[k]) continue;
		ent = &G_entityes[k];
		spr = &G_sprites[ent->sprite_indexes[ent->cur_sprite]];
		for (i = 0; i < spr->h && ent->y + i < H; i++) {
			for (l = 0; l < spr->w && ent->x + l < W ; l++) {
				if (spr->bmp[i * spr->w + l] && ent->x + l >= 0 && ent->y + i >= 0) {
					ind = (ent->y + i) * W + ent->x + l;
					G_BUFFER[ind] = spr->bmp[i * spr->w + l];
				}
			}
		}
		ent->cur_sprite = (ent->cur_sprite + 1) % ent->spr_cnt;
		ent->x += ent->sx;
		ent->y += ent->sy;
		if (ent->step)
			ent->step(ent);
	}
}

void draw_screen() {
	memcpy(G_MEMORY, G_BUFFER, H * W);
}

int intersects(struct ENTITY* ent1, struct ENTITY* ent2) {
	return 0;
}
