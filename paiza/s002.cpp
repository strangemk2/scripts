#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <functional>
#include <array>
#include <set>
#include <limits>
#include <algorithm>

struct coordinator
{
	int x;
	int y;

	coordinator(int x_, int y_):
		x(x_), y(y_)
	{}

	bool operator== (const coordinator &c)
	{
		return (x == c.x && y == c.y);
	}
	bool operator!= (const coordinator &c)
	{
		return !operator==(c);
	}
};

class maze
{
	public:
		maze(int x, int y):
			size_x_(x),
			size_y_(y)
		{}

		void init();
		void dump();
		int walk(coordinator current, coordinator goal);

		int play();

	private:
		std::vector<std::vector<char>> data_;

		std::vector<coordinator> path;
		std::set<std::string> all_node;

		int size_x_ = 0;
		int size_y_ = 0;

		coordinator find_point_(char destination);
		coordinator find_start_()
		{
			return find_point_('s');
		}
		coordinator find_goal_()
		{
			return find_point_('g');
		}

		unsigned long calc_distance_(coordinator a, coordinator b);
		std::vector<int> find_minimum_(const std::array<unsigned long, 4> &a);
		std::vector<coordinator> direction_to_route_(const std::vector<int> &v, coordinator current);
		std::array<unsigned long, 4> make_distance_(coordinator start, coordinator goal);
		std::string make_key_(coordinator c);
};

static std::array<std::function<void (coordinator &)>, 4> move_func = {{
		[] (coordinator &c) {c.x--;},
		[] (coordinator &c) {c.x++;},
		[] (coordinator &c) {c.y--;},
		[] (coordinator &c) {c.y++;},
}};

void maze::init()
{
	for (int i = 0; i < size_x_; ++i)
	{
		std::vector<char> v;
		for (int j = 0; j < size_y_; ++j)
		{
			char c;
			std::cin >> c;
			v.push_back(c);
		}
		data_.push_back(v);
	}
}

void maze::dump()
{
	std::cout << size_x_ << ", " << size_y_ << std::endl;
	std::cout << "--------------------" << std::endl;
	for (int x = 0; x < size_x_; ++x)
	{
		for (int y = 0; y < size_y_; ++y)
		{
			std::cout << data_[x][y] << ' ';
		}
		std::cout << std::endl;
	}
	std::cout << "--------------------" << std::endl;
}

coordinator maze::find_point_(char destination)
{
	for (int i = 0; i < size_x_; ++i)
	{
		for (int j = 0; j < size_y_; ++j)
		{
			if (data_[i][j] == destination)
			{
				return coordinator(i, j);
			}
		}
	}
	return coordinator(0, 0);
}

unsigned long maze::calc_distance_(coordinator a, coordinator b)
{
	int x = a.x - b.x;
	int y = a.y - b.y;

	return x * x + y * y;
}

std::array<unsigned long, 4> maze::make_distance_(coordinator start, coordinator goal)
{
	std::array<unsigned long, 4> a;

	for (int i = 0; i < 4; ++i)
	{
		coordinator current = start;
		move_func[i](current);

		if (current.x < 0 || current.x == size_x_ ||
				current.y < 0 || current.y == size_y_ ||
				data_[current.x][current.y] == '1')
		{
			a[i] = std::numeric_limits<unsigned long>::max();
		}
		else
		{
			a[i] = calc_distance_(current, goal);
		}
	}

	return a;
}

std::vector<int> maze::find_minimum_(const std::array<unsigned long, 4> &a)
{
	std::vector<int> v = {0, 1, 2, 3};
	sort(v.begin(), v.end(), [&a] (int i, int j) -> bool {return a[i] < a[j];});

	v.erase(std::remove_if(v.begin(),v.end(),
				[&a] (int i) -> bool {return a[i] == std::numeric_limits<unsigned long>::max();}),
			v.end()
		   );

	return v;
}

std::string maze::make_key_(coordinator c)
{
	std::ostringstream oss;
	oss << c.x << "," << c.y;
	return oss.str();
}

int maze::play()
{
	coordinator start = find_start_();
	coordinator goal = find_goal_();

	for (int i = 0; i < size_x_; ++i)
	{
		for (int j = 0; j < size_y_; ++j)
		{
			if (data_[i][j] != '1')
			{
				all_node.insert(make_key_(coordinator(i, j)));
			}
		}
	}

	return walk(start, goal);
}

std::vector<coordinator> maze::direction_to_route_(const std::vector<int> &v, coordinator current)
{
	std::vector<coordinator> r;
	for (auto i : v)
	{
		coordinator c = current;
		move_func[i](c);
		r.push_back(c);
	}

	return r;
}

int maze::walk(coordinator start, coordinator goal)
{
	coordinator current = start;

	while (current != goal)
	{
		std::cout << current.x << ", " << current.y << std::endl;
		if (all_node.empty())
		{
			return -1;
		}

		all_node.erase(make_key_(current));
		if (path.size() == 0 || path.back() != current) path.push_back(current);

		auto next_node = [this] (coordinator &current, coordinator goal) -> bool
		{
			auto routes = direction_to_route_(find_minimum_(make_distance_(current, goal)), current);
			for (auto r : routes)
			{
				if (all_node.count(make_key_(r)) != 0)
				{
					current = r;
					return true;
				}
			}
			return false;
		};

		if (!next_node(current, goal))
		{
			path.pop_back();
			if (path.size() == 0)
			{
				return -1;
			}
			else
			{
				current = path.back();
			}
		}
	}

	return path.size();

	/*
	coordinator current = start;
	std::cout << current.x << ", " << current.y << std::endl;

	if (all_node.empty())
	{
		return -1;
	}
	if (current == goal)
	{
		return path.size();
	}

	all_node.erase(make_key_(current));
	path.push_back(current);

	auto routes = direction_to_route_(find_minimum_(make_distance_(current, goal)), current);

	for (auto r : routes)
	{
		if (all_node.count(make_key_(r)) != 0)
		{
			int ret = walk(r, goal);
			if (ret == -1)
			{
				continue;
			}
			else
			{
				return ret;
			}
		}
	}
	path.pop_back();
	return -1;
	*/
}

int main(void)
{
	std::string maze_size_str;
	std::cin >> maze_size_str;
	int board_y = stoi(maze_size_str);
	std::cin >> maze_size_str;
	int board_x = stoi(maze_size_str);

	maze m(board_x, board_y);
	m.init();
	m.dump();

	int ret = m.play();
	if (ret < 0)
	{
		std::cout << "Fail" << std::endl;
	}
	else
	{
		std::cout << ret << std::endl;
	}

	return 0;
}
