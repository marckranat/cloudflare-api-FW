#!/bin/bash

# Prompt the user for their Cloudflare API token
read -p "Enter your Cloudflare API token: " API_TOKEN

# Prompt the user for their domain name
read -p "Enter the domain name you want to block IP addresses for: " DOMAIN_NAME

# Prompt the user for the list of IP addresses to block
read -p "Enter a space-separated list of IP addresses to block: " IP_ADDRESSES

# Get the zone ID for the domain name
ZONE_ID=$(curl -sX GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN_NAME" \
-H "Authorization: Bearer $API_TOKEN" \
-H "Content-Type: application/json" | jq -r '.result[0].id')

# Create a new firewall rule to block the specified IP addresses
curl -sX POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/firewall/rules" \
-H "Authorization: Bearer $API_TOKEN" \
-H "Content-Type: application/json" \
--data "{\"filter\":{\"expression\":\"ip.src in {$IP_ADDRESSES}\"}, \"action\":\"block\", \"description\":\"Blacklist IPs\"}" | jq
