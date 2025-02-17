	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	V 300h
	?debug	S "main.c"
	?debug	C E9F56C515A066D61696E2E63
	?debug	C E9F56C515A19433A5C424F524C414E44435C494E434C5544455C64+
	?debug	C 6F732E68
	?debug	C E9F56C515A1B433A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 646566732E68
	?debug	C E9F56C515A1B433A5C424F524C414E44435C494E434C5544455C73+
	?debug	C 7464696F2E68
	?debug	C E9F56C515A1B433A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 6E756C6C2E68
	?debug	C E9F56C515A1C433A5C424F524C414E44435C494E434C5544455C73+
	?debug	C 74646C69622E68
	?debug	C E9717F515A0E6C6962732F646973706C61792E68
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void init_display(const char* resources) {
   ;	
	assume	cs:_TEXT
_init_display	proc	near
	push	bp
	mov	bp,sp
	sub	sp,770
	push	si
	push	di
   ;	
   ;		int i;
   ;		FILE* f = fopen(resources, "rb");
   ;	
	mov	ax,offset DGROUP:s@
	push	ax
	push	word ptr [bp+4]
	call	near ptr _fopen
	pop	cx
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;		RGB palete[256];
   ;		for (i = 0; i < ENT_CNT; i++) {
   ;	
	mov	cx,16
	mov	di,offset DGROUP:_G_ent_free
	push	ds
	pop	es
	mov	ax,257
	rep 	stosw	
   ;	
   ;			G_ent_free[i] = 1;
   ;		}
   ;		G_cur_back = 0;
   ;	
	mov	byte ptr DGROUP:_G_cur_back,0
   ;	
   ;		G_BUFFER = (unsigned char far*)malloc(W * H);
   ;	
	mov	ax,64000
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	word ptr DGROUP:_G_BUFFER+2,ds
	mov	word ptr DGROUP:_G_BUFFER,ax
   ;	
   ;		G_MEMORY = (unsigned char far*)MK_FP(0xA000, 0x0000);
   ;	
	mov	word ptr DGROUP:_G_MEMORY+2,40960
	mov	word ptr DGROUP:_G_MEMORY,0
   ;	
   ;		fread(palete, sizeof(RGB), 256, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,256
	push	ax
	mov	ax,3
	push	ax
	lea	ax,word ptr [bp-770]
	push	ax
	call	near ptr _fread
	add	sp,8
   ;	
   ;		fread(&G_backs_cnt, 2, 1, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,1
	push	ax
	mov	ax,2
	push	ax
	mov	ax,offset DGROUP:_G_backs_cnt
	push	ax
	call	near ptr _fread
	add	sp,8
   ;	
   ;		fread(&G_sprites_cnt, 2, 1, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,1
	push	ax
	mov	ax,2
	push	ax
	mov	ax,offset DGROUP:_G_sprites_cnt
	push	ax
	call	near ptr _fread
	add	sp,8
   ;	
   ;		G_backs = (unsigned char far**)malloc(G_backs_cnt * sizeof(unsigned char far*));
   ;	
	mov	ax,word ptr DGROUP:_G_backs_cnt
	shl	ax,1
	shl	ax,1
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	word ptr DGROUP:_G_backs,ax
   ;	
   ;		for (i = 0; i < G_backs_cnt; i++) {
   ;	
	xor	si,si
	cmp	si,word ptr DGROUP:_G_backs_cnt
	jae	short @1@254
@1@170:
   ;	
   ;			G_backs[i] = (unsigned char far*)malloc(H * W);
   ;	
	mov	ax,64000
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	dx,si
	shl	dx,1
	shl	dx,1
	mov	bx,word ptr DGROUP:_G_backs
	add	bx,dx
	mov	word ptr [bx+2],ds
	mov	word ptr [bx],ax
   ;	
   ;			fread(G_backs[i], W, H, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,200
	push	ax
	mov	ax,320
	push	ax
	mov	ax,si
	shl	ax,1
	shl	ax,1
	mov	bx,word ptr DGROUP:_G_backs
	add	bx,ax
	push	word ptr [bx]
	call	near ptr _fread
	add	sp,8
	inc	si
	cmp	si,word ptr DGROUP:_G_backs_cnt
	jb	short @1@170
@1@254:
   ;	
   ;		}
   ;		G_sprites = (SPRITE far*)malloc(sizeof(SPRITE) * G_sprites_cnt);
   ;	
	mov	ax,word ptr DGROUP:_G_sprites_cnt
	shl	ax,1
	shl	ax,1
	shl	ax,1
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	word ptr DGROUP:_G_sprites+2,ds
	mov	word ptr DGROUP:_G_sprites,ax
   ;	
   ;		for (i = 0; i < G_sprites_cnt; i++) {
   ;	
	xor	si,si
	cmp	si,word ptr DGROUP:_G_sprites_cnt
	jb	@@0
	jmp	@1@394
@@0:
@1@310:
   ;	
   ;			fread(&G_sprites[i].h, 2, 1, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,1
	push	ax
	mov	ax,2
	push	ax
	mov	ax,si
	shl	ax,1
	shl	ax,1
	shl	ax,1
	mov	dx,word ptr DGROUP:_G_sprites
	add	dx,ax
	add	dx,2
	push	dx
	call	near ptr _fread
	add	sp,8
   ;	
   ;			fread(&G_sprites[i].w, 2, 1, f);
   ;	
	push	word ptr [bp-2]
	mov	ax,1
	push	ax
	mov	ax,2
	push	ax
	mov	ax,si
	shl	ax,1
	shl	ax,1
	shl	ax,1
	mov	dx,word ptr DGROUP:_G_sprites
	add	dx,ax
	push	dx
	call	near ptr _fread
	add	sp,8
   ;	
   ;			G_sprites[i].bmp = (unsigned char far*)malloc(G_sprites[i].w * G_sprites[i].h);
   ;	
	mov	ax,si
	shl	ax,1
	shl	ax,1
	shl	ax,1
	les	bx,dword ptr DGROUP:_G_sprites
	add	bx,ax
	mov	ax,word ptr es:[bx]
	imul	word ptr es:[bx+2]
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	dx,si
	shl	dx,1
	shl	dx,1
	shl	dx,1
	les	bx,dword ptr DGROUP:_G_sprites
	add	bx,dx
	mov	word ptr es:[bx+6],ds
	mov	word ptr es:[bx+4],ax
   ;	
   ;			fread(G_sprites[i].bmp, G_sprites[i].w, G_sprites[i].h, f);
   ;	
	push	word ptr [bp-2]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	push	word ptr es:[bx+4]
	call	near ptr _fread
	add	sp,8
	inc	si
	cmp	si,word ptr DGROUP:_G_sprites_cnt
	jae	@@1
	jmp	@1@310
@@1:
@1@394:
   ;	
   ;		}
   ;		
   ;		fclose(f);
   ;	
	push	word ptr [bp-2]
	call	near ptr _fclose
	pop	cx
   ;	
   ;		
   ;		asm {
   ;			mov ax, 0x13
   ;	
	mov	 ax, 013H
   ;	
   ;			int 10h
   ;	
	int	 10h
   ;	
   ;		}
   ;	
   ;		outp(0x03C8, 0);
   ;	
	mov	dx,968
	mov	al,0
	out	dx,al
	mov	al,0
   ;	
   ;		for (i = 0; i < 256; i++) {
   ;	
	xor	si,si
@1@506:
   ;	
   ;			outp(0x3C9, palete[i].r >> 2);
   ;	
	mov	ax,si
	mov	dx,3
	imul	dx
	lea	dx,word ptr [bp-770]
	add	ax,dx
	mov	bx,ax
	mov	al,byte ptr [bx]
	mov	ah,0
	sar	ax,1
	sar	ax,1
	mov	dx,969
	out	dx,al
	mov	al,0
   ;	
   ;			outp(0x3C9, palete[i].g >> 2);
   ;	
	mov	ax,si
	mov	dx,3
	imul	dx
	lea	dx,word ptr [bp-769]
	add	ax,dx
	mov	bx,ax
	mov	al,byte ptr [bx]
	mov	ah,0
	sar	ax,1
	sar	ax,1
	mov	dx,969
	out	dx,al
	mov	al,0
   ;	
   ;			outp(0x3C9, palete[i].b >> 2);
   ;	
	mov	ax,si
	mov	dx,3
	imul	dx
	lea	dx,word ptr [bp-768]
	add	ax,dx
	mov	bx,ax
	mov	al,byte ptr [bx]
	mov	ah,0
	sar	ax,1
	sar	ax,1
	mov	dx,969
	out	dx,al
	mov	al,0
	inc	si
	cmp	si,256
	jl	short @1@506
   ;	
   ;		}
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_init_display	endp
   ;	
   ;	ENTITY far* create_entity(short x, short y, 
   ;	
	assume	cs:_TEXT
_create_entity	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;								char sx, char sy, 
   ;								unsigned char type, 
   ;								unsigned char size, 
   ;								unsigned short* sprite_indexes, 
   ;								unsigned short cnt, 
   ;								void (*step)(ENTITY far*)) {
   ;		int i;
   ;		for (i = 0; i < ENT_CNT; i++) {
   ;	
	xor	si,si
@2@58:
   ;	
   ;			if (G_ent_free[i]) {
   ;	
	cmp	byte ptr DGROUP:_G_ent_free[si],0
	je	short @2@114
   ;	
   ;				G_ent_free[i] = 0;
   ;	
	mov	byte ptr DGROUP:_G_ent_free[si],0
   ;	
   ;				break;
   ;	
	jmp	short @2@170
@2@114:
	inc	si
	cmp	si,32
	jl	short @2@58
@2@170:
   ;	
   ;			}
   ;		}
   ;		if (i == ENT_CNT) return 0;
   ;	
	cmp	si,32
	jne	short @2@226
	xor	dx,dx
	xor	ax,ax
	jmp	@2@254
@2@226:
   ;	
   ;		G_entityes[i].x = x;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dx,word ptr [bp+4]
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx],dx
   ;	
   ;		G_entityes[i].y = y;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dx,word ptr [bp+6]
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+2],dx
   ;	
   ;		G_entityes[i].sx = sx;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dl,byte ptr [bp+8]
	mov	bx,ax
	mov	byte ptr DGROUP:_G_entityes[bx+18],dl
   ;	
   ;		G_entityes[i].sy = sy;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dl,byte ptr [bp+10]
	mov	bx,ax
	mov	byte ptr DGROUP:_G_entityes[bx+19],dl
   ;	
   ;		G_entityes[i].sprite_indexes = sprite_indexes;
   ;	
	mov	ax,word ptr [bp+16]
	push	ax
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+12],ds
	pop	ax
	mov	word ptr DGROUP:_G_entityes[bx+10],ax
   ;	
   ;		G_entityes[i].spr_cnt = cnt;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dx,word ptr [bp+18]
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+6],dx
   ;	
   ;		G_entityes[i].cur_sprite = 0;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+4],0
   ;	
   ;		G_entityes[i].step = step;
   ;	
	mov	ax,word ptr [bp+20]
	push	ax
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+16],cs
	pop	ax
	mov	word ptr DGROUP:_G_entityes[bx+14],ax
   ;	
   ;		G_entityes[i].hp = 255;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	byte ptr DGROUP:_G_entityes[bx+20],255
   ;	
   ;		G_entityes[i].type = type;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	dl,byte ptr [bp+12]
	mov	bx,ax
	mov	byte ptr DGROUP:_G_entityes[bx+21],dl
   ;	
   ;		G_entityes[i].id = i;
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_G_entityes[bx+8],si
   ;	
   ;		return &G_entityes[i];
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	add	ax,offset DGROUP:_G_entityes
	mov	dx,ds
@2@254:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_create_entity	endp
   ;	
   ;	void delete_entity(ENTITY far* ent) {
   ;	
	assume	cs:_TEXT
_delete_entity	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		G_ent_free[ent->id] = 1;
   ;	
	les	bx,dword ptr [bp+4]
	mov	bx,word ptr es:[bx+8]
	mov	byte ptr DGROUP:_G_ent_free[bx],1
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_delete_entity	endp
   ;	
   ;	void set_back(unsigned char n) {
   ;	
	assume	cs:_TEXT
_set_back	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		G_cur_back = n;
   ;	
	mov	al,byte ptr [bp+4]
	mov	byte ptr DGROUP:_G_cur_back,al
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_set_back	endp
   ;	
   ;	void set_back_rotation(short rotation) {
   ;	
	assume	cs:_TEXT
_set_back_rotation	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	mov	cx,word ptr [bp+4]
   ;	
   ;		int i, new_back_rot = abs(rotation) % W * (rotation > 0 ? 1 : -1) + W;
   ;	
	mov	ax,cx
	cwd	
	xor	ax,dx
	sub	ax,dx
	mov	bx,320
	cwd	
	idiv	bx
	push	dx
	or	cx,cx
	jle	short @5@86
	mov	ax,1
	jmp	short @5@114
@5@86:
	mov	ax,65535
@5@114:
	mov	dx,ax
	pop	ax
	imul	dx
	add	ax,320
	mov	si,ax
   ;	
   ;		short difference = (new_back_rot - G_back_rotation + W) % W;
   ;	
	sub	ax,word ptr DGROUP:_G_back_rotation
	add	ax,320
	mov	bx,320
	cwd	
	idiv	bx
	mov	bx,dx
   ;	
   ;		short delta = difference < (W >> 1) ? difference : difference - W;
   ;	
	cmp	bx,160
	jge	short @5@170
	mov	ax,bx
	jmp	short @5@198
@5@170:
	mov	ax,bx
	add	ax,65216
@5@198:
	mov	word ptr [bp-2],ax
   ;	
   ;		for (i = 0; i < ENT_CNT; i++) {
   ;	
	xor	cx,cx
@5@226:
   ;	
   ;			G_entityes[i].x += delta;
   ;	
	mov	ax,cx
	mov	dx,22
	imul	dx
	mov	dx,word ptr [bp-2]
	mov	bx,ax
	add	word ptr DGROUP:_G_entityes[bx],dx
	inc	cx
	cmp	cx,32
	jl	short @5@226
   ;	
   ;		}
   ;		G_back_rotation = new_back_rot;
   ;	
	mov	word ptr DGROUP:_G_back_rotation,si
   ;	
   ;	}
   ;	
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_set_back_rotation	endp
   ;	
   ;	void refresh_screen() {
   ;	
	assume	cs:_TEXT
_refresh_screen	proc	near
	push	bp
	mov	bp,sp
	sub	sp,10
	push	si
	push	di
   ;	
   ;		int i, l, k, ind;
   ;		SPRITE far* spr;
   ;		ENTITY far* ent;
   ;		for (i = 0; i < H; i++) {
   ;	
	xor	cx,cx
@6@58:
   ;	
   ;			for (l = 0; l < W; l++) {
   ;	
	xor	si,si
@6@86:
   ;	
   ;				G_BUFFER[i * W + (l + G_back_rotation) % W] = G_backs[G_cur_back][i * W + l];
   ;	
	mov	al,byte ptr DGROUP:_G_cur_back
	mov	ah,0
	shl	ax,1
	shl	ax,1
	mov	bx,word ptr DGROUP:_G_backs
	add	bx,ax
	mov	es,word ptr [bx+2]
	mov	ax,cx
	mov	dx,320
	imul	dx
	add	ax,si
	add	ax,word ptr [bx]
	mov	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	mov	ax,cx
	mov	dx,320
	imul	dx
	push	ax
	mov	ax,si
	add	ax,word ptr DGROUP:_G_back_rotation
	mov	bx,320
	cwd	
	idiv	bx
	pop	bx
	add	bx,dx
	mov	es,word ptr DGROUP:_G_BUFFER+2
	add	bx,word ptr DGROUP:_G_BUFFER
	pop	ax
	mov	byte ptr es:[bx],al
	inc	si
	cmp	si,320
	jl	short @6@86
	inc	cx
	cmp	cx,200
	jl	short @6@58
   ;	
   ;			}
   ;		}
   ;		for (k = 0; k < ENT_CNT; k++) {
   ;	
	xor	di,di
@6@254:
   ;	
   ;			if (G_ent_free[k]) continue;
   ;	
	cmp	byte ptr DGROUP:_G_ent_free[di],0
	je	@@2
	jmp	@6@674
@@2:
   ;	
   ;			ent = &G_entityes[k];
   ;	
	mov	ax,di
	mov	dx,22
	imul	dx
	add	ax,offset DGROUP:_G_entityes
	mov	word ptr [bp-8],ds
	mov	word ptr [bp-10],ax
   ;	
   ;			spr = &G_sprites[ent->sprite_indexes[ent->cur_sprite]];
   ;	
	les	bx,dword ptr [bp-10]
	les	bx,dword ptr es:[bx+10]
	push	es
	les	si,dword ptr [bp-10]
	mov	ax,word ptr es:[si+4]
	shl	ax,1
	add	bx,ax
	pop	es
	mov	ax,word ptr es:[bx]
	shl	ax,1
	shl	ax,1
	shl	ax,1
	mov	dx,word ptr DGROUP:_G_sprites+2
	mov	bx,word ptr DGROUP:_G_sprites
	add	bx,ax
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-6],bx
   ;	
   ;			for (i = 0; i < spr->h && ent->y + i < H; i++) {
   ;	
	xor	cx,cx
	jmp	short @6@562
@6@310:
   ;	
   ;				for (l = 0; l < spr->w && ent->x + l < W ; l++) {
   ;	
	xor	si,si
	jmp	short @6@478
@6@338:
   ;	
   ;					if (spr->bmp[i * spr->w + l] && ent->x + l >= 0 && ent->y + i >= 0) {
   ;	
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx]
	imul	cx
	add	ax,si
	les	bx,dword ptr es:[bx+4]
	add	bx,ax
	cmp	byte ptr es:[bx],0
	je	short @6@450
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx]
	add	ax,si
	jl	short @6@450
	mov	ax,word ptr es:[bx+2]
	add	ax,cx
	jl	short @6@450
   ;	
   ;						ind = (ent->y + i) * W + ent->x + l;
   ;	
	mov	ax,word ptr es:[bx+2]
	add	ax,cx
	mov	dx,320
	imul	dx
	add	ax,word ptr es:[bx]
	add	ax,si
	mov	word ptr [bp-2],ax
   ;	
   ;						G_BUFFER[ind] = spr->bmp[i * spr->w + l];
   ;	
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx]
	imul	cx
	add	ax,si
	les	bx,dword ptr es:[bx+4]
	add	bx,ax
	mov	al,byte ptr es:[bx]
	les	bx,dword ptr DGROUP:_G_BUFFER
	add	bx,word ptr [bp-2]
	mov	byte ptr es:[bx],al
@6@450:
	inc	si
@6@478:
	les	bx,dword ptr [bp-6]
	cmp	word ptr es:[bx],si
	jbe	short @6@534
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx]
	add	ax,si
	cmp	ax,320
	jl	short @6@338
@6@534:
	inc	cx
@6@562:
	les	bx,dword ptr [bp-6]
	cmp	word ptr es:[bx+2],cx
	jbe	short @6@618
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx+2]
	add	ax,cx
	cmp	ax,200
	jge	@@3
	jmp	@6@310
@@3:
@6@618:
   ;	
   ;					}
   ;				}
   ;			}
   ;			ent->cur_sprite = (ent->cur_sprite + 1) % ent->spr_cnt;
   ;	
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx+4]
	inc	ax
	xor	dx,dx
	div	word ptr es:[bx+6]
	mov	word ptr es:[bx+4],dx
   ;	
   ;			ent->x += ent->sx;
   ;	
	mov	al,byte ptr es:[bx+18]
	cbw	
	add	word ptr es:[bx],ax
   ;	
   ;			ent->y += ent->sy;
   ;	
	mov	al,byte ptr es:[bx+19]
	cbw	
	add	word ptr es:[bx+2],ax
   ;	
   ;			if (ent->step)
   ;	
	mov	ax,word ptr es:[bx+14]
	or	ax,word ptr es:[bx+16]
	je	short @6@674
   ;	
   ;				ent->step(ent);
   ;	
	push	word ptr [bp-8]
	push	bx
	call	dword ptr es:[bx+14]
	pop	cx
	pop	cx
@6@674:
	inc	di
	cmp	di,32
	jge	@@4
	jmp	@6@254
@@4:
   ;	
   ;		}
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_refresh_screen	endp
   ;	
   ;	void draw_screen() {
   ;	
	assume	cs:_TEXT
_draw_screen	proc	near
   ;	
   ;		memcpy(G_MEMORY, G_BUFFER, H * W);
   ;	
	mov	ax,64000
	push	ax
	push	word ptr DGROUP:_G_BUFFER+2
	push	word ptr DGROUP:_G_BUFFER
	push	word ptr DGROUP:_G_MEMORY+2
	push	word ptr DGROUP:_G_MEMORY
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	}
   ;	
	ret	
_draw_screen	endp
   ;	
   ;	int intersects(struct ENTITY* ent1, struct ENTITY* ent2) {
   ;	
	assume	cs:_TEXT
_intersects	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		return 0;
   ;	
	xor	ax,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_intersects	endp
	?debug	C E9687F515A0C6C6962732F6D757369632E68
_TEXT	ends
_DATA	segment word public 'DATA'
_cur_m	label	byte
	db	255
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void M_play(unsigned short** tones, unsigned int n) {
   ;	
	assume	cs:_TEXT
_M_play	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		if (cur_m > M_QUEUE_SIZE) return;
   ;	
	cmp	byte ptr DGROUP:_cur_m,16
	jg	short @9@86
   ;	
   ;		cur_m++;
   ;	
	inc	byte ptr DGROUP:_cur_m
   ;	
   ;		M_melody[cur_m].tones = tones;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	dx,word ptr [bp+4]
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx],dx
   ;	
   ;		M_melody[cur_m].index = 0;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx+2],0
   ;	
   ;		M_melody[cur_m].n = 0;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx+6],0
   ;	
   ;		M_melody[cur_m].total = n;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	dx,word ptr [bp+6]
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx+4],dx
   ;	
   ;		M_melody[cur_m].delay = 1;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx+8],1
   ;	
   ;		outp(0x43, 0xB6);
   ;	
	mov	dx,67
	mov	al,182
	out	dx,al
	mov	al,0
@9@86:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_M_play	endp
   ;	
   ;	void M_stop() {
   ;	
	assume	cs:_TEXT
_M_stop	proc	near
   ;	
   ;		if (cur_m == -1) {
   ;	
	cmp	byte ptr DGROUP:_cur_m,255
	jne	short @10@58
   ;	
   ;			outp(0x61, inp(0x61) & 252);
   ;	
	mov	dx,97
	in	al,dx
	and	al,252
	out	dx,al
	mov	al,0
   ;	
   ;		} else {
   ;	
	jmp	short @10@86
@10@58:
   ;	
   ;			cur_m--;
   ;	
	dec	byte ptr DGROUP:_cur_m
@10@86:
   ;	
   ;		}
   ;	}
   ;	
	ret	
_M_stop	endp
   ;	
   ;	void M_handler() {
   ;	
	assume	cs:_TEXT
_M_handler	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
   ;	
   ;		if (cur_m == -1) {
   ;	
	cmp	byte ptr DGROUP:_cur_m,255
	jne	@@5
	jmp	@11@450
@@5:
   ;	
   ;			return;
   ;		}
   ;		M_melody[cur_m].delay--;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	dec	word ptr DGROUP:_M_melody[bx+8]
   ;	
   ;		if (M_melody[cur_m].delay == 0) {
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	cmp	word ptr DGROUP:_M_melody[bx+8],0
	je	@@6
	jmp	@11@450
@@6:
   ;	
   ;			unsigned int freq = M_melody[cur_m].tones[M_melody[cur_m].n][M_melody[cur_m].index];
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	bx,word ptr DGROUP:_M_melody[bx]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	si,ax
	mov	ax,word ptr DGROUP:_M_melody[si+6]
	shl	ax,1
	shl	ax,1
	add	bx,ax
	les	bx,dword ptr [bx]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	si,ax
	mov	ax,word ptr DGROUP:_M_melody[si+2]
	shl	ax,1
	add	bx,ax
	mov	ax,word ptr es:[bx]
	mov	word ptr [bp-4],ax
   ;	
   ;			M_melody[cur_m].delay = M_melody[cur_m].tones[M_melody[cur_m].n][M_melody[cur_m].index + 1];
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	bx,word ptr DGROUP:_M_melody[bx]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	si,ax
	mov	ax,word ptr DGROUP:_M_melody[si+6]
	shl	ax,1
	shl	ax,1
	add	bx,ax
	mov	bx,word ptr [bx]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	si,ax
	mov	ax,word ptr DGROUP:_M_melody[si+2]
	inc	ax
	shl	ax,1
	add	bx,ax
	mov	ax,word ptr es:[bx]
	push	ax
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	pop	ax
	mov	word ptr DGROUP:_M_melody[bx+8],ax
   ;	
   ;			M_melody[cur_m].index += 2;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	add	word ptr DGROUP:_M_melody[bx+2],2
   ;	
   ;			switch (freq) {
   ;	
	mov	ax,word ptr [bp-4]
	mov	word ptr [bp-2],ax
	mov	cx,4
	mov	bx,offset @11@C98
@11@170:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-2]
	je	short @11@254
	add	bx,2
	loop	short @11@170
	jmp	@11@394
@11@254:
	jmp	word ptr cs:[bx+8]
@11@282:
   ;	
   ;				case 0:
   ;					outp(0x61, inp(0x61) & 252);
   ;	
	mov	dx,97
	in	al,dx
	and	al,252
	jmp	@11@422
@11@310:
   ;	
   ;					break;
   ;				case STOP_PLAY:
   ;					M_stop();
   ;	
	call	near ptr _M_stop
   ;	
   ;					break;
   ;	
	jmp	@11@450
@11@338:
   ;	
   ;				case NEXT_PLAY:
   ;					M_melody[cur_m].n = (M_melody[cur_m].n + 1) % M_melody[cur_m].total;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	ax,word ptr DGROUP:_M_melody[bx+6]
	inc	ax
	push	ax
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	xor	dx,dx
	mov	bx,ax
	pop	ax
	div	word ptr DGROUP:_M_melody[bx+4]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	bx,10
	push	dx
	imul	bx
	mov	bx,ax
	pop	ax
	mov	word ptr DGROUP:_M_melody[bx+6],ax
@11@366:
   ;	
   ;				case REPEATE_PLAY:
   ;					freq = M_melody[cur_m].tones[M_melody[cur_m].n][0];
   ;	
   ;	
   ;					M_melody[cur_m].delay = M_melody[cur_m].tones[M_melody[cur_m].n][1];
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	bx,word ptr DGROUP:_M_melody[bx]
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	si,ax
	mov	ax,word ptr DGROUP:_M_melody[si+6]
	shl	ax,1
	shl	ax,1
	add	bx,ax
	les	bx,dword ptr [bx]
	mov	ax,word ptr es:[bx+2]
	push	ax
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	pop	ax
	mov	word ptr DGROUP:_M_melody[bx+8],ax
   ;	
   ;					M_melody[cur_m].index = 2;
   ;	
	mov	al,byte ptr DGROUP:_cur_m
	cbw	
	mov	dx,10
	imul	dx
	mov	bx,ax
	mov	word ptr DGROUP:_M_melody[bx+2],2
   ;	
   ;					break;
   ;	
	jmp	short @11@450
@11@394:
   ;	
   ;				default:
   ;					freq = 1193180 / freq;
   ;	
	xor	ax,ax
	push	ax
	push	word ptr [bp-4]
	mov	ax,18
	mov	dx,13532
	push	ax
	push	dx
	call	near ptr N_LDIV@
	mov	word ptr [bp-4],ax
   ;	
   ;					outp(0x61, inp(0x61) & 252);
   ;	
	mov	dx,97
	in	al,dx
	and	al,252
	out	dx,al
	mov	al,0
   ;	
   ;					outp(0x42, freq & 255);
   ;	
	mov	al,byte ptr [bp-4]
	and	al,255
	mov	dx,66
	out	dx,al
	mov	al,0
   ;	
   ;					outp(0x42, freq >> 8);
   ;	
	mov	ax,word ptr [bp-4]
	mov	cl,8
	shr	ax,cl
	out	dx,al
	mov	al,0
   ;	
   ;					outp(0x61, inp(0x61) | 3);
   ;	
	mov	dx,97
	in	al,dx
	or	al,3
@11@422:
	mov	dx,97
	out	dx,al
	mov	al,0
@11@450:
   ;	
   ;			}
   ;		}
   ;	}
   ;	
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_M_handler	endp
@11@C98	label	word
	db	0
	db	0
	db	253
	db	255
	db	254
	db	255
	db	255
	db	255
	dw	@11@282
	dw	@11@338
	dw	@11@366
	dw	@11@310
	?debug	C E9F56C515A0A6C6962732F6972712E68
	?debug	C E9F56C515A1B433A5C424F524C414E44435C494E434C5544455C73+
	?debug	C 7464696F2E68
	?debug	C E9F56C515A19433A5C424F524C414E44435C494E434C5544455C64+
	?debug	C 6F732E68
	?debug	C E9F56C515A1B433A5C424F524C414E44435C494E434C5544455C63+
	?debug	C 6F6E696F2E68
   ;	
   ;	void interrupt keyb_handler() {
   ;	
	assume	cs:_TEXT
_keyb_handler	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,cs:DGROUP@
	mov	ds,bp
   ;	
   ;		int i;
   ;		for (i = 0; i < KBD_SUB_MAX && keyb_subscribers[i]; i++) {
   ;	
	xor	si,si
	jmp	short @12@114
@12@58:
   ;	
   ;			keyb_subscribers[i]();
   ;	
	mov	bx,si
	shl	bx,1
	call	word ptr DGROUP:_keyb_subscribers[bx]
	inc	si
@12@114:
	cmp	si,8
	jge	short @12@170
	mov	bx,si
	shl	bx,1
	cmp	word ptr DGROUP:_keyb_subscribers[bx],0
	jne	short @12@58
@12@170:
   ;	
   ;		}
   ;		asm {
   ;			mov al, 0x20
   ;	
	mov	 al, 020H
   ;	
   ;			out 0x20, al
   ;	
	out	 020H, al
   ;	
   ;		}
   ;	}
   ;	
	pop	bp
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
_keyb_handler	endp
   ;	
   ;	void interrupt timer_handler() {
   ;	
	assume	cs:_TEXT
_timer_handler	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,cs:DGROUP@
	mov	ds,bp
   ;	
   ;		int i;
   ;		for (i = 0; i < timer_sub_cnt; i++) {
   ;	
	xor	si,si
	jmp	short @13@114
@13@58:
   ;	
   ;			timer_subscribers[i]();
   ;	
	mov	bx,si
	shl	bx,1
	call	word ptr DGROUP:_timer_subscribers[bx]
	inc	si
@13@114:
	mov	al,byte ptr DGROUP:_timer_sub_cnt
	mov	ah,0
	cmp	ax,si
	jg	short @13@58
   ;	
   ;		}
   ;		outp(0x40, TIM_TICKS & 255);
   ;	
	mov	dx,64
	mov	al,22
	out	dx,al
	mov	al,0
   ;	
   ;		outp(0x40, TIM_TICKS >> 8);
   ;	
	mov	al,210
	out	dx,al
	mov	al,0
   ;	
   ;		asm {
   ;			mov al, 0x20
   ;	
	mov	 al, 020H
   ;	
   ;			out 0x20, al
   ;	
	out	 020H, al
   ;	
   ;		}
   ;	}
   ;	
	pop	bp
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
_timer_handler	endp
   ;	
   ;	void init_irq() {
   ;	
	assume	cs:_TEXT
_init_irq	proc	near
   ;	
   ;		asm {cli};
   ;	
	cli	
   ;	
   ;		outp(0x43, 0x30);
   ;	
	mov	dx,67
	mov	al,48
	out	dx,al
	mov	al,0
   ;	
   ;		outp(0x40, TIM_TICKS & 255);
   ;	
	mov	dx,64
	mov	al,22
	out	dx,al
	mov	al,0
   ;	
   ;		outp(0x40, TIM_TICKS >> 8);
   ;	
	mov	al,210
	out	dx,al
	mov	al,0
   ;	
   ;		old_tim = getvect(TIM_VECT);
   ;	
	mov	ax,8
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_old_tim+2,dx
	mov	word ptr DGROUP:_old_tim,ax
   ;	
   ;		setvect(TIM_VECT, timer_handler);
   ;	
	mov	ax,seg _timer_handler
	push	ax
	mov	ax,offset _timer_handler
	push	ax
	mov	ax,8
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;		timer_sub_cnt = 0;
   ;	
	mov	byte ptr DGROUP:_timer_sub_cnt,0
   ;	
   ;		old_kbd = getvect(KBD_VECT);
   ;	
	mov	ax,9
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_old_kbd+2,dx
	mov	word ptr DGROUP:_old_kbd,ax
   ;	
   ;		setvect(KBD_VECT, keyb_handler);
   ;	
	mov	ax,seg _keyb_handler
	push	ax
	mov	ax,offset _keyb_handler
	push	ax
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;		keyb_sub_cnt = 0;
   ;	
	mov	byte ptr DGROUP:_keyb_sub_cnt,0
   ;	
   ;		asm {sti};
   ;	
	sti	
   ;	
   ;	}
   ;	
	ret	
_init_irq	endp
   ;	
   ;	void uninit_irq() {
   ;	
	assume	cs:_TEXT
_uninit_irq	proc	near
   ;	
   ;		setvect(TIM_VECT, old_tim);
   ;	
	push	word ptr DGROUP:_old_tim+2
	push	word ptr DGROUP:_old_tim
	mov	ax,8
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;		setvect(KBD_VECT, old_kbd);
   ;	
	push	word ptr DGROUP:_old_kbd+2
	push	word ptr DGROUP:_old_kbd
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;		outp(0x61, inp(0x61) & 252);
   ;	
	mov	dx,97
	in	al,dx
	and	al,252
	out	dx,al
	mov	al,0
   ;	
   ;	}
   ;	
	ret	
_uninit_irq	endp
   ;	
   ;	void timer_add_subscriber(void (*sub)(void)) {
   ;	
	assume	cs:_TEXT
_timer_add_subscriber	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		if (timer_sub_cnt == TIM_SUB_MAX)
   ;	
	cmp	byte ptr DGROUP:_timer_sub_cnt,8
	je	short @16@86
   ;	
   ;			return;
   ;		timer_subscribers[timer_sub_cnt] = sub;
   ;	
	mov	al,byte ptr DGROUP:_timer_sub_cnt
	mov	ah,0
	shl	ax,1
	mov	dx,word ptr [bp+4]
	mov	bx,ax
	mov	word ptr DGROUP:_timer_subscribers[bx],dx
   ;	
   ;		timer_sub_cnt++;
   ;	
	inc	byte ptr DGROUP:_timer_sub_cnt
@16@86:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_timer_add_subscriber	endp
   ;	
   ;	void keyb_add_subscriber(void (*sub)(void)) {
   ;	
	assume	cs:_TEXT
_keyb_add_subscriber	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		if (keyb_sub_cnt == KBD_SUB_MAX)
   ;	
	cmp	byte ptr DGROUP:_keyb_sub_cnt,8
	je	short @17@86
   ;	
   ;			return;
   ;		keyb_subscribers[keyb_sub_cnt] = sub;
   ;	
	mov	al,byte ptr DGROUP:_keyb_sub_cnt
	mov	ah,0
	shl	ax,1
	mov	dx,word ptr [bp+4]
	mov	bx,ax
	mov	word ptr DGROUP:_keyb_subscribers[bx],dx
   ;	
   ;		keyb_sub_cnt++; 
   ;	
	inc	byte ptr DGROUP:_keyb_sub_cnt
@17@86:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_keyb_add_subscriber	endp
	?debug	C E9F56C515A0C6C6962732F7461736B732E68
_TEXT	ends
_DATA	segment word public 'DATA'
_task_pool_cnt	label	byte
	db	0
_tasks_cnt	label	byte
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void create_task(unsigned char task_ind) {
   ;	
	assume	cs:_TEXT
_create_task	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	cl,byte ptr [bp+4]
   ;	
   ;		int i;
   ;		for (i = 0; i < tasks_cnt; i++) {
   ;	
	xor	si,si
	jmp	short @18@114
@18@58:
   ;	
   ;			if (tasks[i]->key == task_pool[task_ind].key)
   ;	
	mov	al,cl
	mov	ah,0
	mov	dx,6
	imul	dx
	les	bx,dword ptr DGROUP:_task_pool
	add	bx,ax
	mov	al,byte ptr es:[bx+4]
	mov	bx,si
	shl	bx,1
	shl	bx,1
	les	bx,dword ptr DGROUP:_tasks[bx]
	cmp	al,byte ptr es:[bx+4]
	je	short @18@142
	inc	si
@18@114:
	mov	al,byte ptr DGROUP:_tasks_cnt
	mov	ah,0
	cmp	ax,si
	jg	short @18@58
@18@142:
   ;	
   ;				break;
   ;		}
   ;		if (i == tasks_cnt) {
   ;	
	mov	al,byte ptr DGROUP:_tasks_cnt
	mov	ah,0
	cmp	ax,si
	je	@@7
	jmp	@18@198
@@7:
   ;	
   ;			tasks[tasks_cnt++] = &task_pool[task_ind];
   ;	
	mov	al,cl
	mov	ah,0
	mov	dx,6
	imul	dx
	mov	dx,word ptr DGROUP:_task_pool+2
	mov	bx,word ptr DGROUP:_task_pool
	add	bx,ax
	mov	al,byte ptr DGROUP:_tasks_cnt
	mov	ah,0
	shl	ax,1
	shl	ax,1
	mov	si,ax
	mov	word ptr DGROUP:_tasks[si+2],dx
	mov	word ptr DGROUP:_tasks[si],bx
	inc	byte ptr DGROUP:_tasks_cnt
   ;	
   ;			task_pool[task_ind].might_to_be_del = 1;
   ;	
	mov	al,cl
	mov	ah,0
	mov	dx,6
	imul	dx
	les	bx,dword ptr DGROUP:_task_pool
	add	bx,ax
	and	byte ptr es:[bx+5],243
	or	byte ptr es:[bx+5],4
   ;	
   ;			task_pool[task_ind].has_to_be_del = 0;
   ;	
	mov	al,cl
	mov	ah,0
	mov	dx,6
	imul	dx
	mov	bx,word ptr DGROUP:_task_pool
	add	bx,ax
	and	byte ptr es:[bx+5],252
   ;	
   ;			task_pool[task_ind].is_new = 1;
   ;	
	mov	al,cl
	mov	ah,0
	mov	dx,6
	imul	dx
	mov	bx,word ptr DGROUP:_task_pool
	add	bx,ax
	and	byte ptr es:[bx+5],207
	or	byte ptr es:[bx+5],16
@18@198:
   ;	
   ;		}
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_create_task	endp
   ;	
   ;	void task_manager() {
   ;	
	assume	cs:_TEXT
_task_manager	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;		int i;
   ;		unsigned char key = inp(0x60);
   ;	
	mov	dx,96
	in	al,dx
	mov	byte ptr [bp-1],al
   ;	
   ;		unsigned char released = key >> 7;
   ;	
	mov	ah,0
	mov	cl,7
	sar	ax,cl
	mov	byte ptr [bp-2],al
   ;	
   ;		key &= 0x7F;
   ;	
	and	byte ptr [bp-1],127
   ;	
   ;		for (i = 0; i < task_pool_cnt; i++) {
   ;	
	xor	cx,cx
	jmp	short @19@198
@19@58:
   ;	
   ;			if (task_pool[i].key == key) {
   ;	
	mov	ax,cx
	mov	dx,6
	imul	dx
	les	bx,dword ptr DGROUP:_task_pool
	add	bx,ax
	mov	al,byte ptr es:[bx+4]
	cmp	al,byte ptr [bp-1]
	jne	short @19@170
   ;	
   ;				if (released) {
   ;	
	cmp	byte ptr [bp-2],0
	je	short @19@142
   ;	
   ;					task_pool[i].has_to_be_del = 1;
   ;	
	mov	ax,cx
	mov	dx,6
	imul	dx
	mov	bx,word ptr DGROUP:_task_pool
	add	bx,ax
	and	byte ptr es:[bx+5],252
	or	byte ptr es:[bx+5],1
   ;	
   ;				} else {
   ;	
	jmp	short @19@226
@19@142:
   ;	
   ;					create_task(i);
   ;	
	push	cx
	call	near ptr _create_task
	pop	cx
	jmp	short @19@226
@19@170:
	inc	cx
@19@198:
	mov	al,byte ptr DGROUP:_task_pool_cnt
	mov	ah,0
	cmp	ax,cx
	jg	short @19@58
@19@226:
   ;	
   ;				}
   ;				break;
   ;			}
   ;		}
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
_task_manager	endp
   ;	
   ;	int run_tasks() {
   ;	
	assume	cs:_TEXT
_run_tasks	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	push	di
   ;	
   ;		int i, last_task = -1, del_cnt = 0;
   ;	
	mov	di,65535
	mov	word ptr [bp-2],0
   ;	
   ;		for (i = 0; i < tasks_cnt; i++) {
   ;	
	xor	si,si
	jmp	short @20@198
@20@58:
   ;	
   ;			if (tasks[i]->has_to_be_del && tasks[i]->might_to_be_del) {
   ;	
	mov	bx,si
	shl	bx,1
	shl	bx,1
	les	bx,dword ptr DGROUP:_tasks[bx]
	mov	al,byte ptr es:[bx+5]
	mov	cl,14
	shl	ax,cl
	sar	ax,cl
	or	al,al
	je	short @20@142
	mov	bx,si
	shl	bx,1
	shl	bx,1
	mov	bx,word ptr DGROUP:_tasks[bx]
	mov	al,byte ptr es:[bx+5]
	mov	cl,12
	shl	ax,cl
	mov	cl,14
	sar	ax,cl
	or	al,al
	je	short @20@142
   ;	
   ;				del_cnt++;
   ;	
	inc	word ptr [bp-2]
   ;	
   ;			} else {
   ;	
	jmp	short @20@170
@20@142:
   ;	
   ;				tasks[i - del_cnt] = tasks[i];
   ;	
	mov	bx,si
	shl	bx,1
	shl	bx,1
	mov	ax,word ptr DGROUP:_tasks[bx+2]
	mov	dx,word ptr DGROUP:_tasks[bx]
	mov	bx,si
	sub	bx,word ptr [bp-2]
	shl	bx,1
	shl	bx,1
	mov	word ptr DGROUP:_tasks[bx+2],ax
	mov	word ptr DGROUP:_tasks[bx],dx
   ;	
   ;				last_task = i;
   ;	
	mov	di,si
@20@170:
	inc	si
@20@198:
	mov	al,byte ptr DGROUP:_tasks_cnt
	mov	ah,0
	cmp	ax,si
	jg	short @20@58
   ;	
   ;			}
   ;		}
   ;		if (last_task >= 0)
   ;	
	or	di,di
	jl	short @20@282
   ;	
   ;			tasks[last_task]->task(tasks[last_task]);
   ;	
	mov	bx,di
	shl	bx,1
	shl	bx,1
	push	word ptr DGROUP:_tasks[bx+2]
	push	word ptr DGROUP:_tasks[bx]
	mov	bx,di
	shl	bx,1
	shl	bx,1
	les	bx,dword ptr DGROUP:_tasks[bx]
	call	dword ptr es:[bx]
	pop	cx
	pop	cx
@20@282:
   ;	
   ;		tasks_cnt -= del_cnt;
   ;	
	mov	al,byte ptr DGROUP:_tasks_cnt
	sub	al,byte ptr [bp-2]
	mov	byte ptr DGROUP:_tasks_cnt,al
   ;	
   ;		if (tasks_cnt > 0 && del_cnt)
   ;	
	cmp	byte ptr DGROUP:_tasks_cnt,0
	jbe	short @20@366
	cmp	word ptr [bp-2],0
	je	short @20@366
   ;	
   ;			tasks[tasks_cnt - 1]->is_new = 1;
   ;	
	mov	ah,0
	shl	ax,1
	shl	ax,1
	mov	bx,ax
	les	bx,dword ptr DGROUP:_tasks[bx-4]
	and	byte ptr es:[bx+5],207
	or	byte ptr es:[bx+5],16
@20@366:
   ;	
   ;		return tasks_cnt;
   ;	
	mov	al,byte ptr DGROUP:_tasks_cnt
	mov	ah,0
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_run_tasks	endp
   ;	
   ;	void create_pool(unsigned char* keys, void far(**tasks)(TASK far*), int cnt) {
   ;	
	assume	cs:_TEXT
_create_pool	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;		task_pool = (TASK far*)malloc(sizeof(TASK) * cnt);
   ;	
	mov	ax,word ptr [bp+8]
	mov	dx,6
	imul	dx
	push	ax
	call	near ptr _malloc
	pop	cx
	mov	word ptr DGROUP:_task_pool+2,ds
	mov	word ptr DGROUP:_task_pool,ax
   ;	
   ;		task_pool_cnt = cnt;
   ;	
	mov	al,byte ptr [bp+8]
	mov	byte ptr DGROUP:_task_pool_cnt,al
	jmp	short @21@114
@21@58:
   ;	
   ;		for (; cnt != -1; cnt--) {
   ;			task_pool[cnt].key = keys[cnt];
   ;	
	mov	ax,word ptr [bp+8]
	mov	dx,6
	imul	dx
	les	bx,dword ptr DGROUP:_task_pool
	add	bx,ax
	mov	si,word ptr [bp+4]
	add	si,word ptr [bp+8]
	mov	al,byte ptr [si]
	mov	byte ptr es:[bx+4],al
   ;	
   ;			task_pool[cnt].task = tasks[cnt];
   ;	
	mov	ax,word ptr [bp+8]
	shl	ax,1
	shl	ax,1
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx+2]
	mov	dx,word ptr [bx]
	push	ax
	mov	ax,word ptr [bp+8]
	mov	bx,6
	push	dx
	imul	bx
	mov	bx,word ptr DGROUP:_task_pool
	add	bx,ax
	pop	ax
	pop	dx
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
	dec	word ptr [bp+8]
@21@114:
	cmp	word ptr [bp+8],65535
	jne	short @21@58
   ;	
   ;		}
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_create_pool	endp
	?debug	C E9F56C515A096361742F6361742E68
	?debug	C E9F56C515A096361742F7265732E68
_TEXT	ends
_DATA	segment word public 'DATA'
_doom	label	word
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	185
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	185
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	185
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	185
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	165
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	136
	db	1
	db	9
	db	0
	db	238
	db	1
	db	9
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	156
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	156
	db	0
	db	79
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	156
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	6
	db	1
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	139
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	21
	db	1
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	247
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	139
	db	0
	db	13
	db	0
	db	208
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	247
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	175
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	165
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	136
	db	1
	db	9
	db	0
	db	238
	db	1
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	185
	db	0
	db	9
	db	0
	db	156
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	185
	db	0
	db	9
	db	0
	db	156
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	55
	db	1
	db	9
	db	0
	db	156
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	74
	db	1
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	136
	db	1
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	38
	db	1
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	136
	db	1
	db	9
	db	0
	db	74
	db	1
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	156
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	175
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	196
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	110
	db	0
	db	13
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	6
	db	1
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	220
	db	0
	db	9
	db	0
	db	175
	db	0
	db	9
	db	0
	db	147
	db	0
	db	9
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	79
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	117
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	123
	db	0
	db	13
	db	0
	db	131
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	165
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	147
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	82
	db	0
	db	13
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	165
	db	0
	db	9
	db	0
	db	123
	db	0
	db	9
	db	0
	db	165
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	6
	db	1
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	247
	db	0
	db	9
	db	0
	db	196
	db	0
	db	9
	db	0
	db	165
	db	0
	db	9
	db	0
	db	253
	db	255
_kbd_cat	label	word
	db	1
	db	0
	db	15
	db	0
	db	1
	db	0
	db	15
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	136
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	1
	db	0
	db	136
	db	1
	db	5
	db	0
	db	74
	db	1
	db	3
	db	0
	db	220
	db	0
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	220
	db	0
	db	3
	db	0
	db	6
	db	1
	db	1
	db	0
	db	74
	db	1
	db	5
	db	0
	db	6
	db	1
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	247
	db	0
	db	3
	db	0
	db	38
	db	1
	db	3
	db	0
	db	247
	db	0
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	247
	db	0
	db	1
	db	0
	db	38
	db	1
	db	5
	db	0
	db	247
	db	0
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	196
	db	0
	db	1
	db	0
	db	196
	db	0
	db	5
	db	0
	db	196
	db	0
	db	1
	db	0
	db	196
	db	0
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	196
	db	0
	db	1
	db	0
	db	196
	db	0
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	136
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	1
	db	0
	db	136
	db	1
	db	5
	db	0
	db	74
	db	1
	db	3
	db	0
	db	220
	db	0
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	74
	db	1
	db	3
	db	0
	db	6
	db	1
	db	3
	db	0
	db	220
	db	0
	db	3
	db	0
	db	6
	db	1
	db	1
	db	0
	db	74
	db	1
	db	5
	db	0
	db	6
	db	1
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	247
	db	0
	db	3
	db	0
	db	38
	db	1
	db	3
	db	0
	db	247
	db	0
	db	3
	db	0
	db	196
	db	0
	db	3
	db	0
	db	247
	db	0
	db	1
	db	0
	db	38
	db	1
	db	5
	db	0
	db	247
	db	0
	db	3
	db	0
	db	196
	db	0
	db	22
	db	0
	db	253
	db	255
_boom	label	word
	db	50
	db	0
	db	3
	db	0
	db	30
	db	0
	db	5
	db	0
	db	25
	db	0
	db	3
	db	0
	db	40
	db	0
	db	3
	db	0
	db	255
	db	255
_fly_l	label	word
	db	10
	db	0
	db	11
	db	0
	db	12
	db	0
	db	13
	db	0
	db	14
	db	0
	db	15
	db	0
	db	16
	db	0
	db	17
	db	0
_fly_r	label	word
	db	18
	db	0
	db	19
	db	0
	db	20
	db	0
	db	21
	db	0
	db	22
	db	0
	db	23
	db	0
	db	24
	db	0
	db	25
	db	0
_fly_bl	label	word
	db	53
	db	0
	db	54
	db	0
	db	55
	db	0
	db	56
	db	0
	db	57
	db	0
	db	58
	db	0
	db	59
	db	0
	db	60
	db	0
_fly_br	label	word
	db	61
	db	0
	db	62
	db	0
	db	63
	db	0
	db	64
	db	0
	db	65
	db	0
	db	66
	db	0
	db	67
	db	0
	db	68
	db	0
_cat_stop_r	label	word
	db	52
	db	0
_cat_stop_l	label	word
	db	51
	db	0
_cat_run_l	label	word
	db	43
	db	0
	db	44
	db	0
	db	45
	db	0
	db	46
	db	0
_cat_run_r	label	word
	db	47
	db	0
	db	48
	db	0
	db	49
	db	0
	db	50
	db	0
_cat_jump_l	label	word
	db	31
	db	0
	db	32
	db	0
	db	33
	db	0
	db	34
	db	0
	db	35
	db	0
	db	36
	db	0
_cat_jump_r	label	word
	db	37
	db	0
	db	38
	db	0
	db	39
	db	0
	db	40
	db	0
	db	41
	db	0
	db	42
	db	0
_cat_dies_l	label	word
	db	0
	db	0
	db	1
	db	0
	db	2
	db	0
	db	3
	db	0
	db	4
	db	0
_cat_dies_r	label	word
	db	5
	db	0
	db	6
	db	0
	db	7
	db	0
	db	8
	db	0
	db	9
	db	0
_b_death	label	word
	db	26
	db	0
	db	27
	db	0
	db	28
	db	0
	db	29
	db	0
	db	30
	db	0
_embient	label	word
	dw	DGROUP:_kbd_cat
_bird_dies	label	word
	dw	DGROUP:_boom
_attack	label	word
	dw	DGROUP:_doom
_cat_run	label	word
	dw	DGROUP:_cat_run_l
	dw	DGROUP:_cat_run_r
_cat_jump	label	word
	dw	DGROUP:_cat_jump_l
	dw	DGROUP:_cat_jump_r
_cat_stop	label	word
	dw	DGROUP:_cat_stop_l
	dw	DGROUP:_cat_stop_r
_cat_dies	label	word
	dw	DGROUP:_cat_dies_l
	dw	DGROUP:_cat_dies_r
_bird_flyes	label	word
	dw	DGROUP:_fly_l
	dw	DGROUP:_fly_r
_bird_bflyes	label	word
	dw	DGROUP:_fly_bl
	dw	DGROUP:_fly_br
_direction	label	byte
	db	0
_jumped	label	byte
	db	0
_b_attacs	label	byte
	db	0
_b_flyes_back	label	byte
	db	0
_b_direction	label	byte
	db	0
_b_fly_pos	label	byte
	db	0
_display_pos	label	word
	db	0
	db	0
	?debug	C E9326E515A0C6361742F68616E646C732E68
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void bird(ENTITY far* ent) {
   ;	
	assume	cs:_TEXT
_bird	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;		if (b_attacs) {
   ;	
	cmp	byte ptr DGROUP:_b_attacs,0
	je	short @22@198
   ;	
   ;			ent->y += 10;
   ;	
	les	bx,dword ptr [bp+4]
	add	word ptr es:[bx+2],10
   ;	
   ;			ent->x += (cat->x + 10 - ent->x) >> 1;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	ax,word ptr [bx]
	add	ax,10
	mov	bx,word ptr [bp+4]
	sub	ax,word ptr es:[bx]
	sar	ax,1
	add	word ptr es:[bx],ax
   ;	
   ;			ent->sprite_indexes = bird_flyes[cat->x + 10 > ent->x];
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	ax,word ptr [bx]
	add	ax,10
	mov	bx,word ptr [bp+4]
	cmp	ax,word ptr es:[bx]
	jle	short @22@114
	mov	ax,1
	jmp	short @22@142
@22@114:
	xor	ax,ax
@22@142:
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_bird_flyes[bx]
	les	bx,dword ptr [bp+4]
	mov	word ptr es:[bx+12],ds
	mov	word ptr es:[bx+10],ax
   ;	
   ;			if (ent->y >= CAT_FLOOR) {
   ;	
	cmp	word ptr es:[bx+2],150
	jge	@@8
	jmp	@22@814
@@8:
   ;	
   ;				b_attacs = 0;
   ;	
	mov	byte ptr DGROUP:_b_attacs,0
   ;	
   ;				b_flyes_back = 1;
   ;	
	mov	byte ptr DGROUP:_b_flyes_back,1
   ;	
   ;				M_stop();
   ;	
	call	near ptr _M_stop
   ;	
   ;				ent->sx = 0;
   ;	
	les	bx,dword ptr [bp+4]
	mov	byte ptr es:[bx+18],0
	jmp	@22@814
@22@198:
   ;	
   ;			}
   ;		}
   ;		else if (b_flyes_back) {
   ;	
	cmp	byte ptr DGROUP:_b_flyes_back,0
	je	short @22@282
   ;	
   ;			ent->sprite_indexes = bird_bflyes[b_direction];
   ;	
	mov	al,byte ptr DGROUP:_b_direction
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_bird_bflyes[bx]
	les	bx,dword ptr [bp+4]
	mov	word ptr es:[bx+12],ds
	mov	word ptr es:[bx+10],ax
   ;	
   ;			ent->spr_cnt = sizeof(fly_bl) >> 1;
   ;	
	mov	word ptr es:[bx+6],8
   ;	
   ;			ent->y -= 5;
   ;	
	sub	word ptr es:[bx+2],5
   ;	
   ;			if (ent->y <= BIRD_FLOOR) {
   ;	
	cmp	word ptr es:[bx+2],20
	jle	@@9
	jmp	@22@814
@@9:
   ;	
   ;				ent->y = BIRD_FLOOR;
   ;	
	mov	word ptr es:[bx+2],20
   ;	
   ;				b_flyes_back = 0;
   ;	
	mov	byte ptr DGROUP:_b_flyes_back,0
	jmp	@22@814
@22@282:
   ;	
   ;			}
   ;		} else if (ent->sprite_indexes != b_death){
   ;	
	les	bx,dword ptr [bp+4]
	mov	ax,ds
	cmp	word ptr es:[bx+12],ax
	jne	short @22@338
	cmp	word ptr es:[bx+10],offset DGROUP:_b_death
	jne	@@10
	jmp	@22@730
@@10:
@22@338:
   ;	
   ;			ent->sprite_indexes = bird_flyes[b_direction];
   ;	
	mov	al,byte ptr DGROUP:_b_direction
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_bird_flyes[bx]
	les	bx,dword ptr [bp+4]
	mov	word ptr es:[bx+12],ds
	mov	word ptr es:[bx+10],ax
   ;	
   ;			ent->spr_cnt = sizeof(fly_l) >> 1;
   ;	
	mov	word ptr es:[bx+6],8
   ;	
   ;			if (!b_fly_pos) {
   ;	
	mov	al,byte ptr DGROUP:_b_fly_pos
	mov	ah,0
	or	ax,ax
	jne	short @22@478
   ;	
   ;				b_fly_pos = B_FLY_STEPS;
   ;	
	mov	byte ptr DGROUP:_b_fly_pos,15
   ;	
   ;				b_direction ^= 1;
   ;	
	xor	byte ptr DGROUP:_b_direction,1
   ;	
   ;				ent->sx = b_direction ? 4 : -4;
   ;	
	cmp	byte ptr DGROUP:_b_direction,0
	je	short @22@422
	mov	al,4
	jmp	short @22@450
@22@422:
	mov	al,252
@22@450:
	les	bx,dword ptr [bp+4]
	mov	byte ptr es:[bx+18],al
@22@478:
   ;	
   ;			}
   ;			b_fly_pos -= 1;
   ;	
	mov	al,byte ptr DGROUP:_b_fly_pos
	add	al,255
	mov	byte ptr DGROUP:_b_fly_pos,al
   ;	
   ;			if (cat->x + 40 >= ent->x && cat->x <= ent->x + 40) {
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	ax,word ptr [bx]
	add	ax,40
	les	bx,dword ptr [bp+4]
	cmp	ax,word ptr es:[bx]
	jge	@@11
	jmp	@22@814
@@11:
	mov	bx,word ptr DGROUP:_cat
	mov	si,word ptr [bp+4]
	mov	ax,word ptr es:[si]
	add	ax,40
	cmp	word ptr [bx],ax
	jle	@@12
	jmp	@22@814
@@12:
   ;	
   ;				if (cat->y -5 > ent->y) {
   ;	
	mov	bx,word ptr [bp+4]
	mov	si,word ptr DGROUP:_cat
	mov	ax,word ptr [si+2]
	add	ax,65531
	cmp	word ptr es:[bx+2],ax
	jge	short @22@590
   ;	
   ;					b_attacs = 1;
   ;	
	mov	byte ptr DGROUP:_b_attacs,1
   ;	
   ;					M_play(attack, 1);
   ;	
	mov	ax,1
	push	ax
	mov	ax,offset DGROUP:_attack
	push	ax
	call	near ptr _M_play
	jmp	@22@786
@22@590:
   ;	
   ;				} else {
   ;					ent->hp -= 20 - (cat->x - ent->x > 0 ? cat->x - ent->x : ent->x - cat->x);
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	ax,word ptr [bx]
	les	bx,dword ptr [bp+4]
	sub	ax,word ptr es:[bx]
	jle	short @22@646
	mov	bx,word ptr DGROUP:_cat
	mov	al,byte ptr [bx]
	mov	bx,word ptr [bp+4]
	sub	al,byte ptr es:[bx]
	jmp	short @22@674
@22@646:
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx]
	mov	bx,word ptr DGROUP:_cat
	sub	al,byte ptr [bx]
@22@674:
	mov	dl,20
	sub	dl,al
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx+20]
	sub	al,dl
	mov	byte ptr es:[bx+20],al
   ;	
   ;					if (ent->hp < 155) {
   ;	
	cmp	byte ptr es:[bx+20],155
	jae	short @22@814
   ;	
   ;						ent->spr_cnt = sizeof(b_death) >> 1;
   ;	
	mov	word ptr es:[bx+6],5
   ;	
   ;						ent->sprite_indexes = b_death;
   ;	
	mov	word ptr es:[bx+12],ds
	mov	word ptr es:[bx+10],offset DGROUP:_b_death
   ;	
   ;						M_play(bird_dies, 1);
   ;	
	mov	ax,1
	push	ax
	mov	ax,offset DGROUP:_bird_dies
	push	ax
	call	near ptr _M_play
	pop	cx
	pop	cx
   ;	
   ;						ent->sx = 0;
   ;	
	les	bx,dword ptr [bp+4]
	mov	byte ptr es:[bx+18],0
   ;	
   ;						ent->sy = 0;
   ;	
	mov	byte ptr es:[bx+19],0
   ;	
   ;						ent->cur_sprite = 0;
   ;	
	mov	word ptr es:[bx+4],0
	jmp	short @22@814
@22@730:
   ;	
   ;					}
   ;				}
   ;			}
   ;		} else {
   ;			if (ent->cur_sprite == 0) {
   ;	
	les	bx,dword ptr [bp+4]
	cmp	word ptr es:[bx+4],0
	jne	short @22@814
   ;	
   ;				delete_entity(ent);
   ;	
	push	word ptr [bp+6]
	push	bx
	call	near ptr _delete_entity
@22@786:
	pop	cx
	pop	cx
@22@814:
   ;	
   ;			}
   ;		}
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_bird	endp
   ;	
   ;	void cat_handler(ENTITY far* ent) {
   ;	
	assume	cs:_TEXT
_cat_handler	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		cat->sprite_indexes = cat_stop[direction];
   ;	
	mov	al,byte ptr DGROUP:_direction
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_cat_stop[bx]
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+12],ds
	mov	word ptr [bx+10],ax
   ;	
   ;		cat->spr_cnt = sizeof(cat_stop_l) >> 1;
   ;	
	mov	word ptr [bx+6],1
   ;	
   ;		if (cat->x < 0) cat->x = 0;
   ;	
	cmp	word ptr [bx],0
	jge	short @23@86
	mov	word ptr [bx],0
@23@86:
   ;	
   ;		if (cat->y < 0) cat->y = 0;
   ;	
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx+2],0
	jge	short @23@142
	mov	word ptr [bx+2],0
@23@142:
   ;	
   ;		if (cat->x > W - 20) cat->x = W - 20;
   ;	
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx],300
	jle	short @23@198
	mov	word ptr [bx],300
@23@198:
   ;	
   ;		cat->sx = 0;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	byte ptr [bx+18],0
   ;	
   ;		cat->sy = 0;
   ;	
	mov	byte ptr [bx+19],0
   ;	
   ;		jumped = 0;
   ;	
	mov	byte ptr DGROUP:_jumped,0
   ;	
   ;		if (cat->x > 250 && display_pos > -32700) {
   ;	
	cmp	word ptr [bx],250
	jle	short @23@282
	cmp	word ptr DGROUP:_display_pos,32836
	jle	short @23@282
   ;	
   ;			display_pos = display_pos - (cat->x - 250);
   ;	
	mov	ax,word ptr [bx]
	add	ax,65286
	jmp	short @23@366
@23@282:
   ;	
   ;		} else if (cat->x < 30 && display_pos < 0) {
   ;	
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx],30
	jge	short @23@394
	cmp	word ptr DGROUP:_display_pos,0
	jge	short @23@394
   ;	
   ;			display_pos = display_pos - (cat->x - 30);
   ;	
	mov	ax,word ptr [bx]
	add	ax,65506
@23@366:
	mov	dx,word ptr DGROUP:_display_pos
	sub	dx,ax
	mov	word ptr DGROUP:_display_pos,dx
@23@394:
   ;	
   ;		}
   ;		set_back_rotation(display_pos);
   ;	
	push	word ptr DGROUP:_display_pos
	call	near ptr _set_back_rotation
	pop	cx
   ;	
   ;		if (!run_tasks()) cat->cur_sprite = 0;
   ;	
	call	near ptr _run_tasks
	or	ax,ax
	jne	short @23@450
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+4],0
@23@450:
   ;	
   ;		if (!jumped && cat->y < CAT_FLOOR) cat->y += 2;
   ;	
	mov	al,byte ptr DGROUP:_jumped
	mov	ah,0
	or	ax,ax
	jne	short @23@534
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx+2],150
	jge	short @23@534
	add	word ptr [bx+2],2
@23@534:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_cat_handler	endp
   ;	
   ;	void run_left(TASK far* task) {
   ;	
	assume	cs:_TEXT
_run_left	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		direction = LEFT;
   ;	
	mov	byte ptr DGROUP:_direction,0
   ;	
   ;		cat->sx += -4;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	al,byte ptr [bx+18]
	add	al,252
	mov	byte ptr [bx+18],al
   ;	
   ;		cat->sprite_indexes = cat_run_l;
   ;	
	mov	word ptr [bx+12],ds
	mov	word ptr [bx+10],offset DGROUP:_cat_run_l
   ;	
   ;		cat->spr_cnt = sizeof(cat_run_l) >> 1;
   ;	
	mov	word ptr [bx+6],4
   ;	
   ;		if (task->is_new) {
   ;	
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx+5]
	mov	cl,10
	shl	ax,cl
	mov	cl,14
	sar	ax,cl
	or	al,al
	je	short @24@86
   ;	
   ;			task->is_new = 0;
   ;	
	and	byte ptr es:[bx+5],207
   ;	
   ;			cat->cur_sprite = 0;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+4],0
@24@86:
   ;	
   ;		}
   ;	}
   ;	
	pop	bp
	ret	
_run_left	endp
   ;	
   ;	void run_right(TASK far* task) {
   ;	
	assume	cs:_TEXT
_run_right	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		direction = RIGHT;
   ;	
	mov	byte ptr DGROUP:_direction,1
   ;	
   ;		cat->sx = 4;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	byte ptr [bx+18],4
   ;	
   ;		cat->sprite_indexes = cat_run_r;
   ;	
	mov	word ptr [bx+12],ds
	mov	word ptr [bx+10],offset DGROUP:_cat_run_r
   ;	
   ;		cat->spr_cnt = sizeof(cat_run_r) >> 1;
   ;	
	mov	word ptr [bx+6],4
   ;	
   ;		if (task->is_new) {
   ;	
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx+5]
	mov	cl,10
	shl	ax,cl
	mov	cl,14
	sar	ax,cl
	or	al,al
	je	short @25@86
   ;	
   ;			task->is_new = 0;
   ;	
	and	byte ptr es:[bx+5],207
   ;	
   ;			cat->cur_sprite = 0;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+4],0
@25@86:
   ;	
   ;		}
   ;	}
   ;	
	pop	bp
	ret	
_run_right	endp
   ;	
   ;	void jump(TASK far* task) {
   ;	
	assume	cs:_TEXT
_jump	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		cat->sprite_indexes = cat_jump[direction];
   ;	
	mov	al,byte ptr DGROUP:_direction
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_cat_jump[bx]
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+12],ds
	mov	word ptr [bx+10],ax
   ;	
   ;		cat->spr_cnt = sizeof(cat_jump_l) >> 1;
   ;	
	mov	word ptr [bx+6],6
   ;	
   ;		cat->sx = 4 * (direction ? 1 : -1);
   ;	
	cmp	byte ptr DGROUP:_direction,0
	je	short @26@86
	mov	al,1
	jmp	short @26@114
@26@86:
	mov	al,255
@26@114:
	shl	al,1
	shl	al,1
	mov	bx,word ptr DGROUP:_cat
	mov	byte ptr [bx+18],al
   ;	
   ;		if (task->is_new) {
   ;	
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx+5]
	mov	cl,10
	shl	ax,cl
	mov	cl,14
	sar	ax,cl
	or	al,al
	je	short @26@170
   ;	
   ;			task->is_new = 0;
   ;	
	and	byte ptr es:[bx+5],207
   ;	
   ;			cat->cur_sprite = 0;
   ;	
	mov	bx,word ptr DGROUP:_cat
	mov	word ptr [bx+4],0
@26@170:
   ;	
   ;		}
   ;		task->might_to_be_del = cat->cur_sprite == ((sizeof(cat_jump_l) >> 1) - 1);
   ;	
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx+4],5
	jne	short @26@226
	mov	ax,1
	jmp	short @26@254
@26@226:
	xor	ax,ax
@26@254:
	and	ax,3
	les	bx,dword ptr [bp+4]
	and	byte ptr es:[bx+5],243
	shl	ax,1
	shl	ax,1
	or	byte ptr es:[bx+5],al
   ;	
   ;		cat->y += cat->cur_sprite < 3 ? -4 : 4;
   ;	
	mov	bx,word ptr DGROUP:_cat
	cmp	word ptr [bx+4],3
	jae	short @26@310
	mov	ax,65532
	jmp	short @26@338
@26@310:
	mov	ax,4
@26@338:
	mov	bx,word ptr DGROUP:_cat
	add	word ptr [bx+2],ax
   ;	
   ;		jumped = 1;
   ;	
	mov	byte ptr DGROUP:_jumped,1
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_jump	endp
   ;	
   ;	void exit_game(TASK far* task) {
   ;	
	assume	cs:_TEXT
_exit_game	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		on_game = 0;
   ;	
	mov	byte ptr DGROUP:_on_game,0
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_exit_game	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_cat_keys	label	byte
	db	1
	db	77
	db	75
	db	72
_cat_tasks	label	dword
	dd	_exit_game
	dd	_run_right
	dd	_run_left
	dd	_jump
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	setup() {
   ;	
	assume	cs:_TEXT
_setup	proc	near
   ;	
   ;		init_display("res.pkg");
   ;	
	mov	ax,offset DGROUP:s@+3
	push	ax
	call	near ptr _init_display
	pop	cx
   ;	
   ;		
   ;		create_entity(120, BIRD_FLOOR, 0, 0, BIRD_T, sizeof(ENTITY), fly_r, sizeof(fly_l) >> 1, bird);
   ;	
	mov	ax,offset _bird
	push	ax
	mov	ax,8
	push	ax
	mov	ax,offset DGROUP:_fly_r
	push	ax
	mov	al,22
	push	ax
	mov	al,0
	push	ax
	push	ax
	push	ax
	mov	ax,20
	push	ax
	mov	ax,120
	push	ax
	call	near ptr _create_entity
	add	sp,18
   ;	
   ;		cat = create_entity(10, CAT_FLOOR, 0, 0, CAT_T, sizeof(ENTITY), cat_stop_r, sizeof(cat_stop_r) >> 1, cat_handler);
   ;	
	mov	ax,offset _cat_handler
	push	ax
	mov	ax,1
	push	ax
	mov	ax,offset DGROUP:_cat_stop_r
	push	ax
	mov	al,22
	push	ax
	mov	al,1
	push	ax
	mov	al,0
	push	ax
	push	ax
	mov	ax,150
	push	ax
	mov	ax,10
	push	ax
	call	near ptr _create_entity
	add	sp,18
	mov	word ptr DGROUP:_cat,ax
   ;	
   ;		
   ;		create_pool(cat_keys, cat_tasks, sizeof(cat_keys));
   ;	
	mov	ax,4
	push	ax
	mov	ax,offset DGROUP:_cat_tasks
	push	ax
	mov	ax,offset DGROUP:_cat_keys
	push	ax
	call	near ptr _create_pool
	add	sp,6
   ;	
   ;		
   ;		M_play(embient, 1);
   ;	
	mov	ax,1
	push	ax
	mov	ax,offset DGROUP:_embient
	push	ax
	call	near ptr _M_play
	pop	cx
	pop	cx
   ;	
   ;	}
   ;	
	ret	
_setup	endp
   ;	
   ;	loop() {
   ;	
	assume	cs:_TEXT
_loop	proc	near
   ;	
   ;		draw_screen();
   ;	
	call	near ptr _draw_screen
   ;	
   ;	}
   ;	
	ret	
_loop	endp
   ;	
   ;	int main() {
   ;	
	assume	cs:_TEXT
_main	proc	near
   ;	
   ;		on_game = 1;
   ;	
	mov	byte ptr DGROUP:_on_game,1
   ;	
   ;		setup();
   ;	
	call	near ptr _setup
   ;	
   ;		init_irq();
   ;	
	call	near ptr _init_irq
   ;	
   ;		timer_add_subscriber(M_handler);
   ;	
	mov	ax,offset _M_handler
	push	ax
	call	near ptr _timer_add_subscriber
	pop	cx
   ;	
   ;		timer_add_subscriber(refresh_screen);
   ;	
	mov	ax,offset _refresh_screen
	push	ax
	call	near ptr _timer_add_subscriber
	pop	cx
   ;	
   ;		keyb_add_subscriber(task_manager);
   ;	
	mov	ax,offset _task_manager
	push	ax
	call	near ptr _keyb_add_subscriber
	pop	cx
	jmp	short @30@58
@30@30:
   ;	
   ;		while (on_game)
   ;			loop();
   ;	
	call	near ptr _loop
@30@58:
	cmp	byte ptr DGROUP:_on_game,0
	jne	short @30@30
   ;	
   ;		uninit_irq();
   ;	
	call	near ptr _uninit_irq
   ;	
   ;		asm {
   ;			mov ax, 2;
   ;	
	mov	 ax, 2
   ;	
   ;			int 10h;
   ;	
	int	 10h
   ;	
   ;		}
   ;		return 0;
   ;	
	xor	ax,ax
   ;	
   ;	}
   ;	
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_cat	label	word
	db	2 dup (?)
_tasks	label	dword
	db	64 dup (?)
_task_pool	label	dword
	db	4 dup (?)
_keyb_sub_cnt	label	byte
	db	1 dup (?)
_timer_sub_cnt	label	byte
	db	1 dup (?)
_old_tim	label	dword
	db	4 dup (?)
_old_kbd	label	dword
	db	4 dup (?)
_keyb_subscribers	label	word
	db	16 dup (?)
_timer_subscribers	label	word
	db	16 dup (?)
_M_melody	label	word
	db	160 dup (?)
_G_back_rotation	label	word
	db	2 dup (?)
_G_cur_back	label	byte
	db	1 dup (?)
_G_backs_cnt	label	word
	db	2 dup (?)
_G_sprites_cnt	label	word
	db	2 dup (?)
_G_ent_free	label	byte
	db	32 dup (?)
_G_entityes	label	word
	db	704 dup (?)
_G_sprites	label	dword
	db	4 dup (?)
_G_backs	label	word
	db	2 dup (?)
_G_BUFFER	label	dword
	db	4 dup (?)
_G_MEMORY	label	dword
	db	4 dup (?)
_on_game	label	byte
	db	1 dup (?)
	?debug	C E9
	?debug	C FA50010000
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'rb'
	db	0
	db	'res.pkg'
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
	extrn	DGROUP@:word
_TEXT	ends
	public	_main
	public	_loop
	public	_setup
	public	_cat_tasks
	public	_cat_keys
	public	_exit_game
	public	_jump
	public	_run_right
	public	_run_left
	public	_cat_handler
	public	_bird
	public	_display_pos
	public	_b_fly_pos
	public	_b_direction
	public	_b_flyes_back
	public	_b_attacs
	public	_jumped
	public	_direction
	public	_bird_bflyes
	public	_bird_flyes
	public	_cat_dies
	public	_cat_stop
	public	_cat_jump
	public	_cat_run
	public	_attack
	public	_bird_dies
	public	_embient
	public	_b_death
	public	_cat_dies_r
	public	_cat_dies_l
	public	_cat_jump_r
	public	_cat_jump_l
	public	_cat_run_r
	public	_cat_run_l
	public	_cat_stop_l
	public	_cat_stop_r
	public	_fly_br
	public	_fly_bl
	public	_fly_r
	public	_fly_l
	public	_boom
	public	_kbd_cat
	public	_doom
	public	_cat
	public	_create_pool
	public	_run_tasks
	public	_task_manager
	public	_create_task
	public	_tasks_cnt
	public	_task_pool_cnt
	public	_tasks
	public	_task_pool
	public	_keyb_add_subscriber
	public	_timer_add_subscriber
	public	_uninit_irq
	public	_init_irq
	public	_timer_handler
	public	_keyb_handler
	public	_keyb_sub_cnt
	public	_timer_sub_cnt
	public	_old_tim
	public	_old_kbd
	public	_keyb_subscribers
	public	_timer_subscribers
	extrn	N_LDIV@:far
	public	_M_handler
	public	_M_stop
	public	_M_play
	public	_cur_m
	public	_M_melody
	public	_intersects
	extrn	_memcpy:near
	public	_draw_screen
	public	_refresh_screen
	public	_set_back_rotation
	public	_set_back
	public	_delete_entity
	public	_create_entity
	public	_init_display
	public	_G_back_rotation
	public	_G_cur_back
	public	_G_backs_cnt
	public	_G_sprites_cnt
	public	_G_ent_free
	public	_G_entityes
	public	_G_sprites
	public	_G_backs
	public	_G_BUFFER
	public	_G_MEMORY
	public	_on_game
	extrn	_malloc:near
	extrn	_fread:near
	extrn	_fopen:near
	extrn	_fclose:near
	extrn	_setvect:near
	extrn	_getvect:near
_s@	equ	s@
	end
