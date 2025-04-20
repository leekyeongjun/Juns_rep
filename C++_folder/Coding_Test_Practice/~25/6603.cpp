#include <iostream>
#include <vector>
#include <string>
using namespace std;

void Combination(vector<string> results, vector<int> arr, vector<int> comb, int index, int depth)
{
    if (depth == comb.size())
    {
        for (int i = 0; i < comb.size(); i++)
        {
            results.push_back(to_string(comb[i]));
        }
        results.push_back("/n");
        return;
    }
    else
    {
        for (int i = index; i < arr.size(); i++)
        {
            comb[depth] = arr[i];
            Combination(results, arr, comb, i + 1, depth + 1);
        }
    }
}
int main()
{
    int index = 1;
    vector<string> results;

    while (index != 0)
    {
        vector<int> numarr;

        cin >> index;
        int r = 6 - index;
        vector<int> comb(r);
        for (int i = 0; i < index; i++)
        {
            int a;
            cin >> a;
            numarr.push_back(a);
        }
        Combination(results, numarr, comb, 0, 0);
    }
    for (int i = 0; i < results.size(); i++)
    {
        cout << results[i];
    }
}
