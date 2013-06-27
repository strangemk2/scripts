// 给定只包含括号字符'('和 ')''的字符串，请找出最长的有效括号内子括号的长度。 举几个例子如下： 例如对于"( ()"，最长的有效的括号中的子字符串是"()" ，有效双括号数1个，故它的长度为 2。  再比如对于字符串") () () )"，其中最长的有效的括号中的子字符串是"() ()"，有效双括号数2个，故它的长度为4。  再比如对于"( () () )"，它的长度为6。          换言之，便是有效双括号"()"数的两倍。 给定函数原型int longestValidParentheses(string s)，请完成此函数，实现上述功能。 

#include <iostream>
#include <string>
#include <stack>

using namespace std;

int longestValidParentheses(string s);

int main(int argc, char *argv[])
{
	string str(argv[1]);
	cout << longestValidParentheses(str) << endl;

	return 0;
}

int longestValidParentheses(string s)
{
	stack<char> parenthes_stack;
	for (size_t i = 0; i < s.length(); i++)
	{
		if (!parenthes_stack.empty() &&
				( parenthes_stack.top() == '(' && s[i] == ')') )
		{
			parenthes_stack.pop();
		}
		else
		{
			parenthes_stack.push(s[i]);
		}
	}
	return s.length() - parenthes_stack.size();
}
