ENTITY* cat;

#include "cat/res.h"
#include "cat/handls.h"

unsigned char cat_keys[] = {0x01, 0x4D, 0x4B, 0x48};
void far(*cat_tasks[])(TASK far*) = {exit_game, run_right, run_left, jump};

setup() {
	init_display("res.pkg");
	
	create_entity(120, BIRD_FLOOR, 0, 0, BIRD_T, sizeof(ENTITY), fly_r, sizeof(fly_l) >> 1, bird);
	cat = create_entity(10, CAT_FLOOR, 0, 0, CAT_T, sizeof(ENTITY), cat_stop_r, sizeof(cat_stop_r) >> 1, cat_handler);
	
	create_pool(cat_keys, cat_tasks, sizeof(cat_keys));
	
	M_play(embient, 2);
}

loop() {
	
}
