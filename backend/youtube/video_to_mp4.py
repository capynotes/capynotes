from pytube import YouTube 
import io
import datetime
from aws_utils import create_s3_client, get_bucket_name

def upload_stream_to_s3(stream, bucket_name, object_name):
    s3_client = create_s3_client()
    try:
        # Set the pointer of the stream back to the start
        stream.seek(0)
        s3_client.upload_fileobj(stream, bucket_name, object_name)
        return True
    except Exception as e:
        print(f"Error uploading file: {e}")
        return False
    
def video_to_mp3(video_url, note_name):
    # Get video URL
    yt = YouTube(video_url) 

    # Extract only audio
    video = yt.streams.filter(file_extension='mp4', only_audio=True).first() 
    
    # Prepare the destination name
    current_timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    mp3_name = f"{current_timestamp}_" + note_name.replace(" ", "") + '.mp3'
    public_mp3_filename = "public/" + mp3_name

    # In-memory stream
    mp3_stream = io.BytesIO()
    video.stream_to_buffer(mp3_stream)

    # Convert to MP3 (if necessary, this example assumes the stream is already in MP3 format)
    # Usually you would need an external library like ffmpeg to convert from video to MP3

    # Get the S3 bucket name
    bucket_name = get_bucket_name()

    # Upload to S3
    file_status = upload_stream_to_s3(mp3_stream, bucket_name, public_mp3_filename)
    
    # Clean up the memory stream
    mp3_stream.close()
    
    if file_status:
        return mp3_name
    else:
        return False
