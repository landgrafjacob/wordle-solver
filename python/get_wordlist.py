import json
import boto3
import os

s3 = boto3.resource("s3")
obj = s3.Object(bucket_name=os.getenv("WORDLIST_BUCKET"), key=os.getenv("WORDLIST_OBJECT"))
response = obj.get()['Body'].read().decode('utf-8').splitlines()


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(list(response))
    }
