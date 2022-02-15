import base64, requests, sys, os,json


CLIENT_ID = os.environ['GENESYSCLOUD_OAUTHCLIENT_ID']
CLIENT_SECRET = os.environ['GENESYSCLOUD_OAUTHCLIENT_SECRET']
ENVIRONMENT = os.environ['GENESYSCLOUD_ENVIRONMENT']

def main(workflowId): 
    
    if not workflowId:
        sys.exit("Null error: worklow id not provided")
        
    # Base64 encode the client ID and client secret
    authorization = base64.b64encode(bytes(CLIENT_ID + ":" + CLIENT_SECRET, "ISO-8859-1")).decode("ascii")

    # Prepare for POST /oauth/token request
    request_headers = {
        "Authorization": f"Basic {authorization}",
        "Content-Type": "application/x-www-form-urlencoded"
    }
    request_body = {
        "grant_type": "client_credentials"
    }

    # Get token
    response = requests.post(f"https://login.{ENVIRONMENT}/oauth/token", data=request_body, headers=request_headers)

    # Check response
    if response.status_code == 200:
        print("Got token")
    else:
        print(f"Failure: { str(response.status_code) } - { response.reason }")
        sys.exit(response.status_code)

    # Get JSON response body
    response_json = response.json()

    # Prepare for GET /api/v2/authorization/roles request
    requestHeaders = {
        "Authorization": f"{ response_json['token_type'] } { response_json['access_token']}",
        "Content-type" : "application/json"
    }

    request_body ={
        "target": {
            "type": "Workflow",
            "id": f"{workflowId}"
            },
            "enabled": "true",
        "matchCriteria": [],
            "name": "Call Disconnected Trigger",
            "topicName": "v2.detail.events.conversation.{id}.customer.end",
    }
    response = requests.post(f"https://api.{ENVIRONMENT}/platform/api/v2/processautomation/triggers", data=json.dumps(request_body), headers=requestHeaders)

    # Check response
    if response.status_code == 200:
        print("Trigger successfully created")
    else:
        print(f"Failure: { str(response.status_code) } - { response.reason }")
        sys.exit(response.status_code)   
    print("\nDone")    
                                                                                            
    
if __name__ == '__main__':
    main((sys.argv[1]))
        