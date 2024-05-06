import os
import sys
import time
import boto3
import aws_utils

from extract import summarize_keyword

sqs = aws_utils.create_sqs_client()
queue_send = sqs.get_queue_by_name(QueueName='diagram_queue')

def send_to_diagram(note_id):
    try:
        response = queue_send.send_message(MessageBody=str(note_id))
        print(" [x] Sent ", str(note_id))
    except Exception as e:
        print(f"An unexpected error occurred while sending message: {e}")

def callback_recv(message):
    try:
        print(" [x] Received ", message.body)
        note_id = int(message.body)
        summarize_keyword(note_id)
        send_to_diagram(note_id)
        message.delete()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def main():
    queue_recv = sqs.get_queue_by_name(QueueName='summarization_queue')

    while True:
        try:
            print(" [*] Waiting for messages. To exit press CTRL+C")
            for message in queue_recv.receive_messages():
                callback_recv(message)

        except KeyboardInterrupt:
            print("Interrupted")
            break

        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
