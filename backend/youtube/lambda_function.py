import json
import boto3
from video_to_mp4 import video_to_mp3
from database import update_s3_name
import aws_utils

# Setup SQS client
sqs = aws_utils.create_sqs_client()
youtube_queue_url = 'https://sqs.us-east-1.amazonaws.com/211125669571/youtube'
transcription_queue_url = 'https://sqs.us-east-1.amazonaws.com/211125669571/transcription'

def send_to_speech(note_id):
    try:
        # Send message to SQS transcription queue
        outgoing_message = {'noteId': note_id}
        sqs.send_message(QueueUrl=transcription_queue_url, MessageBody=json.dumps(outgoing_message))
        print(" [x] Sent ", str(note_id))
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def process_message(message):
    print(" [x] Received ", message['body'])
    yt_json_data = json.loads(message['body'])

    note_id = yt_json_data["noteId"]
    video_url = yt_json_data["videoUrl"]
    note_name = yt_json_data["noteName"]

    file_name = video_to_mp3(video_url, note_name)
    if file_name:
        update_s3_name(note_id, file_name)
        send_to_speech(int(note_id))
    else:
        print("An Error Occurred. Please Try Again Later.")

def lambda_handler(event, context):
    # Process each message from SQS
    for record in event['Records']:
        try:
            process_message(record)
            # Delete message from queue after processing
            sqs.delete_message(
                QueueUrl=youtube_queue_url,  # Directly use the ARN from the record
                ReceiptHandle=record['receiptHandle']
            )
        except Exception as e:
            print("An unexpected error occurred:", str(e))

    return {
        'statusCode': 200,
        'body': json.dumps('Successfully processed messages from SQS.')
    }
