#include "linked_list.h"
#include <stdlib.h>
#include <string.h>

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
	int found = 0;
	const char *value = "Does not Exist";
	while (track != NULL) {
		if(equals(track->name_of_node, name)) {
			value = track->data;
			found = 1;
			break;
		}
		track = track->next;
	}
	if (found) {
		linked_list *recursivelist = create_linked_list();
		push_linked_list(recursivelist, track->name_of_node, track->data);
		char *newvalue = recursive_expansion(linkedlist, recursivelist, value);
		return newvalue;
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
		printf("%s=%s\n",current_node->name_of_node, current_node->data);
		current_node = current_node->next;
	}
}

int equals(char *value1, char *value2) {
	int i = 0;
	int len = strlen(value1);
	int len2 = strlen(value2);
	if(len != len2) {
		return 0;
	}
	while ((value1[i] == value2[i]) && (i < len)) {
		i++;
	}
	if (len == i) {
		return 1;
	} else {
		return 0;
	}
}

char *recursive_expansion(linked_list *linkedlist, linked_list *recursivelist, char *word) {
	node *track = malloc(sizeof(node));
	track = linkedlist->start;
	node *innertrack = malloc(sizeof(node));
	innertrack = linkedlist->start;
	node *recursivetrack = malloc(sizeof(node));
	recursivetrack = recursivelist->start;
	char* newword = malloc(sizeof(word));
	newword = word;
	int i = 0;
	int length = strlen(word);
	char *subword = "a";
	int spaces = 0;
	for (int i = 0; i < length; i++) {
		if (isspace(track->data[i])) {
			spaces++;
		}
	}
	if (spaces == 0) {
			while(recursivetrack != NULL) {
				if (equals(recursivetrack->name_of_node, newword)) {
					newword = "Infinite loop";
					return newword;
				} else {
					recursivetrack = recursivetrack->next;
				}
			}
		while (track != NULL) {
			if (equals(newword, track->name_of_node)){
				newword = track->data;
				push_linked_list(recursivelist, track->name_of_node, track->data);
				subword = recursive_expansion(linkedlist, recursivelist, newword);
				newword = subword;
			} else{
				track = track->next;
			}
		}
		return newword;
	}
/*
	for (int i = 0; i < length; i++) {
		if (isspace(track->data[i])) {
			for (int j = 0; j < i; j++) {
				subword[j] = track->data[j];
			}
		}
		while (innertrack != NULL) {
			if(equals(subword, innertrack->name_of_node)){
				subword = innertrack->data;
				break;
			}
			innertrack = innertrack->next;
		}
		strcat(newword, subword);
	}*/
	return word;
}