#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;
bool compare(pair<int, pair<string, int>> a, pair<int, pair<string, int>> b)
{
   if(a.first == b.first)
   {
      return a.second.second < b.second.second;
   }
   else
   {
      return a.first < b.first;
   }
}
int main()
{
   int n;
   cin >> n;
   vector<pair<int, pair<string,int>>> users;
   for(int i = 0; i< n; i++)
   {
      int age;
      string name;
      cin >> age >> name;
      users.push_back(pair< int, pair<string,int> >(age, pair<string,int>(name,i)));
   }
   sort(users.begin(), users.end(), compare);

   for(auto& mypair : users)
   {
      cout << mypair.first << " " << mypair.second.first << '\n';
   }
} 
