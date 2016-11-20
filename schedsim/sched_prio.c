#include "sched.h"

static task_t* pick_next_task_prio(runqueue_t* rq, int cpu){
	task_t *t = head_slist(&rq->tasks);
	
	if (t){
		remove_slist(&rq->tasks, t);
		rq->nr_runnable--;
	}
	
	return t;
}

static int compare_tasks_cpu_prioriti(void *t1, void *t2){
	task_t *tsk1=(task_t*)t1;
	task_t *tsk2=(task_t*)t2;
	
	return tsk1->prio-tsk2->prio;
}

static void enqueue_task_prio(task_t* t, int cpu, int runnable){
	runqueue_t *rq = get_runqueue_cpu(cpu);

	if (t->on_rq || is_idle_task(t))
		return;
	
	if (t->flags & TF_INSERT_FRONT){
		t->flags&=~TF_INSERT_FRONT;
		sorted_insert_slist_front(&rq->tasks, t, 1, compare_tasks_cpu_prioriti);
	}
	else
		sorted_insert_slist(&rq->tasks, t, 1, compare_tasks_cpu_prioriti);	

	if (!runnable){
		task_t *current=rq->cur_task;
		
		if (preemptive_scheduler && !is_idle_task(current) && t->prio<current->runnable_ticks_left){
			rq->need_resched=TRUE;
			current->flags|=TF_INSERT_FRONT;
		}
	}
}

static task_t* steal_task_prio(runqueue_t* rq, int cpu){
	task_t *t = tail_slist(&rq->tasks);
	
	if (t){
		remove_slist(&rq->tasks, t);
		t->on_rq=FALSE;
		rq->nr_runnable--;
	}
	
	return t;
}

sched_class_t prio_sched = {
	.pick_next_task = pick_next_task_prio,
	.enqueue_task = enqueue_task_prio,
	.steal_task = steal_task_prio
};









