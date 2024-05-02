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
        diagram_code TEXT NOT NULL)'''
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

def insert_diagrams_to_database(note_id, diagram_codes):
    global connection

    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    insert_query = "INSERT INTO diagram (note_id, diagram_code) VALUES (%s, %s);"

    try:
        for diagram in diagram_codes:
            values = (note_id, diagram)
            cursor.execute(insert_query, values)
        connection.commit()
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()