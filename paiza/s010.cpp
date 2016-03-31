#include <iostream>
#include <vector>
#include <array>

using namespace std;

bool is_opporsite(char a, char b)
{
	return ((a == 'T' && b == 'B') ||
			(a == 'B' && b == 'T') ||
			(a == 'U' && b == 'D') ||
			(a == 'D' && b == 'U') ||
			(a == 'L' && b == 'R') ||
			(a == 'R' && b == 'L'));
}

int main()
{
	int t, b, u, d, l, r;
	cin >> t;
	cin >> b;
	cin >> u;
	cin >> d;
	cin >> l;
	cin >> r;

	int n;
	cin >> n;

	array<char, 7> dice;
	dice[t] = 'T';
	dice[b] = 'B';
	dice[u] = 'U';
	dice[d] = 'D';
	dice[l] = 'L';
	dice[r] = 'R';

	vector<int> board;
	for (int i = 0; i < n; ++i)
	{
		int t;
		cin >> t;
		board.push_back(t);
	}

	/*
	cout << t << b << u << d << l << r << endl;;
	cout << n << endl;
	for (auto s : board)
	{
		cout << s << ",";
	}
	cout << endl;
	*/

	if (n == 1)
	{
		cout << 0 << endl;
		return 0;
	}

	int start = board[0];
	int result = 0;
	for (int i = 1; i < n; ++i)
	{
		//cout << dice[start] << "," << dice[board[i]] << endl;
		if (is_opporsite(dice[start], dice[board[i]]))
		{
			result += 2;
		}
		else if (start != board[i])
		{
			result++;
		}
		start = board[i];
	}
	cout << result << endl;

	return 0;
}
