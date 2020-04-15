# alpine-godaddy-dynamicdns
Update Godaddy DNS Domain A record with home IP address.
## Required ENV variables
- KEY: GoDaddy KEY
- SECRET: GoDaddy Secret
- DOMAIN: DNS Domain
- NAME: A Record
## Optional ENV variables
- UPDATE_INTERVAL: Time between update/check(s) in seconds; Default 3600 (1HR)
- TTL: DNS TTL in seconds; Default 600
## Setup
- Create Godaddy key @ https://developer.godaddy.com/keys
```
docker run \
  --name dynamicdns -d \
  --restart=unless-stopped \
  --network host \
  -e KEY="*********" \
  -e SECRET="*********" \
  -e DOMAIN="example.com" \
  -e NAME="home" \
  $image
```
