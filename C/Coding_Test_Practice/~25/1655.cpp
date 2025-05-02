#include <iostream>
#include <vector>
#include <list>
#include <string>
#include <queue>
using namespace std;
int main() {
    priority_queue<int> maxHeap;
    priority_queue<int, vector<int>, greater<int> > minHeap;
    int n;
    cin >> n;
    for (int i = 0; i < n; i++) {
        int num;
        cin >> num;
        
        if (maxHeap.size() == minHeap.size()) {
            maxHeap.push(num);
        }
        else {
            minHeap.push(num);
        }
        if (!minHeap.empty() && !maxHeap.empty() && minHeap.top() < maxHeap.top()) {
            int a = maxHeap.top(), b = minHeap.top();
            maxHeap.pop();
            minHeap.pop();
            maxHeap.push(b);
            minHeap.push(a);
        }
        cout << maxHeap.top() << '\n';
    }
    
}