# lambda runtime: amazon linux 2 (python 3.12)

def handler(event, context):
    return {
        "statusCode": 200,
        "body": {
            "output_one": "Hello from lambda one"
        }
    }