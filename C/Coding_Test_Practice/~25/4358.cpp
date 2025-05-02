#include <iostream>
#include <cstdio>
#include <map>
#include <string> 
using namespace std;

int main()
{
	float count=0;
	map<string, float> trees;

	while(true)
	{
		string tree;
		map<string, float>::iterator m_it;
		getline(cin,tree);

		if(cin.eof())
		{
			break;
		}

		m_it = trees.find(tree);
		
		if(m_it != trees.end()){
			m_it->second += 1;
		}
		
		else{
			trees.insert(make_pair(tree, 1));
		}
		count ++;
	}

	for(auto& mypair : trees)
	{
		cout << mypair.first;
		printf(" %.4f\n", (((mypair.second)/count)*100) );
	}

}