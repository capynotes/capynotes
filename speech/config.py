class Config:
    DEBUG = True
    AWS_ACCESS_KEY_ID = 'AKIARPNBY32BMGXGP5XR'
    AWS_SECRET_ACCESS_KEY = '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'
    S3_BUCKET_NAME = 'cs49x-transcribe'
    REGION = 'eu-north-1'

def get_aws_credentials():
    return {
        'aws_access_key_id': Config.AWS_ACCESS_KEY_ID,
        'aws_secret_access_key': Config.AWS_SECRET_ACCESS_KEY,
        'region_name': Config.REGION
    }

def get_bucket_name():
    return Config.S3_BUCKET_NAME