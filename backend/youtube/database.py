import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)


def update_s3_name(note_id, name):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()
    query = f"UPDATE note SET audio_name = '{name}' WHERE id = {note_id};"
    
    cursor.execute(query)
    connection.commit()
    cursor.close()
