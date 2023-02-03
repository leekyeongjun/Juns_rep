#include <iostream>

using namespace std;

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    long S[1000001] = {0,};
    long D[1000001] = {0,};

    int N, M;
    long A = 0;
    cin >> N >> M;

    for(int i = 1; i<=N; i++){
        long a;
        cin >> a;
        S[i] = (S[i-1]+a) % M;
        if(S[i] == 0) A++;
        D[S[i]]++;
    }

    for(int i = 0; i<M; i++){
        long tmp = D[i] * (D[i]-1)/2;
        A += tmp;
    }

    cout << A << '\n';
    

}