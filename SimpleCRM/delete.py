import json
import boto3

def lambda_handler(event, context):
    
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('SimpleCRM')
    
    response = table.delete_item(
        Key={
            'id': event['id']
        })
    
    message = {
        'message': 'Customer ID ' + event['id'] + 'has been deleted.'
    }
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': json.dumps(message)
    }
