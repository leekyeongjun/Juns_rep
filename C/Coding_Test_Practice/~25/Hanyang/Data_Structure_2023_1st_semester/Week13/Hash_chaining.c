#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define KEY_SIZE 10
#define TABLE_SIZE 5
#define equal(e1,e2) (!strcmp(e1.key, e2.key))

typedef struct Element{
    char key[KEY_SIZE];

}Element;

typedef struct ListNode
{
    Element item;
    struct ListNode* link;
}ListNode;

ListNode* hashtable[TABLE_SIZE];

void initTable(ListNode* ht[]){
    int i;
    for(i = 0; i<TABLE_SIZE; i++)
        ht[i] = NULL;
}

int transform(char *key){
    int i;
    int number = 0;
    int size = strlen(key);
    for(i = 0; i<size; i++){
        number += key[i];
    }
    return number;
}

int hashFunction(char * key){
    return transform(key) % TABLE_SIZE;
}

void addHashTable(Element item, ListNode* ht[]){
    int hashValue = hashFunction(item.key);
    ListNode *ptr;
    ListNode *node = ht[hashValue];
    for(; node; node = node->link){
        if(equal(node->item, item)){
            printf("Multiple insertion error.\n");
            return;
        }
    }
    ptr = (ListNode*)malloc(sizeof(ListNode));
    ptr->item = item;
    ptr->link = ht[hashValue];
    ht[hashValue] = ptr;
}

void hashSearch(Element item, ListNode* ht[]){
    ListNode *node;
    int hashValue = hashFunction(item.key);
    for(node = ht[hashValue]; node; node= node->link){
        if(equal(node->item, item)){
            printf("Found, exists.\n");
            return;
        }
    }
    printf("None.\n");
}

void printHashTable(ListNode* ht[]){
    int i; 
    ListNode *temp;
    for(i = 0; i<TABLE_SIZE; i++){
        temp = ht[i];
        for(; temp; temp=temp->link){
            printf("%s\t", temp->item.key);
        }
        printf("\n");
    }
}
