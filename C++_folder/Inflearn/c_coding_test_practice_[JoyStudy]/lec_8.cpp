#include <algorithm>

int main()
{

	int dp[19] = {0, -1, -1, 1, -1, 1};

	for(int i = 6; i<19; i++){
		if(dp[i-3] == -1 && dp[i-5]== -1){
			dp[i] = -1;
		}
		else if(dp[i-3]== -1 || dp[i-5]== -1){
			dp[i] = max(dp[i-3]+1, dp[i-5]+1);
		}
		else
			dp[i] = min(dp[i-3]+1, dp[i-5]+1);
	}
}
