import requests

# Define the authentication API URL and parameters
auth_url = "https://api.example.com/login"
username = "your_username"
password = "your_password"

# Define the request parameters, including your credentials
params = {
    "username": username,
    "password": password
}

# Make the API request
response = requests.get(auth_url, params=params)

# Process the response
if response.status_code == 200:
    data = response.json()
    # Your authentication was successful
    # Extract any relevant data from the response
else:
    # Your authentication failed
    print(f"Error {response.status_code}: {response.text}")