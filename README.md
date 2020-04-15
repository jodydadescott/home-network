# Home Network
This is a collection of containers that I use to run my home network.

## Details
My home network consist of multiple UBNT (Ubiquiti Networks) wireless access points (WAPs), a UBNT POE switch, a UBNT router/firewall, an Intel NUC and other miscellaneous components. The Intel NUC runs Flatcar Linux and supports my Docker containers. I run DNS on the UBNT router as this allows me to configure host via the UBNT UI manager. I have the UBNT configured to forward non-authorative request to my resolver container. The resolver container either resolves using its cache or sends the request to the cloudflared container. In bound HTTPS are handled by the NGINX container which automatically fetches a Lets Encrypt certficiate. It forwards the request based on port. It is confiugre to only support TLS1.3.

## Containers

### cloudflared
This runs the cloudflared daemon which encrypts and sends dns request to Cloudflare for resolution.

### resolver
This runs a dns non-authorative cache resolver. If it is unable to resolve via cache it sends the request to cloudflared.

### dynamicdns
This periodically resolves my external IP address and updates my personal domain hosted with GoDaddy.

### nginx
This container automatically obtains a Lets Encrypt Certificate for my personal domain. It forwards request based on port to the desired internal host using the aforementioned certificate. It automatically renews the certificate.

### etc
I also make use of a few prebuilt containers such as jacobalberty/unifi and openhab/openhab

```
version: '2.2'
services:
  openhab:
    image: "openhab/openhab:2.4.0"
    container_name: openhab
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
    restart: always
    network_mode: host
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "/mnt/flash/persist/container_data/openhab/addons:/openhab/addons"
      - "/mnt/flash/persist/container_data/openhab/conf:/openhab/conf"
      - "/mnt/flash/persist/container_data/openhab/userdata:/openhab/userdata"
    environment:
      OPENHAB_HTTP_PORT: "7080"
      OPENHAB_HTTPS_PORT: "7443"
      EXTRA_JAVA_OPTS: "-Duser.timezone=America/Chicago"
  unifi:
    image: "jacobalberty/unifi:latest"
    container_name: unifi
    restart: always
    network_mode: host
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "/mnt/flash/persist/container_data/unifi:/unifi"
```
