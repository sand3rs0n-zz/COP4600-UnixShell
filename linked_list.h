#ifndef LINKED_LIST_H
#define LINKED_LIST_H

typedef struct node {
	char *data;
	char *name_of_node;
	struct node *next;
} node;


typedef struct linked_list{
	struct node *start;
	struct node *end;
} linked_list;


linked_list *create_linked_list();

void free_linked_list(linked_list *linkedlist);

void push_linked_list(linked_list *linkedlist, char *name, char *data);

void remove_node_from_list(linked_list *linkedlist, char *name);

void print_linked_list(linked_list *linkedlist);

char *value_from_list(linked_list *linkedlist, char *name);

char *recursive_expansion(linked_list *linkedlist, linked_list *recursivelist, char *word);

#endif