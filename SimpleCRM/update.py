import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('SimpleCRM')
    response = table.update_item(
        Key={
            'id': event['id']
        },
        UpdateExpression='SET firstName=:f, lastName=:l, Address=:a',
        ExpressionAttributeValues={
            ':f': event['firstName'],
            ':l': event['lastName'],
            ':a': event['Address']
        },
        ReturnValues="UPDATED_NEW"
    )

    message = {
        'message': 'Customer ID '+ event['id'] + ' has been updated successfully!'
    }
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': json.dumps(message)
    }