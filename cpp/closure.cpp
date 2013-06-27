#include <iostream>
#include <functional>

using namespace std;

function<int(int)> closure(int x)
{
	int a = x;
	return [a] (int x) mutable -> int { return a+= x; };
}

auto power(long x) -> long
{
	return x * x;
}

int main()
{
	auto func = closure(3);
	cout << func(4) << endl;
	cout << func(5) << endl;
	cout << func(6) << endl;
	cout << power(99) << endl;
}
