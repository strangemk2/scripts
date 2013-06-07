#include<stdio.h>
#include<stdlib.h>
#include<string.h>


int StrToInt(const char* str)
{
	int ret = 0;

	int string_len = strlen(str);
	char *first_pass = (char *)malloc(string_len + 1);
	if (first_pass == 0)
	{
		return ret;
	}
	memset(first_pass, 0, string_len + 1);

	int i, j;
	for (i = 0; str[i] == ' '; i++) {};
	if (str[i] == '+' || str[i] == '-')
	{
		first_pass[j] = str[i];
		i++;
	}
	for (j = 0; i <= string_len; i++,j++)
	{
		if (str[i] == '+' || str[i] == '-')
		{
			break;
		}
		else if ('0' <= str[i] && str[i] <= '9')
		{
			first_pass[j] = str[i];
		}
		else
		{
			break;
		}
	}

	int sign = 1;
	for (i = strlen(first_pass) - 1, j = 1; i >= 0; i--, j *= 10)
	{
		if (first_pass[i] == '+')
		{
			sign = 1;
		}
		else if (first_pass[i] == '-')
		{
			sign = -1;
		}
		else
		{
			ret += (first_pass[i]-'0') * j;
		}
	}
	ret *= sign;

	return ret;
}

int main(int argc, char *argv[])
{   
	int i = StrToInt( argv[1] );
	printf("%d", i);
	return 0;
} 
