#include <stdio.h>
#include <dos.h>
#include <conio.h>

#define TIM_SUB_MAX 8
#define KBD_SUB_MAX 8
#define TIM_VECT 8
#define KBD_VECT 9

void (*timer_subscribers[TIM_SUB_MAX])(void);
void (*keyb_subscribers[KBD_SUB_MAX])(void);
void interrupt (*old_kbd)(void);
void interrupt (*old_tim)(void);
unsigned char timer_sub_cnt;
unsigned char keyb_sub_cnt;

void interrupt keyb_handler() {
	int i;
	for (i = 0; i < KBD_SUB_MAX && keyb_subscribers[i]; i++) {
		keyb_subscribers[i]();
	}
	old_kbd();
}

void interrupt timer_handler() {
	int i;
	for (i = 0; i < timer_sub_cnt; i++) {
		timer_subscribers[i]();
	}
	outp(0x40, 1193 & 255);
	outp(0x40, 1193 >> 8);
	old_tim();
}

void init_irq() {
	asm {cli};
	outp(0x43, 0x30);
	outp(0x40, 1193 & 255);
	outp(0x40, 1193 >> 8);
	old_tim = getvect(TIM_VECT);
	setvect(TIM_VECT, timer_handler);
	timer_sub_cnt = 0;
	old_kbd = getvect(KBD_VECT);
	setvect(KBD_VECT, keyb_handler);
	keyb_sub_cnt = 0;
	asm {sti};
}

void uninit_irq() {
	setvect(TIM_VECT, old_tim);
	setvect(KBD_VECT, old_kbd);
	outp(0x61, inp(0x61) & 252);
}

void timer_add_subscriber(void (*sub)(void)) {
	if (timer_sub_cnt == TIM_SUB_MAX)
		return;
	timer_subscribers[timer_sub_cnt] = sub;
	timer_sub_cnt++;
}

void keyb_add_subscriber(void (*sub)(void)) {
	if (keyb_sub_cnt == KBD_SUB_MAX)
		return;
	keyb_subscribers[keyb_sub_cnt] = sub;
	keyb_sub_cnt++; 
}
