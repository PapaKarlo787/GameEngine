void bird(ENTITY far* ent) {
	if (b_attacs) {
		ent->y += 10;
		ent->x += (cat->x + 10 - ent->x) >> 1;
		ent->sprite_indexes = bird_flyes[cat->x + 10 > ent->x];
		if (ent->y >= CAT_FLOOR) {
			b_attacs = 0;
			b_flyes_back = 1;
			M_stop();
			ent->sx = 0;
		}
	}
	else if (b_flyes_back) {
		ent->sprite_indexes = bird_bflyes[b_direction];
		ent->spr_cnt = sizeof(fly_bl) >> 1;
		ent->y -= 5;
		if (ent->y <= BIRD_FLOOR) {
			ent->y = BIRD_FLOOR;
			b_flyes_back = 0;
		}
	} else if (ent->sprite_indexes != b_death){
		ent->sprite_indexes = bird_flyes[b_direction];
		ent->spr_cnt = sizeof(fly_l) >> 1;
		if (!b_fly_pos) {
			b_fly_pos = B_FLY_STEPS;
			b_direction ^= 1;
			ent->sx = b_direction ? 4 : -4;
		}
		b_fly_pos -= 1;
		if (cat->x + 40 >= ent->x && cat->x <= ent->x + 40) {
			if (cat->y -5 > ent->y) {
				b_attacs = 1;
				M_play(attack, 1);
			} else {
				ent->hp -= 20 - (cat->x - ent->x > 0 ? cat->x - ent->x : ent->x - cat->x);
				if (ent->hp < 155) {
					ent->spr_cnt = sizeof(b_death) >> 1;
					ent->sprite_indexes = b_death;
					M_play(bird_dies, 1);
					ent->sx = 0;
					ent->sy = 0;
					ent->cur_sprite = 0;
				}
			}
		}
	} else {
		if (ent->cur_sprite == 0) {
			delete_entity(ent);
		}
	}
}

void cat_handler(ENTITY far* ent) {
	cat->sprite_indexes = cat_stop[direction];
	cat->spr_cnt = sizeof(cat_stop_l) >> 1;
	if (cat->x < 0) cat->x = 0;
	if (cat->y < 0) cat->y = 0;
	if (cat->x > W - 20) cat->x = W - 20;
	cat->sx = 0;
	cat->sy = 0;
	jumped = 0;
	if (cat->x > 250 && display_pos > -32700) {
		display_pos = display_pos - (cat->x - 250);
	} else if (cat->x < 30 && display_pos < 0) {
		display_pos = display_pos - (cat->x - 30);
	}
	set_back_rotation(display_pos);
	if (!run_tasks()) cat->cur_sprite = 0;
	if (!jumped && cat->y < CAT_FLOOR) cat->y += 2;
}

void run_left(TASK far* task) {
	direction = LEFT;
	cat->sx += -4;
	cat->sprite_indexes = cat_run_l;
	cat->spr_cnt = sizeof(cat_run_l) >> 1;
	if (task->is_new) {
		task->is_new = 0;
		cat->cur_sprite = 0;
	}
}

void run_right(TASK far* task) {
	direction = RIGHT;
	cat->sx = 4;
	cat->sprite_indexes = cat_run_r;
	cat->spr_cnt = sizeof(cat_run_r) >> 1;
	if (task->is_new) {
		task->is_new = 0;
		cat->cur_sprite = 0;
	}
}

void jump(TASK far* task) {
	cat->sprite_indexes = cat_jump[direction];
	cat->spr_cnt = sizeof(cat_jump_l) >> 1;
	cat->sx = 4 * (direction ? 1 : -1);
	if (task->is_new) {
		task->is_new = 0;
		cat->cur_sprite = 0;
	}
	task->might_to_be_del = cat->cur_sprite == ((sizeof(cat_jump_l) >> 1) - 1);
	cat->y += cat->cur_sprite < 3 ? -4 : 4;
	jumped = 1;
}

void exit_game(TASK far* task) {
	on_game = 0;
}
