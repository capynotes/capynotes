import time
import whisper
import torch
import os
from aws_utils import create_s3_client, get_bucket_name

# Transcribe the audio file with OpenAI - Whisper
def whisper_transcribe_audio(audio_file_name):
    s3_client = create_s3_client()
    bucket_name = get_bucket_name()
    s3_client.download_file(bucket_name, audio_file_name, "downloads\\" + audio_file_name)
    file_path = "downloads\\" + audio_file_name

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = whisper.load_model("medium.en").to(device)
    result = model.transcribe(file_path, verbose=False)
    os.remove(file_path)
    return result
  