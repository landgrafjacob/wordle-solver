import json
import boto3

s3 = boto3.resource("s3")
obj = s3.Object(bucket_name="wordle-freq", key="wordlist.txt")
response = obj.get()['Body'].read().decode('utf-8').splitlines()

def lambda_handler(event, context):
  return {
    "statusCode": 200,
    "headers": {
      "Content-Type": "application/json"
    },
    "body": json.dumps(list(response))
  }
