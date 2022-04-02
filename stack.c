#include "stack.h"
#include <stdio.h>
#include <stdlib.h>

/*
 * You might want to declare some global variables to
 * help you maintain the stack, and the state of the stack.
 * Once you have implemented push and pop here and corresponding
 * parts in operate.c - we highly recommend checking out
 * tests/stack_test and running it to see if you are getting expected
 * output - to check basic stack functionality. You could write similar
 * tests for other functionalities.
 */

/* push a value to the stack */
static int total_nodes = 0;
node_t *top = NULL;
void push(int val) {
	node_t *new_node;
	new_node = NULL;
	new_node =  malloc(sizeof(node_t));
	if(new_node == NULL){
		printf("Error malloc for new node\n ");
		exit(1);
	}
	new_node->val = val;
	new_node->next = top;
	top = new_node;
	total_nodes = total_nodes + 1;
}
/* pop a value from the stack
 * return 0 if pop failed, else return 1 and set *v
 */
int pop(int* v) {
	if(total_nodes>0){
		node_t *tmp;
		tmp = top;
		*v = tmp->val;
		top = top->next;
		free(tmp);
		total_nodes = total_nodes - 1;
		return 1;
	}
	else {
		return 0 ;
	}
}
/* print the entire stack */
void printstack() {
	node_t *tmp;
	tmp = top;
	int i;
	i = get_stack_size() -1;
	while(tmp != NULL) {
	printf("\tS%d:\t%d\n",i,tmp->val);
	tmp =  tmp->next;
	i = i - 1;
	}
}

/* the topmost entry becomes the lowest entry in the stack */
void rot() {
	int x, j, y, *z, arr[total_nodes] ;
	z = &x;
	j = 0;
	y = 0;
	while( pop(z) == 1) {
		arr[j] = *z;
		j = j + 1;
	}
	while(y<j){
		push(arr[y]);
		y = y + 1;
	}
}

/* returns the size of the stack */
unsigned int get_stack_size() {
	return total_nodes;
}

/* delete all entries in the stack, free all memory associated with it */
void delete_stack() {
	node_t *tmp;
	tmp = top;
	while(tmp!=NULL){
		tmp = top->next;
		free(top);
		top = tmp;
	}
}
