// clang mysql_update.c -o mysql_update -Wall -lmysqlclient
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <mysql/mysql.h>

#define MAX_BUF 4096

typedef FILE LOG;

static const int HOSTFILE_INDEX = 1;
static const int SQLFILE_INDEX = 2;
static const int COMMIT_PER_EXECUTION_INDEX = 3;

static const char LOG_DIRECTORY[] = "/opt/atadm/tools/modify_tools/log";
//static const char LOG_DIRECTORY[] = ".";
static const char MYSQL_USER[] = "next_user";
static const char MYSQL_PASSWORD[] = "next_passwd";
static const char MYSQL_DB[] = "USER_INFO_DB";

static int g_commit_per_execution = 1000;

// --------------------
// list stuff
// --------------------
typedef struct _simple_list_node
{
	void *data;
	struct _simple_list_node *next;
} simple_list_node;

typedef struct _simple_list
{
	int size;
	simple_list_node *root;
	simple_list_node *last;
} simple_list;

simple_list *simple_list_new()
{
	simple_list *list = (simple_list *)malloc(sizeof(simple_list));
	if (list != NULL)
	{
		list->size = 0;
		list->root = NULL;
		list->last = NULL;
	}
	return list;
}

int simple_list_push(simple_list *list, void *data)
{
	simple_list_node *node = (simple_list_node *)malloc(sizeof(simple_list_node));
	if (node == NULL)
	{
		return 1;
	}
	node->data = data;
	node->next = NULL;

	if (list->size == 0)
	{
		list->root = node;
		list->last = node;
	}
	else
	{
		list->last->next = node;
		list->last = list->last->next;
	}

	return ++(list->size);
}

int simple_list_push_string(simple_list *list, const char *string)
{
	char *p = malloc(strlen(string) + 1);
	strcpy(p, string);
	return simple_list_push(list, p);
}

typedef void (* deleter_f)(void *data);
void simple_list_delete(simple_list *list, deleter_f deleter)
{
	if (list == NULL)
	{
		return;
	}

	simple_list_node *p = list->root;
	while (p != NULL)
	{
		simple_list_node *t = p->next;
		if (deleter == NULL)
		{
			free(p->data);
		}
		else
		{
			deleter(p->data);
		}
		free(p);
		p = t;
	}
	free(list);
}

void simple_list_delete_string(simple_list *list)
{
	simple_list_delete(list, NULL);
}

typedef int (* list_process_f)(const simple_list_node *node, void *data);
const simple_list_node *do_list_impl(const simple_list_node *start, const simple_list_node *end, list_process_f f, void *data)
{
	int ret;
	for (const simple_list_node *node = start; node != end; node = node->next)
	{
		ret = f(node, data);
		if (ret != 0)
		{
			return node;
		}
	}
	return NULL;
}

const simple_list_node *do_list(const simple_list *list, list_process_f f, void *data)
{
	return do_list_impl(list->root, NULL, f, data);
}

// [)
const simple_list_node *do_list_until(const simple_list *list, list_process_f f, const simple_list_node *node, void *data)
{
	return do_list_impl(list->root, node, f, data);
}

// [)
const simple_list_node *do_list_from(const simple_list *list, list_process_f f, const simple_list_node *node, void *data)
{
	return do_list_impl(node, NULL, f, data);
}

// for simple list debug
int list_print(const simple_list_node *node, void *data)
{
	char *string = (char *)node->data;
	if (string[0] == '1')
	{
		return 1;
	}
	else
	{
		printf("%s\n", (char *)node->data);
		return 0;
	}
}
int list_print2(const simple_list_node *node, void *data)
{
	printf("%s\n", (char *)node->data);
	return 0;
}

void dump_list(const simple_list *list)
{
	do_list(list, list_print2, NULL);
}


// --------------------
// misc stuff
// --------------------
void usage()
{
	printf("Usage : mysql_update <DIR_SERVER_HOSTLIST_PATH> <SQL_FILE_PATH> [COMMIT_PER_EXECUTION]\n");
}

const char *get_current_datetime(char *format)
{
	static char static_datatime[MAX_BUF];

	time_t rawtime;
	struct tm *timeinfo;

	time(&rawtime);
	timeinfo = localtime(&rawtime);
	strftime(static_datatime, MAX_BUF, format, timeinfo);

	return static_datatime;
}

char *str_chop(char *string)
{
	string[strlen(string)-1] = 0;
	return string;
}

// --------------------
// log stuff
// --------------------
LOG *glog = NULL;

const char *get_log_filename()
{
	static char static_log_filename[MAX_BUF];
	strcpy(static_log_filename, LOG_DIRECTORY);
	strcat(static_log_filename, get_current_datetime("/mysql_update_%Y%m%d.log"));

	return static_log_filename;
}

LOG *open_log(const char *filename)
{
	glog = fopen(filename, "a");
	return glog;
}

void close_log()
{
	fclose(glog);
	glog = NULL;
}

const char *get_log_by_id(int id)
{
	static const int MAX_LOG_ID = 9;
	static const char *LOG_ARRAY[] = {
  /*0*/ "E No such log.",
  /*1*/ "I Process started.",
  /*2*/ "I DB update succeeded. Server=%s, SQL file=%s.",
  /*3*/ "I Process stopped.",
  /*4*/ "E File does not exist. File=%s.",
  /*5*/ "E File could not be read. File=%s.",
  /*6*/ "E MySQL connect failed. Server=%s.",
  /*7*/ "E MySQL query failed. Query=%s.",
  /*8*/ "E Process terminated.",
  /*9*/ "E Number of arguments is non two."
	};
	return LOG_ARRAY[id>MAX_LOG_ID?0:id];
}

int write_log(int log_id, ...)
{
	char buf[MAX_BUF];
	va_list args;
	va_start(args, log_id);
	strcpy(buf, get_current_datetime("%Y/%m/%d %H:%M:%S "));
	vsprintf(buf+strlen(buf), get_log_by_id(log_id), args);
	fputs(buf, glog);
	fputs("\n", glog);
	va_end(args);

	return 0;
}

// --------------------
// business stuff
// --------------------
simple_list *read_file_to_list(const char *filename)
{
	char line_buf[MAX_BUF];

	FILE *fp = fopen(filename, "r");
	if (fp == NULL)
	{
		return NULL;
	}

	simple_list *list = simple_list_new();
	while (fgets(line_buf, MAX_BUF, fp))
	{
		simple_list_push_string(list, str_chop(line_buf));
	}

	fclose(fp);
	return list;
}

// --------------------
// sql connection
// --------------------
typedef struct _sql_connections
{
	simple_list *connection_list;
	const simple_list_node *working_node;
} sql_connections;

typedef struct _single_mysql_execution_data
{
	MYSQL *con;
	int counter;
} single_mysql_execution_data;

// helper
int make_mysql_connection(const simple_list_node *node, void *data)
{
	sql_connections *connections = (sql_connections *)data;
	const char *mysql_server = (const char *)node->data;
	MYSQL *con = mysql_init(NULL);
	if (con == NULL)
	{
		write_log(6, mysql_server);
		return 1;
	}
	if (mysql_real_connect(con, mysql_server, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, MYSQL_PORT, NULL, 0) == NULL)
	{
		write_log(6, mysql_server);
		mysql_close(con);
		return 2;
	}
	if (mysql_autocommit(con, 0) != 0)
	{
		write_log(6, mysql_server);
		mysql_close(con);
		return 3;
	}

	simple_list_push(connections->connection_list, con);
	return 0;
}

int do_single_mysql_execution(const simple_list_node *node, void *data)
{
	const char *sql = (const char *)node->data;
	single_mysql_execution_data *execution_data = (single_mysql_execution_data *)data;
	MYSQL *con = execution_data->con;

	if (mysql_query(con, sql) != 0)
	{
		write_log(7, sql);
		return 1;
	}
	// commit after specific execution cycles.
	if (++execution_data->counter == g_commit_per_execution)
	{
		if (mysql_commit(con) != 0)
		{
			write_log(7, "commit;");
			return 1;
		}
		execution_data->counter = 0;
	}
	return 0;
}

int do_mysql_execution(const simple_list_node *node, void *data)
{
	MYSQL *con = (MYSQL *)node->data;
	simple_list *sql_list = (simple_list *)data;

	single_mysql_execution_data execution_data = {con, 0};
	if (do_list(sql_list, do_single_mysql_execution, &execution_data) != NULL)
	{
		return 1;
	}
	return 0;
}

int do_mysql_rollback(const simple_list_node *node, void *data)
{
	MYSQL *con = (MYSQL *)node->data;
	if (mysql_rollback(con) != 0)
	{
		write_log(7, "rollback;");
		return 1;
	}
	return 0;
}

int do_mysql_commit(const simple_list_node *node, void *data)
{
	MYSQL *con = (MYSQL *)node->data;
	if (mysql_commit(con) != 0)
	{
		write_log(7, "commit;");
		return 1;
	}
	write_log(2, con->host, (char *)data);
	return 0;
}

int do_mysql_close(const simple_list_node *node, void *data)
{
	MYSQL *con = (MYSQL *)node->data;
	mysql_close(con);
	return 0;
}

void mysql_deleter(void *data)
{
	// do nothing
}

// connections
void sql_connections_delete(sql_connections *connections);

sql_connections *sql_connections_new(simple_list *host_list)
{
	sql_connections *connections = (sql_connections *)malloc(sizeof(sql_connections));
	connections->working_node = NULL;
	connections->connection_list = simple_list_new();
	if (do_list(host_list, make_mysql_connection, connections) != NULL)
	{
		sql_connections_delete(connections);
		return NULL;
	}
	else
	{
		return connections;
	}
}

int sql_connections_execute(sql_connections *connections, simple_list *sql_list)
{
	connections->working_node = do_list(connections->connection_list, do_mysql_execution, sql_list);
	if (connections->working_node != NULL)
	{
		return 1;
	}
	return 0;
}

int sql_connections_execute_rollback(sql_connections *connections)
{
	if (do_list_until(connections->connection_list, do_mysql_rollback, connections->working_node, NULL) != NULL)
	{
		return 1;
	}
	return 0;
}

int sql_connections_commit_rollback(sql_connections *connections)
{
	if (do_list_from(connections->connection_list, do_mysql_rollback, connections->working_node->next, NULL) != NULL)
	{
		return 1;
	}
	return 0;
}

int sql_connections_commit(sql_connections *connections, char *sql_file)
{
	connections->working_node = do_list(connections->connection_list, do_mysql_commit, sql_file);
	if (connections->working_node != NULL)
	{
		return 1;
	}
	return 0;
}

void sql_connections_delete(sql_connections *connections)
{
	if (connections == NULL)
		return;

	do_list(connections->connection_list, do_mysql_close, NULL);
	simple_list_delete(connections->connection_list, mysql_deleter);
	free(connections);
}

// --------------------
// main
// --------------------
int main(int argc, char *argv[])
{
	int ret = 0;
	if (!open_log(get_log_filename()))
	{
		perror("Open log error");
		return 1;
	}

	write_log(1);

	if (argc != 3 && argc != 4)
	{
		usage();
		write_log(9);
		ret = 1;
		goto ARG_ERROR;
	}

	simple_list *host_list = read_file_to_list(argv[HOSTFILE_INDEX]);
	if (host_list == NULL)
	{
		if (errno == ENOENT)
			write_log(4, argv[HOSTFILE_INDEX]);
		else
			write_log(5, argv[HOSTFILE_INDEX]);
		ret = 2;
		goto OPEN_HOST_ERROR;
	}

	simple_list *sql_list = read_file_to_list(argv[SQLFILE_INDEX]);
	if (sql_list == NULL)
	{
		if (errno == ENOENT)
			write_log(4, argv[SQLFILE_INDEX]);
		else
			write_log(5, argv[SQLFILE_INDEX]);
		ret = 3;
		goto OPEN_SQL_ERROR;
	}

	if (argc == 4)
	{
		g_commit_per_execution = atoi(argv[COMMIT_PER_EXECUTION_INDEX]);
	}

	sql_connections *connections = sql_connections_new(host_list);
	if (connections)
	{
		do
		{
			if (sql_connections_execute(connections, sql_list) != 0)
			{
				sql_connections_execute_rollback(connections);
				ret = 5;
				break;
			}
			if (sql_connections_commit(connections, argv[2]) != 0)
			{
				sql_connections_commit_rollback(connections);
				ret = 6;
				break;
			}
		} while(0);
		sql_connections_delete(connections);
	}
	else
	{
		ret = 4;
	}

OPEN_SQL_ERROR:
	simple_list_delete_string(sql_list);
OPEN_HOST_ERROR:
	simple_list_delete_string(host_list);
ARG_ERROR:
	if (ret == 0)
		write_log(3);
	else
		write_log(8);
	close_log();
	return ret;
}
