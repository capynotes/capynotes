#!/usr/bin/env python
import os
import time
import sys
import aws_utils
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
from database import get_note_from_database, insert_transcription, insert_timestamps
from transcribe import whisper_transcribe_audio

# Setup SQS client
sqs = aws_utils.create_sqs_client()
summarization_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/summarization'
transcription_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/transcript'

def send_to_summarize(transcription_id):
    while True:
        try:
            # Send message to SQS summarization queue
            sqs.send_message(QueueUrl=summarization_queue_url, MessageBody=str(transcription_id))
            print(" [x] Sent ", str(transcription_id))
            break
        except (NoCredentialsError, PartialCredentialsError) as e:
            print(f"Credentials error: {e}")
            time.sleep(5)
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

def callback_recv(messages):
    for message in messages:
        print(" [x] Received ", str(message['Body']))
        note_id = int(message['Body'])
        note_data = get_note_from_database(note_id)
        audio_file_name = note_data[5]

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
        send_to_summarize(transcription_id_value)
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
