import time
import whisper
from stable_whisper import modify_model
import torch
import os
from aws_utils import create_s3_client, get_bucket_name

# Transcribe the audio file with OpenAI - Whisper
def whisper_transcribe_audio(audio_file_name):
    s3_client = create_s3_client()
    bucket_name = get_bucket_name()
    s3_client.download_file(bucket_name, "public/" + audio_file_name, "downloads\\" + audio_file_name)
    file_path = "downloads\\" + audio_file_name

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print("Using device: ", device)

    model = whisper.load_model("medium.en").to(device)
    modify_model(model)
    result = model.transcribe(file_path, language='en', verbose=False)
    os.remove(file_path)
    return result