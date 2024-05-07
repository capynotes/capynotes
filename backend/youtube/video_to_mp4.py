import os
from aws_utils import create_s3_client, get_bucket_name

def upload_mp4_to_s3(file_path, file_name):
    s3_client = create_s3_client()
    bucket_name = get_bucket_name()
    try:
        s3_client.upload_file(file_path, bucket_name, file_name)
        return True
    except Exception as e:
        print(f"Error uploading file: {e}")
        return False

def video_to_mp4(video_url, note_name):
    # Setup the download directory and filename
    destination = "downloads/"
    video_name = note_name.replace(" ", "") + '.mp4'
    destination_file_path = os.path.join(destination, video_name)
    
    # Configure yt-dlp command
    from yt_dlp import YoutubeDL
    ydl_opts = {
        'format': 'bestaudio/best',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp4',
        }],
        'outtmpl': destination_file_path,
        'noplaylist': True
    }
    
    # Download the file
    with YoutubeDL(ydl_opts) as ydl:
        try:
            ydl.download([video_url])
        except Exception as e:
            print(f"Error downloading video: {e}")
            return False

    # Check if the file was downloaded and upload to S3
    if os.path.exists(destination_file_path):
        file_status = upload_mp4_to_s3(destination_file_path, video_name)
        
        # Delete the file from local after uploading
        os.remove(destination_file_path)
        
        if file_status:
            return video_name
        else:
            return False
    else:
        print("Failed to download the video.")
        return False

