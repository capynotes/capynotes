import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)

def get_transcript_from_database(transcript_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT * FROM transcript WHERE id = {transcript_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()

    return result

def insert_summary_to_database(summary_id ,summary, schema_data):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    insert_query = "INSERT INTO summary (summary_id, summary, schema_data) VALUES (%s, %s, %s);"
    values = (summary_id, summary, schema_data)

    try:
        cursor.execute(insert_query, values)
        connection.commit()
        print("Data inserted successfully!")
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()

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

# New function to insert keyword definitions
# data_list is a dictionary of keyword as key and definition as value
def insert_keyword_definitions(data_list):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    insert_query = "INSERT INTO keyword (keyword, definition) VALUES (%s, %s);"

    try:
        for keyword, definition in data_list.items():
            values = (keyword, definition)
            cursor.execute(insert_query, values)
        connection.commit()
        print("Data inserted successfully!")
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()