# dynamicdns
Resolves my external IP and updates my personal domain at GoDaddy.
## Example Deployment
```
cat <<EOF > dynamicdns.yaml
  dynamicdns:
    image: "jodydadescott/home-dynamicdns:latest"
    container_name: dynamicdns
    restart: always
    network_mode: host
    environment:
      KEY: "****"
      SECRET: "***"
      DOMAIN: "example.com"
      NAME: "dev"
```

edit file as necessary

```
docker-compose up -d
```
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
