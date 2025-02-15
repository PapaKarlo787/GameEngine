#include "dos.h"
#include "stdio.h"
#include "stdlib.h"
char on_game;
#include "libs/display.h"
#include "libs/music.h"
#include "libs/irq.h"
#include "libs/tasks.h"
#include "cat/cat.h"

/* TODO
 * взаимодействие конкурируюших персонажей
 * управление игроком
 * поддержка других видеорежимов
*/

int main() {
	on_game = 1;
	setup();
	init_irq();
	timer_add_subscriber(M_handler);
	timer_add_subscriber(refresh_screen);
	keyb_add_subscriber(task_manager);
	while (on_game)
		loop();
	uninit_irq();
	asm {
		mov ax, 2;
		int 10h;
	}
	return 0;
}
