#!/usr/bin/env python
import json
import os
import time
import sys
import aws_utils
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
from database import get_audio_key_from_database, insert_transcription, insert_timestamps
from transcribe import whisper_transcribe_audio

# Setup SQS client
sqs = aws_utils.create_sqs_client()
summarization_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/summarization'
transcription_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/transcript'

def send_to_summarize(note_id):
    global connection_send, channel_send

    while True:
        try:
            # Send message to SQS summarization queue
            outgoing_message = {'noteId': note_id}
            sqs.send_message(QueueUrl=summarization_queue_url, MessageBody=json.dumps(outgoing_message))
            print(" [x] Sent ", str(note_id))
            break
        except (NoCredentialsError, PartialCredentialsError) as e:
            print(f"Credentials error: {e}")
            time.sleep(5)
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

def callback_recv(messages):
    for message in messages:
        message_body = json.loads(message['Body'])  # Assuming 'Body' contains a JSON string
        note_id = message_body.get('noteId')  # Extracting noteId from the message
        if note_id is None:
            print("Invalid message format. 'noteId' not found.")
            # Handle the invalid message, maybe by logging or sending it to a dead-letter queue
            continue

        print(" [x] Received noteId:", note_id)
        note_data = get_audio_key_from_database(note_id)
        audio_file_name = note_data

        result = whisper_transcribe_audio(audio_file_name)
        transcription = result['text']
        segments = result['segments']
        transcription_id_value = insert_transcription(note_id, transcription)
        transformed_list = [{'transcription_id': transcription_id_value,
                            'start': item['start'],
                            'finish': item['end'],
                            'phrase': item['text']}
                            for item in segments]
        insert_timestamps(transformed_list)
        send_to_summarize(note_id)
        # Delete message from queue after processing
        sqs.delete_message(QueueUrl=transcription_queue_url, ReceiptHandle=message['ReceiptHandle'])

def main():
    while True:
        try:
            # Receive message from SQS transcription queue
            response = sqs.receive_message(QueueUrl=transcription_queue_url, MaxNumberOfMessages=10, WaitTimeSeconds=20)
            if 'Messages' in response:
                callback_recv(response['Messages'])
            else:
                print(" [*] Waiting for messages. To exit press CTRL+C")
        except KeyboardInterrupt:
            print("Interrupted")
            break
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
