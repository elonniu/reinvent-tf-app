import boto3
from PIL import Image
import io
from aws_lambda_powertools import Logger
import json

s3 = boto3.client('s3')
logger = Logger()


def lambda_handler(event, context):
    logger.info(event)

    try:
        body = json.loads(event['body'])
        logger.info(body)

        bucket = body['bucket']
        key = body['key']
        rotate = body['rotate']

        file_byte_string = s3.get_object(Bucket=bucket, Key=key)['Body'].read()

        # Open the image
        image = Image.open(io.BytesIO(file_byte_string))

        # Rotate the image
        rotated_image = image.rotate(int(rotate))

        # Save the rotated image
        byte_arr = io.BytesIO()
        rotated_image.save(byte_arr, format='JPEG')
        byte_arr = byte_arr.getvalue()

        # Save the rotated image to S3
        output_key = 'rotated-' + key
        s3.put_object(Bucket=bucket, Key=output_key, Body=byte_arr)

        # Generate a presigned URL for the rotated image
        presigned_url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket, 'Key': output_key},
            ExpiresIn=3600  # URL expires in 1 hour
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "parameters": body,
                "presigned_url": presigned_url,
            })
        }
    except Exception as e:
        logger.error(e)
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Internal server error",
                "error": str(e),
                "event": str(event),
            })
        }
