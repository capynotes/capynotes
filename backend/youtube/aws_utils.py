import boto3
from config import Config

def get_aws_credentials():
    return {
        'aws_access_key_id': Config.AWS_ACCESS_KEY_ID,
        'aws_secret_access_key': Config.AWS_SECRET_ACCESS_KEY,
        'region_name': Config.REGION
    }

def get_bucket_name():
    return Config.S3_BUCKET_NAME

def create_s3_client():
    return boto3.client('s3', **get_aws_credentials())

def create_sqs_client():
    return boto3.client('sqs', **get_aws_credentials())