#include <iostream>

using namespace std;

class Node
{
public:
    Node *next;
    int data;
};

class CLL
{
public:
    Node *tail;
    Node *cur;
    Node *before;
    int numOfData;
};

void CLLInsert(CLL *c, int data)
{
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->data = data;
    if (c->tail == NULL)
    {
        c->tail = newNode;
        newNode->next = newNode;
    }
    else
    {
        newNode->next = c->tail->next;
        c->tail->next = newNode;
    }
    (c->numOfData)++;
}

int CLLRemove(CLL *c)
{
    Node *rpos = c->cur;
    int rData = rpos->data;

    if (rpos == c->tail)
    {
        if (c->tail == c->tail->next)
        {
            c->tail = NULL;
        }
        else
        {
            c->tail = c->before;
        }
    }
    c->before->next = c->cur->next;
    c->cur = c->before;

    free(rpos);
    (c->numOfData)--;
    return rData;
}

int CLLFirst(CLL *c, int *data)
{
    if (c->tail == NULL)
        return false;
    c->before = c->tail;
    c->cur = c->tail->next;

    *data = c->cur->data;
    return true;
}

int CLLNext(CLL *c, int *data)
{
    if (c->tail == NULL)
    {
        return false;
    }
    c->before = c->cur;
    c->cur = c->cur->next;

    *data = c->cur->data;
    return true;
}

int main()
{
    CLL *List;
    int command, index;
    int *it;

    for (int i = 0; i < command; i++)
    {
        CLLInsert(List, i + 1);
    }

    CLLFirst(List, it);
    cout << "<";
    while (true)
    {
        for (int i = 0; i < index; i++)
        {
            CLLNext(List, it);
        }
        cout << CLLRemove(List) << ", ";
    }
    cout << ">";
}