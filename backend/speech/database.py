import psycopg2
from db_config import DB_CONFIG

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)
    cursor = connection.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS transcript(
            id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
            note_id bigint NOT NULL,
            transcription character varying COLLATE pg_catalog."default" NOT NULL,
            CONSTRAINT transcript_pkey PRIMARY KEY (id)
        ) '''
    )
    connection.commit()
    cursor.execute('''CREATE TABLE IF NOT EXISTS timestamp(
            id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
            transcription_id bigint NOT NULL,
            start real NOT NULL,
            finish real NOT NULL,
            phrase character varying COLLATE pg_catalog."default" NOT NULL,
            CONSTRAINT timestamp_pkey PRIMARY KEY (id)
        )'''
    )
    connection.commit()
    cursor.close()

def get_note_from_database(note_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT * FROM note WHERE id = {note_id};"
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
    update_query = f"UPDATE note SET status = 'SUMMARIZING' WHERE note_id = {note_id};"
    cursor.execute(update_query)
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
    insert_query = f"INSERT INTO timestamp (transcription_id, start, finish, phrase) VALUES ({values_placeholder});"

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