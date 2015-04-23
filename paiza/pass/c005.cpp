#include <iostream>
#include <vector>

using namespace std;

bool check_ip(const string &ip);

int main(void)
{
    string str;
    getline(cin, str);

    for (int i = 0; i < stoi(str); ++i)
    {
        string ip;
        getline(cin, ip);
        cout << (check_ip(ip)?"True":"False") << endl;
    }

    return 0;
}

vector<string> split(const string &str, char s)
{
    size_t start = 0;
    vector<string> ret;
    for (size_t pos = str.find(s, start); pos != string::npos; pos = str.find(s, start))
    {
        ret.push_back(str.substr(start, pos - start));
        start += (pos - start + 1);
    }
    ret.push_back(str.substr(start));

    return ret;
}

bool check_ip(const string &ip)
{
    vector<string> nodes = split(ip, '.');
    if (nodes.size() != 4)
    {
        return false;
    }

    for (auto &node : nodes)
    {
        try
        {
            int value = stoi(node);
            if (!(0 <= value && value <= 255))
                return false;
        }
        catch (...)
        {
            return false;
        }

    }

    return true;
}
