import psycopg2
from db_config import DB_CONFIG

def get_note_from_database(note_id):
    connection = psycopg2.connect(**DB_CONFIG)
    cursor = connection.cursor()

    query = f"SELECT * FROM Note WHERE id = {note_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()
    connection.close()

    return result