#include <iostream>
#include <vector>
using namespace std;


char arr[16][16];

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    
    int r = 0;

    while(r < 16){
        string buf;
        getline(cin, buf, '\n');
        if(cin.eof() == true) break;
        else{
            for(int i =0; i<buf.size(); i++){
                arr[r][i] = buf.at(i);
            }
            r++;
        }
    }

    for(int i = 0; i<16; i++){
        for(int j = 0; j<16; j++){
            
        }
    }
}