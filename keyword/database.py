import psycopg2
from db_config import DB_CONFIG
from datetime import datetime

connection = None

def initialize_connection():
    global connection
    connection = psycopg2.connect(**DB_CONFIG)

def get_transcript_from_database(transcript_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT transcription FROM transcript WHERE id = {transcript_id};"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()

    return str(result[0])

def insert_summary_to_database(note_id ,summary):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    insert_query = "INSERT INTO summary (note_id, summary) VALUES (%s, %s);"
    values = (note_id, summary)

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

    return str(result[0])

# New function to insert keyword definitions
# data_list is a dictionary of keyword as key and definition as value
def insert_keyword_definitions(data_list, note_id, user_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    # Retrieve the note title
    note_title = get_note_title_from_database(note_id)
    flashcard_set_title = "Auto-generated flashcard set for " + note_title

    # Create auto-generated flashcard set for the note
    flashcard_set_id = create_flashcard_set(flashcard_set_title, note_id, user_id) 

 
    # Insert each keyword-definition pairs for the corresponding flashcard set

    insert_query = "INSERT INTO flashcard (front, back, set_id) VALUES (%s, %s, %s);"

    try:
        for front, back in data_list.items():
            values = (front, back, flashcard_set_id)
            cursor.execute(insert_query, values)

        connection.commit()
        print("Keyword definitions inserted successfully!")
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()

    
def create_flashcard_set(flashcard_set_title, note_id, user_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    #get the note creation time
    creation_time = datetime.now()

    # REMOVE ID PART
    insert_query = """
        INSERT INTO flashcard_set (creation_time, title, user_id, note_id) 
        VALUES ( %s, %s, %s, %s) 
        RETURNING id;
    """ 
    
    try:
        #REMOVE ID PART
        values = (creation_time, flashcard_set_title, user_id, note_id)
        cursor.execute(insert_query, values)
        connection.commit()

        # Retrieve the last inserted ID
        generated_id = cursor.fetchone()[0]
        
        return generated_id
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()


def get_note_title_from_database(note_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT title FROM note WHERE id = {note_id};"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()

    return str(result[0])


def get_user_id(note_id):
    global connection
    if connection is None:
        initialize_connection()
    cursor = connection.cursor()

    query = f"SELECT user_id FROM note WHERE id = {note_id};"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()

    return result[0]
