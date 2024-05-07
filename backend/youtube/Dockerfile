FROM public.ecr.aws/lambda/python:3.9

WORKDIR /var/task

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install dependencies required to build ffmpeg
RUN yum install -y autoconf automake bzip2 bzip2-devel freetype-devel gcc gcc-c++ libogg libtool make mercurial nasm pkgconfig zlib-devel

# Download and build ffmpeg from source
RUN curl -O https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    ./configure && \
    make && \
    make install

COPY . .

CMD ["lambda_function.lambda_handler"]
