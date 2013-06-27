#include <iostream>
#include <vector>

#include <math.h>
#include <stdlib.h>

using namespace std;

int isPrime(int x);

int main(int argc, char *argv[])
{
	if (argc != 2) return 1;
	int max = atoi(argv[1]);

	for (int i = 2; i <= max; i++)
	{
		if (isPrime(i))
		{
			cout << i << endl;
		}
	}
	isPrime(12);
	return 0;
}

int isPrime(int x)
{
	static vector<int> prime_cache;

	return isPrime(x, &prime_cache);
}

int isPrime(int x, vector<int> *p_prime_cache)
{
	int end = int(sqrt(x));
	vector<int>::const_iterator it = p_prime_cache->begin();
	for (;it != p_prime_cache->end(); it++)
	{
		if (*it > end) break;

		if ((x % *it) == 0)
		{
			return 0;
		}
	}

	p_prime_cache->push_back(x);
	return x;
}
