    #include <iostream>
    #include <queue>

    using namespace std;

    int main()
    {
        ios::sync_with_stdio(0);
        cin.tie(NULL);
        cout.tie(NULL);

        priority_queue<int, vector<int>, greater<int>> pq;

        int N,K;
        cin >> N >> K;

        for(int i = 0; i<N; i++){
            int buf;
            cin >> buf;
            pq.push(buf);
        }

        for(int i = 1; i<K; i++){
            pq.pop();
        }

        cout << pq.top() << '\n';
    }