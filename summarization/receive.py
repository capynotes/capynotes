import os
import sys
import pika

from database import get_trascription_from_database, insert_summary
from summarize import summarize_text


connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel_send = connection_send.channel()
channel_send.queue_declare(queue="keyword_queue")

def send_to_keyword_extraction(summary_id):
    channel_send.basic_publish(exchange="", routing_key="keyword_queue", body=str(summary_id))
    print(" [x] Sent ", str(summary_id))


def callback_recv(ch, method, properties, body):
    transcription_id = int(body.decode())

    # return the transcription information of the note
    transcription_data = get_trascription_from_database(transcription_id)

    # ob tain the note_id of the received trancription
    note_id = transcription_data[1]

    # summarize the transcription
    summary = summarize_text(transcription_data[2])

    # insert currently created dummary to the summary table
    summary_id = insert_summary(note_id, summary)

    # push the summary id to keyword extraction queue
    send_to_keyword_extraction(summary_id)



def main():
    connection_recv = pika.BlockingConnection(
        pika.ConnectionParameters(host="localhost"),
    )
    channel_recv = connection_recv.channel()
    channel_recv.queue_declare(queue="summarization_queue")
    channel_recv.basic_consume(
        queue="summarization_queue",
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