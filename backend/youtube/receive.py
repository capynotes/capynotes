#!/usr/bin/env python
import os
import sys
import time
import json
import boto3
import aws_utils
from video_to_mp4 import video_to_mp4
from database import update_s3_name

# Setup SQS client
sqs = aws_utils.create_sqs_client()
youtube_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/youtube'
transcription_queue_url = 'https://sqs.eu-north-1.amazonaws.com/101807873666/transcript'

def send_to_speech(note_id):
    while True:
        try:
            # Send message to SQS transcription queue
            sqs.send_message(QueueUrl=transcription_queue_url, MessageBody=str(note_id))
            print(" [x] Sent ", str(note_id))
            break
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

def callback_recv(messages):
    for message in messages:
        try:
            print(" [x] Received ", message['Body'])
            yt_json_data = json.loads(message['Body'])

            note_id = yt_json_data["noteId"]
            video_url = yt_json_data["videoUrl"]
            note_name = yt_json_data["noteName"]

            file_name = video_to_mp4(video_url, note_name)
            if file_name:
                update_s3_name(note_id, file_name)
                send_to_speech(int(note_id))
            else:
                print("An Error Occurred. Please Try Again Later.")

            # Delete message from queue after processing
            sqs.delete_message(QueueUrl=youtube_queue_url, ReceiptHandle=message['ReceiptHandle'])
        except Exception as e:
            print("An unexpected error occurred:", str(e))

def main():
    while True:
        try:
            # Receive messages from SQS youtube queue
            response = sqs.receive_message(
                QueueUrl=youtube_queue_url,
                MaxNumberOfMessages=10,
                WaitTimeSeconds=20,  # Long polling
                VisibilityTimeout=300  # Visibility timeout to process the message
            )
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
