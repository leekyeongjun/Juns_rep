#include <iostream>
#include <set>
#include <vector>
using namespace std;

class tree
{
	string _name;
	int _num;

	public:
	
	tree(string n){_name = n, _num=1;}
	void Addnum{_num += 1;}
	void SetName(string n){_name = n;}
	int GetNum(){return _num;}
	string GetName(){return _name;}
};
int main()
{
	set<string> name_list;
	set<string>::iterator n_it;
	set<trees>::iterator t_it;
	set<trees> trees;
	while(true)
	{
		string name;
		cin >> name
		n_it = name_list.find(name);
		if(n_it == s.end()){
			tree newtree = new tree();
			
			name_list.insert(name);
			trees.insert(tree(name));
		}
		else
		{
			t_it = trees.find(name);
			t_it->AddNum();
		}
	}
}
