import boto3
from PIL import Image
import io
from aws_lambda_powertools import Logger
import json
import os

s3 = boto3.client('s3')
logger = Logger()


def lambda_handler(event, context):
    logger.info(event)

    bucket = os.environ.get("IMAGE_BUCKET")
    app_stage = os.environ.get("APP_STAGE")
    key = "reinvent2023/test.jpeg"

    if app_stage == 'prod':
        title = f"Building Serverless Applications with Terraform - CICD"
    else:
        title = f"{app_stage} - Building Serverless Applications with Terraform"

    if 'queryStringParameters' not in event:
        presigned_url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket, 'Key': key},
            ExpiresIn=3600  # URL expires in 1 hour
        )
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "title": title,
                "presigned_url": presigned_url,
            })
        }

    queryStringParameters = event['queryStringParameters']
    logger.info(queryStringParameters)

    try:

        rotate = queryStringParameters['rotate']

        file_byte_string = s3.get_object(Bucket=bucket, Key=key)['Body'].read()

        # Open the image
        image = Image.open(io.BytesIO(file_byte_string))

        if "convert" in queryStringParameters and queryStringParameters['convert'] == 'true':
            image = image.convert('L')

        # Rotate the image
        rotateImage = image.rotate(int(rotate), expand=True)

        # Save the rotated image
        byte_arr = io.BytesIO()
        rotateImage.save(byte_arr, format='JPEG')
        byte_arr = byte_arr.getvalue()

        # Save the rotated image to S3
        output_key = 'reinvent2023/test-result.jpeg'
        s3.put_object(Bucket=bucket, Key=output_key, Body=byte_arr)

        # Generate a presigned URL for the rotated image
        presigned_url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket, 'Key': output_key},
            ExpiresIn=3600  # URL expires in 1 hour
        )

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "title": title,
                "presigned_url": presigned_url,
            })
        }
    except Exception as e:
        logger.error(e)
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "title": title,
                "message": "Internal server error",
                "error": str(e),
                "event": event,
            })
        }
