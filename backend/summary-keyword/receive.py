import os
import time
import sys
import pika

from extract import summarize_keyword

connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="rabbitmq"))
channel_send = connection_send.channel()
channel_send.queue_declare(queue="diagram_queue")

def send_to_diagram(note_id):
    global connection_send, channel_send

    while True:
        try:
            if not connection_send or connection_send.is_closed:
                connection_send = pika.BlockingConnection(pika.ConnectionParameters(host="rabbitmq"))
                channel_send = connection_send.channel()
                channel_send.queue_declare(queue="diagram_queue")

            channel_send.basic_publish(exchange="", routing_key="diagram_queue", body=str(note_id))
            print(" [x] Sent ", str(note_id))
            break

        except pika.exceptions.StreamLostError as e:
            print(f"Stream connection lost: {e}")
            time.sleep(5)

        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            time.sleep(5)

def callback_recv(ch, method, properties, body):
    print(" [x] Received ", str(body))
    note_id = int(body.decode())
    summarize_keyword(note_id)
    send_to_diagram(note_id)

def main():
    while True:
        try:
            connection_recv = pika.BlockingConnection(
                pika.ConnectionParameters(host="rabbitmq"),
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