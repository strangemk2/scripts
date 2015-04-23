#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <array>
#include <functional>

std::vector<std::string> split(const std::string &str, char split);

class dice
{
	public:
		void up();
		void down();
		void left();
		void right();

		int top();

	private:
		std::array<int, 6> flat_dice = {{1, 2, 3, 4, 5, 6}};

		void rotate_(const std::array<int, 4> &order);
};

class maze
{
	public:
		maze(int x, int y, const std::vector<std::string> &data);

		void dump();
		bool play(dice d, int x, int y, int cost);

	private:
		std::vector<std::vector<int>> _board;
		std::vector<std::vector<int>> _cell_cost;

		int _calc_cost(int a, int b);

		inline bool _is_finish(int x, int y);

		//bool _move(dice d, int x, int y, int cost, std::function<bool (dice &, int &, int &)> direction_f);
		bool _move_right(dice d, int x, int y, int cost);
		bool _move_down(dice d, int x, int y, int cost);
		bool _move_left(dice d, int x, int y, int cost);
		bool _move_up(dice d, int x, int y, int cost);

		int _board_size_x = 0;
		int _board_size_y = 0;

		/*
		int _dice_x = 0;
		int _dice_y = 0;
		*/
};

int dice::top()
{
	return flat_dice[0];
}

void dice::rotate_(const std::array<int, 4> &order)
{
	int tmp = flat_dice[order[3] - 1];
	flat_dice[order[3] - 1] = flat_dice[order[2] - 1];
	flat_dice[order[2] - 1] = flat_dice[order[1] - 1];
	flat_dice[order[1] - 1] = flat_dice[order[0] - 1];
	flat_dice[order[0] - 1] = tmp;
}

void dice::up()
{
	// 1265
	rotate_({{1, 2, 6, 5}});
}

void dice::down()
{
	// 1562
	rotate_({{1, 5, 6, 2}});
}

void dice::left()
{
	// 1463
	rotate_({{1, 4, 6, 3}});
}

void dice::right()
{
	// 1364
	rotate_({{1, 3, 6, 4}});
}

maze::maze(int x, int y, const std::vector<std::string> &data):
	_board_size_x(x),
	_board_size_y(y)
{
	for (auto &s : data)
	{
		_board.push_back(std::vector<int>(s.begin(), s.end()));
	}

	for (int i = 0; i < x; ++i)
	{
		std::vector<int> t;
		for (int j = 0; j < y; ++j)
		{
			t.push_back(10000);
		}
		_cell_cost.push_back(t);
	}
}

/*
void maze::dump()
{
	std::cout << _board_size_x << ", " << _board_size_y << std::endl;
	std::cout << "--------------------" << std::endl;
	for (int x = 0; x < _board_size_x; ++x)
	{
		for (int y = 0; y < _board_size_y; ++y)
		{
			std::cout << _board[x][y];
		}
		std::cout << std::endl;
	}
	std::cout << "--------------------" << std::endl;
}
*/

bool maze::_is_finish(int x, int y)
{
	return (x == _board_size_x-1 && y == _board_size_y-1);
}

bool maze::play(dice d, int x, int y, int cost)
{
	return _move_right(d, x, y, cost) ||
		_move_down(d, x, y, cost);
}

bool maze::_move_right(dice d, int x, int y, int cost)
{
	++y;
	if (y == _board_size_y)
	{
		return false;
	}
	d.right();
	//std::cout << x << y << std::endl;

	int c = _calc_cost(d.top(), _board[x][y]);
	//std::cout << c << "," << cost << std::endl;
	if (c <= _cell_cost[x][y])
	{
		_cell_cost[x][y] = c;
	}
	else
	{
		return false;
	}
	if (c > cost)
	{
		return false;
	}

	if (_is_finish(x, y)) return true;

	return _move_right(d, x, y, cost - c) ||
		_move_down(d, x, y, cost - c) ||
		_move_up(d, x, y, cost - c);
}

bool maze::_move_down(dice d, int x, int y, int cost)
{
	++x;
	if (x == _board_size_x)
	{
		return false;
	}
	d.down();
	//std::cout << x << y << std::endl;

	int c = _calc_cost(d.top(), _board[x][y]);
	//std::cout << c << "," << cost << std::endl;
	if (c <= _cell_cost[x][y])
	{
		_cell_cost[x][y] = c;
	}
	else
	{
		return false;
	}
	if (c > cost)
	{
		return false;
	}

	if (_is_finish(x, y)) return true;

	return _move_right(d, x, y, cost - c) ||
		_move_down(d, x, y, cost - c) ||
		_move_left(d, x, y, cost - c);
}

bool maze::_move_left(dice d, int x, int y, int cost)
{
	--y;
	if (y < 0)
	{
		return false;
	}
	d.left();
	//std::cout << x << y << std::endl;

	int c = _calc_cost(d.top(), _board[x][y]);
	//std::cout << c << "," << cost << std::endl;
	if (c <= _cell_cost[x][y])
	{
		_cell_cost[x][y] = c;
	}
	else
	{
		return false;
	}
	if (c > cost)
	{
		return false;
	}

	if (_is_finish(x, y)) return true;

	return _move_left(d, x, y, cost - c) ||
		_move_down(d, x, y, cost - c) ||
		_move_up(d, x, y, cost - c);
}

bool maze::_move_up(dice d, int x, int y, int cost)
{
	--x;
	if (x < 0)
	{
		return false;
	}
	d.up();
	//std::cout << x << y << std::endl;

	int c = _calc_cost(d.top(), _board[x][y]);
	//std::cout << c << "," << cost << std::endl;
	if (c <= _cell_cost[x][y])
	{
		_cell_cost[x][y] = c;
	}
	else
	{
		return false;
	}
	if (c > cost)
	{
		return false;
	}

	if (_is_finish(x, y)) return true;

	return _move_right(d, x, y, cost - c) ||
		_move_left(d, x, y, cost - c) ||
		_move_up(d, x, y, cost - c);
}

int maze::_calc_cost(int a, int b)
{
	return ((a-b)<0)?(b-a):(a-b);
}

int main(void)
{
	std::string board_size_str;
	getline(std::cin, board_size_str);
	auto board_size_vec = split(board_size_str, ' ');

	int board_x = stoi(board_size_vec[0]);
	int board_y = stoi(board_size_vec[1]);

	std::vector<std::string> board_data;
	for (int i = 0; i < board_x; ++i)
	{
		std::string board_line;
		getline(std::cin, board_line);
		for (auto &c : board_line)
		{
			c -= '0';
		}

		board_data.push_back(board_line);
	}

	maze m(board_x, board_y, board_data);
	//m.dump();

	dice d;
	int cost = 0;
	while (!m.play(d, 0, 0, cost) && cost < 10000)
	{
		++cost;
		//std::cout << "next cost: " << cost << std::endl;
	}

	std::cout << cost << std::endl;

	return 0;
}

std::vector<std::string> split(const std::string &str, char split)
{
	std::vector<std::string> ret;
	std::istringstream iss(str);
	std::string s;
    while (getline(iss, s, split))
	{
        ret.push_back(s);
    }

	return ret;
}
