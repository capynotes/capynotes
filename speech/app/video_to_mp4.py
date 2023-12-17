 # importing packages 
from pytube import YouTube 
import os 
from flask import current_app
from config import get_bucket_name

def upload_mp4_to_s3(file_path, file_name):
    s3_client = current_app.extensions['s3']
    bucket_name = get_bucket_name()
    try:
        s3_client.upload_file(file_path, bucket_name, file_name)
        return True
    except Exception as e:
        print(f"Error uploading file: {e}")
        return False
    
def video_to_mp4(video_url, note_name):
    # get video url 
    yt = YouTube(video_url) 

    # extract only audio 
    video = yt.streams.filter(file_extension='mp4', only_audio=True).first() 
    
    # check for destination to save file 
    destination = "speech\\app\\downloads"

    # download the file 
    out_file = video.download(output_path=destination, filename=note_name)
    video_name = note_name 
    # save the file to locale 
    base, ext = os.path.splitext(out_file) 
    new_file_path = base + '.mp4'
    video_name = video_name + '.mp4'
    video_name = video_name.replace(" ", "")
    os.rename(out_file, new_file_path) 
  
    # upload to s3
    file_status = upload_mp4_to_s3(new_file_path, video_name)
    
    # file uploaded to s3
    # now delete the file from local
    os.remove(new_file_path)
    
    if file_status:
        return video_name
    else:
        return False

