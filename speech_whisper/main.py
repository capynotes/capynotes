#Pure Whisper S2T example snippet
""" import whisper

model = whisper.load_model("small.en")
result = model.transcribe("./test1.mp3")

print(result["text"]) """

import boto3
import whisper
import os

# Replace these with your S3 credentials and bucket information
aws_access_key_id = 'AKIARPNBY32BMGXGP5XR'
aws_secret_access_key = 'IlV8dIEZEBIiehInZwO4kpjrSaC8hNQNC32EDLZI'
bucket_name = 'cs49x-transcribe'
object_key = 'test1.mp3'    #Name of the file in bucket

# Download the audio file
client = boto3.client('s3', aws_access_key_id = aws_access_key_id, aws_secret_access_key = aws_secret_access_key)

client.download_file(bucket_name, object_key, "./downloads/"+object_key)

# Transcribe the audio content
model = whisper.load_model("small.en")
result = model.transcribe("./downloads/"+object_key)
os.remove("./downloads/"+object_key)

print(result["text"])