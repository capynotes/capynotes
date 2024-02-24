#!/usr/bin/env python
import os
import sys
import pika
from database import get_note_from_database, insert_transcription, insert_timestamps
from transcribe import whisper_transcribe_audio

connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel_send = connection_send.channel()
channel_send.queue_declare(queue="summarization_queue")

def send_to_summarize(transcription_id):
    channel_send.basic_publish(exchange="", routing_key="summarization_queue", body=str(transcription_id))
    print(" [x] Sent ", str(transcription_id))

def callback_recv(ch, method, properties, body):
    note_id = int(body.decode())
    note_data = get_note_from_database(note_id)
    audio_file_name = note_data[3]
    result = whisper_transcribe_audio(audio_file_name)
    transcription = result["text"]
    segments = result["segments"]

    transcription_id_value = insert_transcription(note_id, transcription)

    transformed_list = [{'transcription_id': transcription_id_value,
                    'start': item['start'],
                    'finish': item['end'],
                    'phrase': item['text']}
                    for item in segments]
    insert_timestamps(transformed_list)

    send_to_summarize(transcription_id_value)

def main():
    connection_recv = pika.BlockingConnection(
        pika.ConnectionParameters(host="localhost"),
    )
    channel_recv = connection_recv.channel()
    channel_recv.queue_declare(queue="transcription_queue")
    channel_recv.basic_consume(
        queue="transcription_queue",
        on_message_callback=callback_recv,
        auto_ack=True,
    )

    print(" [*] Waiting for messages. To exit press CTRL+C")
    channel_recv.start_consuming()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)