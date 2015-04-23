#include <iostream>
#include <sstream>
#include <vector>

std::vector<std::string> split(const std::string &str, char split);

int main(void)
{
	std::string nm_line;
    getline(std::cin, nm_line);
	std::vector<std::string> nm = split(nm_line, ' ');

	int n = stoi(nm[0]);
	int m = stoi(nm[1]);

	std::vector<int> total_earnings;
	for (int i = 0; i < m; ++i)
	{
		std::string live_earning;
		getline(std::cin, live_earning);
		std::vector<std::string> live_earnings = split(live_earning, ' ');
		int sum = 0;
		for (int j = 0; j < n; ++j)
		{
			sum += stoi(live_earnings[j]);
		}
		total_earnings.push_back(sum);
	}

	int total_earning = 0;
	for (auto m : total_earnings)
	{
		if (m > 0)
		{
			total_earning += m;
		}
	}

	std::cout << ((total_earning>0)?total_earning:0) << std::endl;

    return 0;
}

std::vector<std::string> split(const std::string &str, char split)
{
	std::vector<std::string> ret;
	std::istringstream iss(str);
	std::string s;
    while (getline(iss, s, split))
	{
        ret.push_back(s);
    }

	return ret;
}
