import os
import time
import sys
import pika

from database import get_summary_from_database, insert_keyword_definitions
from extract import extract_keywords

def callback_recv(ch, method, properties, body):
    summary_id = int(body.decode())
    summary_data = get_summary_from_database(summary_id)
    note_id = summary_data[1]
    raw_keyword_def_list = extract_keywords(summary_data[2])
    transformed_list = [{'note_id': note_id,
                    'keyword': item['keyword'],
                    'definition': item['definition']}
                    for item in raw_keyword_def_list]
    print()
    print("transformed list: ", transformed_list)
    insert_keyword_definitions(transformed_list)

def main():
    while True:
        try:
            connection_recv = pika.BlockingConnection(
                pika.ConnectionParameters(host="localhost"),
            )
            channel_recv = connection_recv.channel()
            channel_recv.queue_declare(queue="keyword_queue")
            channel_recv.basic_consume(
                queue="keyword_queue",
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