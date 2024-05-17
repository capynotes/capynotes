import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)
    cursor = connection.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS diagram (
        id SERIAL PRIMARY KEY,
        note_id BIGINT NOT NULL,
        diagram_code TEXT NOT NULL,
        diagram_key TEXT)'''
    )

def get_transcript_from_database(note_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT transcription FROM transcript WHERE note_id = {note_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()

    return str(result[0])

def insert_diagrams_to_database(note_id, diagram_code):
    global connection

    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    insert_query = "INSERT INTO diagram (note_id, diagram_code) VALUES (%s, %s) RETURNING id;"

    try:
        values = (note_id, diagram_code)
        cursor.execute(insert_query, values)
        inserted_id = cursor.fetchone()[0]
        connection.commit()
        return inserted_id
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
        return None
    finally:
        cursor.close()

def insert_diagram_key_to_database(inserted_id, file_name):
    global connection

    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    update_query = "UPDATE diagram SET diagram_key = %s WHERE id = %s;"

    try:
        values = (file_name, inserted_id)
        cursor.execute(update_query, values)
        connection.commit()
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()

def delete_diagram_row(inserted_id):
    global connection

    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    delete_query = "DELETE FROM diagram WHERE id = %s;"

    try:
        value = inserted_id
        cursor.execute(delete_query, value)
        connection.commit()
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()