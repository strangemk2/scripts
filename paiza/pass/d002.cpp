#include <iostream>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split(const std::string &str, char split);

int main(void)
{
	std::string str;
    getline(std::cin, str);

	auto input_numbers = split(str, ' ');

	int a = stoi(input_numbers[0]);
	int b = stoi(input_numbers[1]);

	if (a < b)
	{
		std::cout << b << std::endl;
	}
	else if (a == b)
	{
		std::cout << "eq" << std::endl;
	}
	else
	{
		std::cout << a << std::endl;
	}


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
