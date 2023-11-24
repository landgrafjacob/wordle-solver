import boto3
import json
import csv
import os

s3 = boto3.resource("s3")
obj = s3.Object(bucket_name=os.getenv("FREQ_BUCKET"), key=os.getenv("FREQ_OBJECT"))
response = obj.get()['Body'].read().decode('utf-8').splitlines()
lines = csv.reader(response)
headers = next(lines)
count_dict = {}

for line in lines:
    count_dict[line[0]] = list(map(int, line[1:]))


def lambda_handler(event, context):
    print(json.loads(event["body"]))

    wordlist = json.loads(event["body"])["wordlist"]

    high_score, best_word = 0, ''
    for word in wordlist:
        seen = set()
        score = 0
        for i, letter in enumerate(word):
            if letter not in seen:
                score += count_dict[letter][i]
                seen.add(letter)

        if score > high_score:
            best_word = word
            high_score = score

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps({
            "best_word": best_word
        })
    }
