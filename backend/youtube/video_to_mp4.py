 # importing packages 
from pytube import YouTube 
import os
import datetime
from aws_utils import create_s3_client, get_bucket_name

def upload_mp4_to_s3(file_path, file_name):
    s3_client = create_s3_client()
    bucket_name = get_bucket_name()
    try:
        s3_client.upload_file(file_path, bucket_name, "public/" + file_name)
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
    destination = "downloads\\"

    # download the file 
    out_file = video.download(output_path=destination, filename=note_name)
    video_name = note_name 
    # save the file to locale 
    # base, ext = os.path.splitext(out_file) 
    # new_file_path = base + '.mp4'
    video_name = video_name + '.mp4'
    video_name = video_name.replace(" ", "")
    current_datetime = datetime.datetime.now()
    current_datetime_str = current_datetime.strftime("%Y-%m-%d%H:%M:%S")
    video_name = current_datetime_str + video_name 
    os.rename(out_file, video_name) 
  
    # upload to s3
    file_status = upload_mp4_to_s3(video_name, video_name)
    
    # file uploaded to s3
    # now delete the file from local
    os.remove(video_name)
    
    if file_status:
        return video_name
    else:
        return False
