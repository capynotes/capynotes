FROM public.ecr.aws/lambda/python:3.9

WORKDIR /var/task

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# CMD is not needed as AWS Lambda requires handler specification
# Define function handler
CMD ["lambda_function.lambda_handler"]
