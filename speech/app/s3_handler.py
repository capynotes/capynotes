from config import get_bucket_name

def get_job_uri(audio_file_name):
    s3_bucket_name = get_bucket_name()
    return f"s3://{s3_bucket_name}/{audio_file_name}"