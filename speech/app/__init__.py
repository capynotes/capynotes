from flask import Flask
import boto3
from config import Config, get_aws_credentials

def create_app():
    app = Flask(__name__)

    app.config.from_object(Config)

    # Set up extensions
    app.extensions['transcribe'] = boto3.client('transcribe', **get_aws_credentials())

    # Register blueprints
    from app.routes import main_bp
    app.register_blueprint(main_bp)

    return app