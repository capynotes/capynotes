import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)

def get_trascription_from_database(transcription_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT * FROM transcript WHERE id = {transcription_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()
    return result

def insert_summary(note_id, summary):

    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    cursor.execute("""
    INSERT INTO summary (note_id, summary)
    VALUES (%s, %s)
    RETURNING id;
    """, (note_id, summary))
    
    summary_id = cursor.fetchone()[0]

    connection.commit()
    cursor.close()
    return summary_id