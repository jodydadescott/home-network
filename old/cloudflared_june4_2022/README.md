# cloudflared
Runs cloudflared binary on port of your choosing. Request sent to server will be encrypted and sent to Cloudflare. For example if you have a dns resolver running on your firewall/router you can configure it to forward to this. 

## Example Deployment
```
cat <<EOF > cloudflared.yaml
version: '2.2'
services:
  cloudflared:
    image: "jodydadescott/home-cloudflared:latest"
    container_name: cloudflared
    restart: always
    network_mode: host
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - CLOUDFLARED_PORT=4053
```

edit file as necessary

```
docker-compose up -d
```
