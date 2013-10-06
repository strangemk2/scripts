/*
0,1,2,3,4,5,6,7
0,4,1,2,3,5,6,7
0,4,1,5,2,3,6,7
0,4,1,5,2,6,3,7

0,1,2,3,4,5,6
0,4,1,2,3,5,6
0,4,1,5,2,3,6
0,4,1,5,2,6,3
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct node_
{
	int val;
	struct node_ *next;
} node, *nodep;

nodep make_list(int size);
void iterate_list(nodep list, void (*f)(nodep head, void *data), void *data);
void delete_cb(nodep, void *);
void dump_cb(nodep, void *);
void size_cb(nodep, void *);

void delete_list(nodep list);
void dump_list(nodep list);
int size_list(nodep list);

void exchange_node(nodep, nodep);
nodep walk_list(nodep head, int times);
int reorder_list(nodep list);

int main(int argc, char *argv[])
{
	if (argc != 2) return 0;
	int size = atoi(argv[1]);
	nodep p = make_list(size);
	dump_list(p);
	reorder_list(p);
	dump_list(p);
	delete_list(p);

	return 0;
}

nodep make_list(int size)
{
	nodep head;
	head = malloc(sizeof(node));
	if (head == NULL)
	{
		return NULL;
	}
	head->val = 0;

	nodep wp = head;
	for (int i = 1; i < size; i++)
	{
		nodep tnodep = malloc(sizeof(node));
		if (wp == NULL)
		{
			delete_list(head);
			return NULL;
		}

		wp->next = tnodep;
		tnodep->val = i;
		wp = tnodep;
	}
	wp->next = NULL;

	return head;
}

void iterate_list(nodep list, void (*f)(nodep head, void *data), void *data)
{
	nodep wp = list;
	while (wp != NULL)
	{
		nodep tnodep = wp->next;
		f(wp, data);
		wp = tnodep;
	}
}

void delete_cb(nodep node, void *data)
{
	free(node);
}

void dump_cb(nodep node, void *data)
{
	printf("%d, ", node->val);
}

void size_cb(nodep node, void *data)
{
	int *psize = (int *)data;
	(*psize)++;
}

void delete_list(nodep list)
{
	iterate_list(list, delete_cb, NULL);
}

void dump_list(nodep list)
{
	iterate_list(list, dump_cb, NULL);
	printf("\n");
}

int size_list(nodep list)
{
	int size = 0;
	iterate_list(list, size_cb, &size);
	return size;
}

nodep walk_list(nodep head, int times)
{
	nodep ret = head;
	for (int i = 0; i < times; i++)
	{
		ret = ret->next;
	}
	return ret;
}

void exchange_node(nodep preva, nodep prevb)
{
	nodep a = preva->next;
	nodep b = prevb->next;
	//nodep anext = a->next;
	nodep bnext = b->next;

	preva->next = b;
	b->next = a;

	prevb->next = bnext;
}

int reorder_list(nodep list)
{
	int size = size_list(list);
	if (size <= 2) return 0;

	int half_size = (int)round(size / 2.0)-1;
	printf("%d, %d\n", size, half_size);

	nodep sourcep = walk_list(list, half_size);
	nodep destp = walk_list(list, 0);
	while ((destp != sourcep) && (sourcep->next != NULL))
	{
		exchange_node(destp, sourcep);

		destp = walk_list(destp, 2);
	}

	return 0;
}
