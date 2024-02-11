#!/usr/bin/env python
import os
import sys
import pika
from database import get_note_from_database, insert_transcription, insert_timestamps
from transcribe import whisper_transcribe_audio

def callback(ch, method, properties, body):
    note_id = int(body.decode())
    note_data = get_note_from_database(note_id)
    audio_file_name = note_data[3]
    result = whisper_transcribe_audio(audio_file_name)
    transcription = result["text"]
    segments = result["segments"]

    print(f" [x] Received Note ID: {note_id}, Data: {note_data}, Audio name: {audio_file_name}")
    print(transcription)

    transcription_id_value = insert_transcription(note_id, transcription)

    transformed_list = [{'transcription_id': transcription_id_value,
                    'start': item['start'],
                    'end': item['end'],
                    'phrase': item['text']}
                    for item in segments]
    insert_timestamps(transformed_list)

def main():
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(host="localhost"),
    )
    channel = connection.channel()

    channel.queue_declare(queue="transcription_queue")

    channel.basic_consume(
        queue="transcription_queue",
        on_message_callback=callback,
        auto_ack=True,
    )

    print(" [*] Waiting for messages. To exit press CTRL+C")
    channel.start_consuming()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)