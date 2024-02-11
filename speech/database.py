import psycopg2
from db_config import DB_CONFIG

conenction = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)

def get_note_from_database(note_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT * FROM Note WHERE id = {note_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()

    return result

def insert_transcription(note_id, transcription):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    cursor.execute("""
    INSERT INTO transcript (note_id, transcription)
    VALUES (%s, %s)
    RETURNING id;
""", (note_id, transcription))
    
    transcription_id = cursor.fetchone()[0]

    connection.commit()
    cursor.close()
    return transcription_id

def insert_timestamps(data_list):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    fields = data_list[0].keys()
    values_placeholder = ', '.join(['%s' for _ in fields])
    insert_query = f"INSERT INTO timestamp ({', '.join(fields)}) VALUES ({values_placeholder});"

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