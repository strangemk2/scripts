#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <cstdio>
#include <functional>

class othello_stone
{
	public:
		enum stone_color
		{
			null,
			black,
			white,
		};

		othello_stone(stone_color color, int x, int y):
			_color(color),
			_x(x),
			_y(y)
		{}

		stone_color get_color() const
		{
			return _color;
		}

		int get_x() const
		{
			return _x;
		}

		int get_y() const
		{
			return _y;
		}

	private:
		stone_color _color;
		int _x;
		int _y;
};

class othello_board
{
	public:
		void init();
		void play(const othello_stone &stone);
		int count(othello_stone::stone_color color);

		void dump();

	private:
		std::vector<std::vector<othello_stone::stone_color>> _board;

		void _do_reverse(int x, int y, std::function<void (int &, int &)> direction_f);
};

void othello_board::init()
{
	for (int i = 0; i < 8; ++i)
	{
		_board.push_back(std::vector<othello_stone::stone_color>(8, othello_stone::null));
	}

	_board[3][3] = othello_stone::white;
	_board[4][4] = othello_stone::white;
	_board[4][3] = othello_stone::black;
	_board[3][4] = othello_stone::black;
}

void othello_board::play(const othello_stone &stone)
{
	_board[stone.get_x()][stone.get_y()] = stone.get_color();

	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {--x;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {--x; ++y;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {++y;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {++x; ++y;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {++x;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {++x; --y;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {--y;});
	_do_reverse(stone.get_x(), stone.get_y(), [] (int &x, int &y) {--x; --y;});
}

void othello_board::_do_reverse(int x, int y, std::function<void (int &, int &)> direction_f)
{
	int local_x = x;
	int local_y = y;

	othello_stone::stone_color local_color = _board[x][y];

	bool pair_found = false;
	while (true)
	{
		/*
		std::cout << local_x << "," << local_y << std::endl;
		*/
		direction_f(local_x, local_y);
		if (!(0 <= local_x && local_x <= 7 && 0 <= local_y && local_y <= 7))
		{
			break;
		}
		if (_board[local_x][local_y] == othello_stone::null)
		{
			break;
		}
		if (_board[local_x][local_y] == local_color)
		{
			pair_found = true;
			break;
		}
	}

	if (pair_found)
	{
		while (true)
		{
			direction_f(x, y);
			if (x == local_x && y == local_y)
			{
				break;
			}
			_board[x][y] = local_color;
		}
	}
}

int othello_board::count(othello_stone::stone_color color)
{
	int ret = 0;

	for (int x = 0; x < 8; ++x)
	{
		for (int y = 0; y < 8; ++y)
		{
			if (_board[x][y] == color)
			{
				++ret;
			}
		}
	}

	return ret;
}

void othello_board::dump()
{
	for (int x = 0; x < 8; ++x)
	{
		for (int y = 0; y < 8; ++y)
		{
			if (_board[x][y] == othello_stone::null)
			{
				std::cout << "N ";
			}
			else if (_board[x][y] == othello_stone::black)
			{
				std::cout << "B ";
			}
			else
			{
				std::cout << "W ";
			}
		}
		std::cout << std::endl;
	}
}

inline int to_local_coordinate(int n)
{
	return n - 1;
}

std::vector<std::string> split(const std::string &str, char split);

int main(void)
{
	std::string log_num_str;
    getline(std::cin, log_num_str);

	int log_num = stoi(log_num_str);

	othello_board game;
	game.init();

	for (int i = 0; i < log_num; ++i)
	{
		std::string log_str;
		getline(std::cin, log_str);
		std::vector<std::string> splited_log_str = split(log_str, ' ');

		game.play(othello_stone(
					splited_log_str[0].compare("B") == 0?othello_stone::black:othello_stone::white,
					to_local_coordinate(stoi(splited_log_str[1])),
					to_local_coordinate(stoi(splited_log_str[2]))));

		/*
		std::cout << "--------------------" << std::endl;
		game.dump();
		std::cout << "--------------------" << std::endl;
		*/
	}

	int black_stones = game.count(othello_stone::black);
	int white_stones = game.count(othello_stone::white);

	if (black_stones < white_stones)
	{
		printf("%02d-%02d The white won!\n", black_stones, white_stones);
	}
	else if (black_stones == white_stones)
	{
		printf("%02d-%02d Draw!\n", black_stones, white_stones);
	}
	else
	{
		printf("%02d-%02d The black won!\n", black_stones, white_stones);
	}

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
