#!/usr/bin/env python
import os
import time
import sys
import pika
import json
from video_to_mp4 import video_to_mp4
from database import update_s3_name

connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="rabbitmq"))
channel_send = connection_send.channel()
channel_send.queue_declare(queue="transcription_queue")

def send_to_speech(note_id):
    global connection_send, channel_send

    while True:
        try:
            if not connection_send or connection_send.is_closed:
                connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="rabbitmq"))
                channel_send = connection_send.channel()
                channel_send.queue_declare(queue="transcription_queue")

            channel_send.basic_publish(exchange="", routing_key="transcription_queue", body=str(note_id))
            print(" [x] Sent ", str(note_id))
            break

        except pika.exceptions.StreamLostError as e:
            print(f"Stream connection lost: {e}")
            time.sleep(5)

        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

def callback_recv(ch, method, properties, body):
    try:
        print(" [x] Received ", str(body))
        yt_json_data = json.loads(body.decode())

        note_id = yt_json_data["noteId"]
        video_url = yt_json_data["videoUrl"]
        note_name = yt_json_data["noteName"]

        file_name = video_to_mp4(video_url, note_name)
        if file_name:
            update_s3_name(note_id, file_name)
            send_to_speech(int(note_id))
        else:
            print("An Error Occurred. Please Try Again Later.")
    except Exception as e:
        print("An unexpected error occurred:", str(e))

def main():
    while True:
        try:
            connection_recv = pika.BlockingConnection(
                pika.ConnectionParameters(host="rabbitmq"),
            )
            channel_recv = connection_recv.channel()
            channel_recv.queue_declare(queue="youtube_queue")
            channel_recv.basic_consume(
                queue="youtube_queue",
                on_message_callback=callback_recv,
                auto_ack=True,
            )

            print(" [*] Waiting for messages. To exit press CTRL+C")
            channel_recv.start_consuming()

        except pika.exceptions.StreamLostError as e:
            print(f"Stream connection lost: {e}")
            print("Reconnecting...")
            time.sleep(5)
            continue

        except KeyboardInterrupt:
            print("Interrupted")
            break

        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            break

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)