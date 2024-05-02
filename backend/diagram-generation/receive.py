import os
import time
import sys
import pika

from mermaid_diagram_generation import generate_diagrams

def callback_recv(ch, method, properties, body):
    print(" [x] Received ", str(body))
    note_id = int(body.decode())
    generate_diagrams(note_id)
    
def main():
    while True:
        try:
            connection_recv = pika.BlockingConnection(
                pika.ConnectionParameters(host="rabbitmq"),
            )
            channel_recv = connection_recv.channel()
            channel_recv.queue_declare(queue="diagram_queue")
            channel_recv.basic_consume(
                queue="diagram_queue",
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