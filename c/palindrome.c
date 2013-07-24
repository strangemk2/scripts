// 回文字符串是指从左到右和从右到左相同的字符串，现给定一个仅由小写字母组成的字符串，你可以把它的字母重新排列，以形成不同的回文字符串。 输入：非空仅由小写字母组成的字符串，长度不超过100； 输出：能组成的所有回文串的个数（因为结果可能非常大，输出对1000000007取余数的结果）。 例如：输入"aabb" 输出为2（因为“aabb”对应的所有回文字符串有2个：abba和baab）

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define DEFAULT_REMAINDER 1000000007

int remainder_mutiple_divide(int *multiplier, int *divider, int remainder)
{
	int ret = 1;

	int *current_divider = divider;
	for (int *current_multiplier = multiplier; *current_multiplier != 0; current_multiplier++)
	{
		ret *= *current_multiplier;
		while (*current_divider && ret % *current_divider == 0)
		{
			ret /= *current_divider;
			current_divider++;
		}
		if (ret > remainder)
		{
			ret %= remainder;
		}
	}
	return ret;
}

int *push_fraction_queue(int *queue, int fractor)
{
	int *current_queue = queue;
	for (int i = fractor; i >= 1; i--)
	{
		*current_queue = i;
		current_queue++;
	}
	return current_queue;
}

int palindrome(const char *s)
{
	int char_mount['z'+1];
	memset(char_mount, 0, ('z'+1)*sizeof(int));
	for (int i = 0; i < strlen(s); i++)
	{
		char_mount[(int)s[i]]++;
	}

	int single_flag = 0;
	int fraction = 0;
	int multiplier[100+1];
	memset(multiplier, 0, (100+1)*sizeof(int));
	int divider[100+1];
	memset(divider, 0, (100+1)*sizeof(int));
	int *current_divider = divider;
	for (int i = 'a'; i <= 'z'; i++)
	{
		if (char_mount[i] % 2 == 1)
		{
			if (single_flag == 1)
			{
				return 0;
			}
			else
			{
				single_flag = 1;
			}
		}
		int mount = char_mount[i] / 2;
		current_divider = push_fraction_queue(current_divider, mount);
		fraction += mount;
	}
	push_fraction_queue(multiplier, fraction);
	return remainder_mutiple_divide(multiplier, divider, DEFAULT_REMAINDER);
}

int main(int argc, char *argv[])
{
	printf("%d\n", palindrome(argv[1]));

	return 0;
}
