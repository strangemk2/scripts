#include <iostream>
#include <vector>
#include <list>
#include <string>

using namespace std;

template<typename T>
T get_erase(list<T> &l, size_t pos)
{
	auto it = l.begin();
	for (size_t i = 0; i < pos; ++i)
	{
		++it;
	}
	T ret = *it;
	l.erase(it);

	return ret;
}

void full_permutation(const list<char> &l, vector<string> &res, int limit)
{
	if (l.size() == 1)
	{
		res.push_back(string(1, l.front()));
		return;
	}
	for (size_t i = 0; i < l.size(); ++i)
	{
		list<char> t = l;
		char local_elem = get_erase(t, i);

		vector<string> v;
		if (limit > 0)
		{
			full_permutation(t, v, limit-1);
		}
		else
		{
			v.push_back("");
		}
		for (auto it : v)
		{
			res.push_back(local_elem + it);
		}
	}
}

int main()
{
	list<char> l = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'};
	vector<string> res;

	full_permutation(l, res, 2);

	for (auto it : res)
	{
		cout << it << endl;
	}

	return 0;
}
