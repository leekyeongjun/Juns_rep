#include <iostream>
#include <vector>
using namespace std;
 
class Num{
    public:
    int first;
    int second;
    int third;
 
    Num(int f, int s, int t){
        first=f;
        second=s;
        third=t;
    }
};
 
class Score
{
    public:
    int strike = 0;
    int ball = 0;
};
 
//baseball part
Score Baseball(Num* base , Num* compare)
{
    Score myscore;
 
    if(base->first == compare->first){myscore.strike+=1;}
    if(base->second == compare->second){myscore.strike+=1;}
    if(base->third == compare->third){myscore.strike += 1;}
 
    if(base->first == compare->second || base->first == compare->third){myscore.ball +=1;}
    if(base ->second == compare ->first || base->second == compare -> third){myscore.ball +=1;}
    if(base->third == compare->first || base->third == compare->second){myscore.ball+=1;}
 
    return myscore;
}
 
 
int main() {
    ios::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
 
    //brute force! (insert everything)
    vector<Num*> arr;
    for(int i = 1; i<10; i++){
        for(int j= 1; j<10; j++){
            for(int k=1; k<10; k++){
                if(j== i || k==j || k==i){continue;}
                arr.push_back(new Num(i,j,k));
            }
        }
    }
 
    int trial;
    cin >> trial;
    
    for(int j = 0; j<trial; j++){
        int n , strike, ball;
        cin >> n >> strike >> ball;
        
        //dividing nums
        int f,s,t;
        f = n/100;
        s = (n - (n/100*100 + n%10))/10;
        t = n%10;
        Num* number = new Num(f,s,t);
        
        //checking part - erase 대신 백의자릿수를 -1로 바꿔줌
        for(int i = 0; i<arr.size(); i++)
        {
            if(arr[i]->first == -1){continue;}
            if(Baseball(number,arr[i]).strike == strike && Baseball(number,arr[i]).ball == ball){}
            else{arr[i]->first = -1;}
        }
    }
 
    int count = 0;
    for(int i = 0; i<arr.size(); i++)
    {
        if(arr[i]->first == -1){continue;}
        else{count++;}
    }
    cout << count << '\n';
}
