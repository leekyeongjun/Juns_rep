#include <stdio.h>
#define MAX_POLYS 200

typedef struct term {
	int coef;
	int expo;
	term *next;
}Term;

typedef struct polynomial{
	char name;
	Term *first;
	int size = 0;	
}Polynomial;

Polynomial *polys[MAX_POLYS];
int n = 0;

Term *create_term_instance(){
	Term* t = new Term;
	t->expo = 0;
	t-> coef = 0;
	return t;
}

Polynomial *create_polynomial_instance(char _name){
	Polynomial *ptr_poly = new Polynomial;
	ptr_poly -> name = _name;
	ptr_poly -> first = NULL;
	return ptr_poly;
}


void add_term(int c, int e, Polynomial *poly){
	if(c == 0)
		return;
	Term *p = poly->first, *q = NULL;
	while(p!= NULL && p->expo > e){
		q = p;
		p = p->next;
	}
	if(p!= NULL && p->expo == e){
		p->coef += c;
		if(p->coef == 0){
			if(q==NULL)
				poly->first = p->next;
			else
				q->next = p->next;
			poly->size --;
			delete p;
		}
		return;
	}

	Term *term = create_term_instance();
	term -> coef = c;
	term -> expo = e;
	
	//add_first
	if(q==NULL){
		term->next = poly->first;
		poly->first = term;
	}
	else{
		term -> next = p;
		q->next = term;
	}
	poly->size ++;
}


int eval(Term *term, int x){
	int result = term->coef;
	for(int i = 0; i<term->expo; i++){
		result *= x;
	}
	return result;
}
int eval(Polynomial *poly, int x){
	int result = 0;
	Term *t = poly->first;
	while(t != NULL){
		result += eval(t,x);
		t = t->next;
	}
	return result;
}


void print_term(Term *pTerm){
	printf("%dx^%d", pTerm->coef, pTerm -> expo);
}
void print_poly(Polynomial *p){
	printf("%c=", p->name);
	Term *t = p->first;
	while(t!=NULL){
		print_term(t);
		printf("+");
		t= t->next;
	}
}


