FROM public.ecr.aws/lambda/python:3.9

WORKDIR /var/task

# Install Git and other necessary dependencies
RUN yum install -y git \
    autoconf automake bzip2 bzip2-devel freetype-devel gcc gcc-c++ libogg libtool make mercurial nasm pkgconfig zlib-devel

COPY requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Download and build ffmpeg from source
RUN curl -O https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    ./configure && \
    make && \
    make install

COPY . .

CMD ["lambda_function.lambda_handler"]
