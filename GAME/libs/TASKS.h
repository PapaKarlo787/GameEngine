typedef struct _TASK {
	void far(*task)(void far*);
	char key;
	char has_to_be_del : 2;
	char might_to_be_del : 2;
	char is_new : 2;
	char res : 2;
} TASK;

TASK far* task_pool;
TASK far* tasks[16];
unsigned char task_pool_cnt = 0;
unsigned char tasks_cnt = 0;

void create_task(unsigned char task_ind) {
	int i;
	for (i = 0; i < tasks_cnt; i++) {
		if (tasks[i]->key == task_pool[task_ind].key)
			break;
	}
	if (i == tasks_cnt) {
		tasks[tasks_cnt++] = &task_pool[task_ind];
		task_pool[task_ind].might_to_be_del = 1;
		task_pool[task_ind].has_to_be_del = 0;
		task_pool[task_ind].is_new = 1;
	}
}

void task_manager() {
	int i;
	unsigned char key = inp(0x60);
	unsigned char released = key >> 7;
	key &= 0x7F;
	for (i = 0; i < task_pool_cnt; i++) {
		if (task_pool[i].key == key) {
			if (released) {
				task_pool[i].has_to_be_del = 1;
			} else {
				create_task(i);
			}
			break;
		}
	}
}

int run_tasks() {
	int i, last_task = -1, del_cnt = 0;
	for (i = 0; i < tasks_cnt; i++) {
		if (tasks[i]->has_to_be_del && tasks[i]->might_to_be_del) {
			del_cnt++;
		} else {
			tasks[i - del_cnt] = tasks[i];
			last_task = i;
		}
	}
	if (last_task >= 0)
		tasks[last_task]->task(tasks[last_task]);
	tasks_cnt -= del_cnt;
	if (tasks_cnt > 0 && del_cnt)
		tasks[tasks_cnt - 1]->is_new = 1;
	return tasks_cnt;
}

void create_pool(unsigned char* keys, void far(**tasks)(TASK far*), int cnt) {
	task_pool = (TASK far*)malloc(sizeof(TASK) * cnt);
	task_pool_cnt = cnt;
	for (; cnt != -1; cnt--) {
		task_pool[cnt].key = keys[cnt];
		task_pool[cnt].task = tasks[cnt];
	}
}
