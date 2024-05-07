from pytube import YouTube
from pytube import cipher
import os
import re
from aws_utils import create_s3_client, get_bucket_name

# Define the custom Cipher class to patch the existing Cipher class
class CustomCipher:
    def __init__(self, js: str):
        self.transform_plan = cipher.get_transform_plan(js)
        # Updated regex pattern as per the suggested fix
        var_regex = re.compile(r"^[\w\$_]+\W")
        self.transform_map = cipher.get_transform_map(js, var_regex)
        self.initial_function = cipher.get_initial_function_name(js)

# Patch the pytube's Cipher class with the CustomCipher
cipher.Cipher = CustomCipher

def upload_mp4_to_s3(file_path, file_name):
    s3_client = create_s3_client()
    bucket_name = get_bucket_name()
    try:
        s3_client.upload_file(file_path, bucket_name, file_name)
        print(f"File uploaded successfully to S3 as {file_name}")
        return True
    except Exception as e:
        print(f"Error uploading file to S3: {e}")
        return False

def video_to_mp4(video_url, note_name):
    # Initialize YouTube object with the video URL
    yt = YouTube(video_url) 

    # Extract only audio in MP4 format
    video = yt.streams.filter(file_extension='mp4', only_audio=True).first() 
    
    # Define the destination directory for downloaded files
    destination = "downloads\\"

    # Download the file to the specified destination with the provided filename
    out_file = video.download(output_path=destination, filename=note_name)
    
    # Prepare the new file path with an MP4 extension
    base, ext = os.path.splitext(out_file)
    new_file_path = base + '.mp4'
    
    # Remove spaces from the file name and prepare it for S3 upload
    video_name = note_name.replace(" ", "") + '.mp4'
    os.rename(out_file, new_file_path) 

    # Upload the file to S3
    file_status = upload_mp4_to_s3(new_file_path, video_name)
    
    # Delete the file from local storage after uploading to S3
    os.remove(new_file_path)
    
    if file_status:
        return video_name
    else:
        print("Failed to upload the file to S3.")
        return False

# Example usage:
# video_to_mp4("your_video_url_here", "desired_note_name_here")
