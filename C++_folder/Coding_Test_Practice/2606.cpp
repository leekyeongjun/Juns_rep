#include <iostream>
#include <stack>
#include <vector>

using namespace std;


class Computer
{
	int num;
	Computer * l_link;
	Computer * r_link;
	bool visited;
	
	public:
	Computer(int n){num = n; l_link=NULL; r_link=NULL; visited = false;}

	int islinked() {
		if(l_link == NULL && r_link == NULL)
		{
			return 0;
		}
		else if (l_link == NULL && r_link != NULL)
		{
			return 1;
		}
		else if (l_link != NULL && r_link ==NULL)
		{
			return 2;
		}
		else
		{
			return 3;
		}
	}
	void linkleft(Computer *l ){l_link= l;}
	void linkright(Computer *r){r_link = r;}
	void isvisited() {visited = true;}
	bool getvisited(){return visited;}
	int getnum(){return num;}
	Computer * getright(){return r_link;}
	Computer * getleft(){return l_link;}
};

stack<Computer *> st;
void execute_virus(Computer * start){

	if(start->getvisited()){ return;}
	start->isvisited();

	if(start->islinked() == 3){ 
		execute_virus(start->getleft());
		execute_virus(start->getright());
	}
	else if(start->islinked() == 1){
		execute_virus(start->getright());
	}
	else if(start->islinked() == 2){
		execute_virus(start->getleft());
	}
}

int main()
{
	vector<Computer*> Computers;
	int n, linknum;
	cin >> n >> linknum;
	for(int i = 0; i<n; i++)
	{
			Computer * newcom = new Computer(i);
			Computers.push_back(newcom);
	}

	int size = Computers.size();

	while(linknum>0)
	{
		int f, s;
		cin >> f >> s;
		f-=1;
		s-=1;
		if(Computers[f]->islinked() == 0 || Computers[f]->islinked() == 1)
		{
			Computers[f]->linkleft(Computers[s]);
			linknum --;
			//cout << s+1 << "<-" << f+1 << endl;
		}
		else if(Computers[f]->islinked() == 0 || Computers[f]->islinked() == 2)
		{
			Computers[f]->linkright(Computers[s]);
			linknum --;
			//cout << f+1 << "->" << s+1 << endl;
		}
	}
	execute_virus(Computers[0]);

	int count=0;
	for(int i=1; i<Computers.size(); i++)
	{
		if(Computers[i]->getvisited())
		{
			count ++;
		}
	}
	cout << count << endl;
}
