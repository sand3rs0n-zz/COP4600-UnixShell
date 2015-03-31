#include "linked_list.h"
#include <stdlib.h>

linked_list *create_linked_list() {
	linked_list *linkedlist = malloc(sizeof(linked_list));
	linkedlist->start = NULL;
	linkedlist->end = NULL;
	return linkedlist;
}

void free_linked_list(linked_list *linkedlist) {
	node * current_node = linkedlist->start;
	while (current_node->next != NULL){
		free(current_node);
		current_node = current_node->next;
	} 
	free(current_node);

	// free(linkedlist);
}

void push_linked_list(linked_list *linkedlist, char *name, char *data) {
	node *new_node = malloc(sizeof(node));
	new_node->data = data;
	new_node->name_of_node = name;
	new_node->next = NULL;
	node *track = malloc(sizeof(node));
	track = linkedlist->start;
	int addNode = 1;
	while(track != NULL) {
		if(equals(track->name_of_node, name)) {
			addNode = 0;
			break;
		}
		track=track->next;
	}
	if (!addNode) {
		track->data = data;
	} else if (linkedlist->start != NULL) {
		linkedlist->end->next = new_node;
		linkedlist->end = new_node;
	} else {
		linkedlist->start = new_node;
		linkedlist->end = new_node;
	}
}

char *value_from_list(linked_list *linkedlist, char *name) {
	node *track = malloc(sizeof(node));
	track = linkedlist->start;
	const char *value = "a";
	while (track != NULL) {
		if(equals(track->name_of_node, name)) {
			value = track->data;
			break;
		}
		track = track->next;
	}
	return value;
}

void remove_node_from_list(linked_list *linkedlist, char *name) {
	node *current_node = linkedlist->start;
	node *previous_node = NULL;
	int index = 0;
	int length = 0;
	while (current_node != NULL) {
		length++;
		current_node = current_node->next;
	}
	current_node = linkedlist->start;

	while (current_node != NULL) {
		char *nodeName = current_node->name_of_node;
		if ( equals(nodeName, name) ) {
			break;
		} else {
			previous_node = current_node;
			current_node = current_node->next;
			index++;
		}
	}
	if(current_node != NULL) {
		if (index == 0) {
			previous_node = current_node->next;
			linkedlist->start = previous_node;
		} else if (index == length) {
			linkedlist->end = previous_node;
			previous_node->next = current_node->next;
		} else {
			previous_node->next = current_node->next;
		}
		current_node->next = NULL;
		free(current_node);
	}
}

void print_linked_list(linked_list *linkedlist){
	node * current_node = linkedlist->start;
	while (current_node != NULL) {
		printf("%s=",current_node->name_of_node);
		int i = 0;
		while(current_node->data[i]) {
			if(isspace(current_node->data[i])) {
				printf("\n");
			} else {
				printf("%c", current_node->data[i]);
			}
			i++;
		}
		printf("\n");
		current_node = current_node->next;
	}
}

int equals(char *value1, char *value2) {
	int i = 0;
	int len = strlen(value2);
	while ((value1[i] == value2[i]) && (i < len)) {
		i++;
	}
	if (len == i) {
		return 1;
	} else {
		return 0;
	}
}