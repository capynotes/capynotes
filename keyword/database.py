import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)

def get_summary_from_database(summary_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT * FROM summary WHERE id = {summary_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()

    return result

def insert_keyword_definitions(data_list):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    fields = data_list[0].keys()
    values_placeholder = ', '.join(['%s' for _ in fields])
    insert_query = f"INSERT INTO keyword_definitions (note_id, keyword, definition) VALUES ({values_placeholder});"

    values_list = [tuple(row[field] for field in fields) for row in data_list]

    try:
        cursor.executemany(insert_query, values_list)
        connection.commit()
        print("Data inserted successfully!")
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()