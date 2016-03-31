#include <cstdio>
#include <iostream>
#include <array>
#include <string>
#include <tuple>
#include <vector>

using result_type = std::array<unsigned long long, 27>;

template <char N, char M>
inline bool is_sth(char ch)
{
	return (N <= ch && ch <= M);
}

template <char N, char M>
std::tuple<std::string, std::string> read_sth(const std::string &data)
{
	int i = 0;
	for (; i < data.length(); ++i)
	{
		if (!is_sth<N, M>(data[i])) break;
	}

	return std::make_tuple(data.substr(0, i), data.substr(i));
}

void print_res(const result_type &res)
{
	for (int i = 0; i < res.max_size()-1; ++i)
	{
		printf("%c %llu\n", i+'a', res[i]);
	}
}

void dump_res(const std::vector<result_type> &ress)
{
	for (auto &it : ress)
	{
		print_res(it);
		std::cout << "---------------------\n";
	}
}

result_type multiple_result(const result_type &a, unsigned long long multiplier)
{
	result_type res;
	for (int i = 0; i < a.max_size(); ++i)
	{
		res[i] = a[i] * multiplier;
	}
	return res;
}

result_type plus_result(const result_type &a, const result_type &b)
{
	result_type res;
	for (int i = 0; i < a.max_size(); ++i)
	{
		res[i] = a[i] + b[i];
	}
	return res;
}

result_type to_result_type(const std::string &data)
{
	result_type res;
	res.fill(0);

	if (is_sth<'a', 'z'>(data[0]))
	{
		for (auto ch : data) res[ch-'a']++;
	}
	else if (is_sth<'0', '9'>(data[0]))
	{
		res[26] = stoull(data);
	}
	else if (is_sth<'(', '('>(data[0]))
	{
		res[26] = -1;
	}
	else if (is_sth<')', ')'>(data[0]))
	{
		res[26] = -2;
	}

	return res;
}

bool calculatable(const std::vector<result_type> &op_stack)
{
	if (op_stack.size() == 1) return false;
	auto s = op_stack.back();
	if (s[26] == -2)
	{
		return true;
	}
	else if (s[26] == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

void do_calculate(std::vector<result_type> &op_stack)
{
	result_type s1 = op_stack.back();
	op_stack.pop_back();

	if (s1[26] == 0)
	{
		result_type s2 = op_stack.back();
		op_stack.pop_back();

		if (s2[26] == 0)
		{
			auto s3 = plus_result(s1, s2);
			op_stack.push_back(s3);
		}
		else if (s2[26] != 0 && s2[26] != -1 && s2[26] != -2)
		{
			auto s3 = multiple_result(s1, s2[26]);
			op_stack.push_back(s3);
		}
		else if (s2[26] == -1)
		{
			auto s3 = plus_result(s1, s2);
			op_stack.push_back(s3);
		}
		else
		{
			op_stack.push_back(s1);
		}
	}
	else if (s1[26] == -2)
	{
		if (op_stack.size() > 1)
		{
			auto &s2 = op_stack.back();
			s2[26] = 0;
		}
	}
}

result_type calc_alphabets(const std::string &data)
{
	std::vector<result_type> op_stack;
	op_stack.push_back(to_result_type(""));

	auto l_data = data;
	while (!l_data.empty())
	{
		if (is_sth<'a', 'z'>(l_data[0]))
		{
			auto r = read_sth<'a', 'z'>(l_data);
			op_stack.push_back(to_result_type(std::get<0>(r)));
			l_data = std::get<1>(r);
		}
		else if (is_sth<'0', '9'>(l_data[0]))
		{
			auto r = read_sth<'0', '9'>(l_data);
			op_stack.push_back(to_result_type(std::get<0>(r)));
			l_data = std::get<1>(r);
			if (is_sth<'a', 'z'>(l_data[0]))
			{
				op_stack.push_back(to_result_type(l_data.substr(0, 1)));
				l_data = l_data.substr(1);
			}
		}
		else if (is_sth<'(', ')'>(l_data[0]))
		{
			op_stack.push_back(to_result_type(l_data.substr(0, 1)));
			l_data = l_data.substr(1);
		}

		while (calculatable(op_stack))
		{
			//dump_res(op_stack);
			do_calculate(op_stack);
		}
	}

	return op_stack[0];
}

/*
result_type calc_alphabets(const std::string &data)
{
	result_type res;
	res.fill(0);

	std::tuple<std::string, std::string> r;
	if (is_sth<'a', 'z'>(data[0]))
	{
		r = read_sth<'a', 'z'>(data);
		for (auto ch : std::get<0>(r)) res[ch-'a']++;
		auto l_data = std::get<1>(r);
		if (l_data.empty())
		{
			return res;
		}
		else
		{
			return plus_result(res, calc_alphabets(l_data));
		}
	}
	else if (is_sth<'0', '9'>(data[0]))
	{
		r = read_sth<'0', '9'>(data);
		auto times = stoull(std::get<0>(r));
		auto l_data = std::get<1>(r);
		if (is_sth<'a', 'z'>(l_data[0]))
		{
			res[l_data[0]-'a'] += times;

			l_data = l_data.substr(1);
			if (l_data.empty())
			{
				return res;
			}
			else
			{
				return plus_result(res, calc_alphabets(l_data));
			}
		}
		else
		{
			res = multiple_result(calc_alphabets(l_data), times);
			std::cout << l_data;
			return plus_result(res, calc_alphabets(l_data.substr(1)));
		}
	}
	else if (is_sth<'(', '('>(data[0]))
	{
		return calc_alphabets(data.substr(1));
	}
	else if (is_sth<')', ')'>(data[0]))
	{
		return res;
	}
}
*/

int main()
{
	std::string data;
	std::cin >> data;

	auto res = calc_alphabets(data);
	print_res(res);
}
