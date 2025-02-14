#include "dos.h"
#include "stdio.h"
#include "stdlib.h"
#include "libs/display.h"
char on_game;
#include "libs/music.h"
#include "libs/irq.h"
#include "crz_cat.h"

/* TODO
 * музыкальная очередь, чтобы проигрывать эффекты
 * взаимодействие конкурируюших персонажей
 * управление игроком
 * удаление персонажей из памяти
 * поддержка других видеорежимов
 * расширяемость свойств персонажей
 * нахождение вне экрана
*/

int main() {
	on_game = 1;
	setup();
	init_irq();
	timer_add_subscriber(M_handler);
	timer_add_subscriber(refresh_screen);
	while (on_game)
		loop();
	uninit_irq();
	asm {
		mov ax, 2;
		int 10h;
	}
	return 0;
}
