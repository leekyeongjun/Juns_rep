#include <iostream>
#include <deque>

using namespace std;

class ballon
{
    public:
    int data;
    int index;
};

int main()
{
    deque<ballon> ballons;
    int command, num;
    ballon temp;

    cin >> command;
    for(int i = 0; i<command; i++)
    {
        cin >> num;
        ballon newballon;
        newballon.data = num;
        newballon.index = i+1;

        ballons.push_back(newballon);
    }

    int indexNum = 1;
    
    while(ballons.size() > 0)
    {

        if(indexNum >0){
            for(int j=1; j<indexNum; j++)
            {
                temp = ballons.front();
                ballons.push_back(temp);
                ballons.pop_front();
                // <-
            }
            indexNum = ballons.front().data;
            cout << ballons.front().index << "_";
            ballons.pop_front();
        }

        else{
            for(int k=1; k<(indexNum*-1); k++)
            {
                temp = ballons.back();
                ballons.push_front(temp);
                ballons.pop_back();
                // ->
                
            }
            indexNum = ballons.back().data;
            cout << ballons.back().index << "_";
            ballons.pop_back();
        }
        
    }
    cout << endl;
}