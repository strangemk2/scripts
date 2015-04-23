#include <iostream>
#include <vector>

#include <cstdio>
#include <cmath>

using namespace std;

using darts_value = double;

vector<string> split(const string &str, char split);
darts_value to_radians(darts_value angle);

int main(void)
{
    string str;
    getline(cin, str);
	string arg;
	arg += str + " ";
    getline(cin, str);
	arg += str;

	auto args = split(arg, ' ');
	constexpr darts_value g = 9.8;

	darts_value o_y = stod(args[0]);
	darts_value s = stod(args[1]);
	darts_value theta = stod(args[2]);
	theta = to_radians(theta);
	darts_value x = stod(args[3]);
	darts_value y = stod(args[4]);
	darts_value a = stod(args[5]);

	darts_value real_y = o_y + (x * tan(theta)) - (g * x * x) / (2 * s * s * cos(theta) * cos(theta));

	darts_value upper = y + a / 2;
	darts_value bottom = y - a / 2;

	if (bottom <= real_y && real_y <= upper)
	{
		cout << "Hit " << round(abs(y - real_y) * 10) / 10.0 << endl;
	}
	else
	{
		cout << "Miss" << endl;
	}

    return 0;
}

darts_value to_radians(darts_value angle)
{
	constexpr darts_value PI = 3.1415926;
	return angle * PI / 180.0;
}

vector<string> split(const string &str, char split)
{
	size_t start = 0;
	size_t pos;
	vector<string> ret;
	for (pos = str.find(split, start); pos != string::npos; pos = str.find(split, start))
	{
		ret.push_back(str.substr(start, pos - start));
		start = pos + 1;
	}
	ret.push_back(str.substr(start));

	return ret;
}
