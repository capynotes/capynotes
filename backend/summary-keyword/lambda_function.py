import json
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

def lambda_handler(event, context):
    try:
        # Loop over each record in the event
        for record in event['Records']:
            # Parse the SQS message body
            message_body = record['body']
            
            
            # Load it as JSON
            message_data = json.loads(message_body)
            note_id = message_body.get('noteId')
            
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
