import pandas as pd
import time
from flask import current_app
from app.s3_handler import get_job_uri

def check_job_name(transcribe_client, job_name):
    job_verification = True
    
    # all the transcriptions
    existed_jobs = transcribe_client.list_transcription_jobs()

    for job in existed_jobs['TranscriptionJobSummaries']:
        if job_name == job['TranscriptionJobName']:
            job_verification = False
            break

    if not job_verification:
        transcribe_client.delete_transcription_job(TranscriptionJobName=job_name)
    
    return job_name

def transcribe_audio(audio_file_name):
    transcribe_client = current_app.extensions['transcribe']

    job_uri = get_job_uri(audio_file_name)
  
    job_name = (audio_file_name.split('.')[0]).replace(" ", "")

    # file format
    file_format = audio_file_name.split('.')[1]

    # check if name is taken or not
    job_name = check_job_name(transcribe_client, job_name)
    transcribe_client.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={'MediaFileUri': job_uri},
        MediaFormat=file_format,
        LanguageCode='en-US'
    )

    while True:
        result = transcribe_client.get_transcription_job(TranscriptionJobName=job_name)
        if result['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
            break
        time.sleep(15)

    if result['TranscriptionJob']['TranscriptionJobStatus'] == "COMPLETED":
        data = pd.read_json(result['TranscriptionJob']['Transcript']['TranscriptFileUri'])
  
    return data['results'][1][0]['transcript']