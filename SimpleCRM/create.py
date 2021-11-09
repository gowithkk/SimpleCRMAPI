import json
import boto3

def lambda_handler(event, context):

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('SimpleCRM')

    response = table.put_item(
        Item={
            'id': event['id'],
            'firstName': event['firstName'],
            'lastName': event['lastName'],
            'Address': event['Address']
        }
    )

    message = {
        'message': 'Customer ID '+ event['id'] + ' has been added successfully!'
    }
    return {
        'statusCode': 200,
        'body': json.dumps(message)
    }