import os
import psycopg2

pg_user = os.environ.get('PG_USERNAME')
pg_password = os.environ.get('PG_PASSWORD')
pg_host = os.environ.get('PG_HOST')
pg_port = os.environ.get('PG_PORT')
pg_database = os.environ.get('PG_DATABASE')

# PostgreSQL initialization
def get_db_conn():
    conn = psycopg2.connect(
        host=pg_host,
        dbname=pg_database,
        user=pg_user,
        password=pg_password,
        port=pg_port
    )
    conn.commit
    return conn

def execute_query(conn=None, query=None, query_params=None):
    """
    Executes the query on the database using the provided query paramaters
    Args:
        db_connection: The database. Defaults to None.
        query: The query that will be executed on the database. Defaults to None.
        query_params: The parameters for the provided query. Defaults to None.
    Returns:
        cursor from executed query
    """
    if not conn:
        print("No connection to the database found! Have you called get_db_conn() first?")
        return None
    elif not query:
        print("Query is empty. Please enter a valid SQL query.")
        return None

    cur = conn.cursor()
    cur.execute(query, query_params)
    conn.commit()
    return cur