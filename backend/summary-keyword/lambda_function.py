import json
import boto3
import aws_utils

from extract import summarize_keyword

diagram_queue_url = 'https://sqs.us-east-1.amazonaws.com/211125669571/diagram_queue'
sqs = aws_utils.create_sqs_client()

def send_to_diagram(note_id):
    try:
        outgoing_message = {'noteId': note_id}
        sqs.send_message(QueueUrl=diagram_queue_url, MessageBody=json.dumps(outgoing_message))
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

def lambda_handler(event, context):
    try:
        # Loop over each record in the event
        for record in event['Records']:
            # Parse the SQS message body
            message_body = record['body']
            
            # Load it as JSON
            message_data = json.loads(message_body)
            note_id = message_data.get('noteId')
            
            # Print the message body to the Lambda log
            callback_recv(note_id)

            print("Note ID: " + note_id + " processed!")

        return {
            'statusCode': 200,
            'body': json.dumps('Successfully processed messages and sent to another queue.')
        }

    except Exception as e:
        print(f"Error processing message: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error processing messages.')
        }
