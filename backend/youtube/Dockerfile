# Use the base image from AWS Lambda for Python 3.9
FROM public.ecr.aws/lambda/python:3.9

# Set the working directory to /var/task
WORKDIR /var/task

# Copy the requirements.txt file to the container
COPY requirements.txt ./

# Install Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Update and install ffmpeg using the Amazon Linux package manager
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y ffmpeg

# Copy the rest of your application to the container
COPY . .

# Set the CMD to your handler function; adjust this as needed
# For instance, if receive.py includes a function named handler:
CMD ["lambda_function.lambda_handler"]
