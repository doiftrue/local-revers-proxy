Local Reverse Proxy
===================
Local proxy server that lets you use standard ports 80 and 443, forwarding requests to other ports based on the domain.

For example, visiting `https://mysite.loc` proxies the request to `https://localhost:44310`, where your web server (e.g., in Docker) is running.

This allows multiple local web servers to run on different ports, while all sites appear to use port 80 or 443.

- NOTE: The proxy uses stream module, so it can proxy any TCP/UDP traffic, not just HTTP/HTTPS.
- NOTE (SSL): The proxy does not handle SSL certificates; they must be set up on the destination servers.


Installation
------------
NOTE: Ensure that you add your local domains to the system `hosts` file.

- Create the main config file from sample: `cp config/sites.conf.sample sites.conf`
- Set up sites you need in `sites.conf`.
- Run `make d.up`.
- Go to any of your sites.

### How to set up a site in `sites.conf`:
- Open the `sites.conf` file.
  NOTE: There are two configuration options for different ports: 80 (http) and 443 (https). 
- If your site works only over http, add it to the "http" block.
- If your site works only over https, add it to the "https" block.
- If it works on both schemes (e.g., redirects from http to https), add it to both blocks. This might be necessary to check how the redirect works.



Nginx Info
----------
### Connect to the container:
```shell
make nginx.connect
```

### Helpful commands inside the container:
```shell
nginx -t         # Test config
nginx -T         # Test & Dump config
nginx -s reload  # Reload the config file without stopping the server
nginx -s quit    # Stop the Nginx server gracefully (allowing active connections to complete)
nginx -s stop    # Stop the Nginx server
nginx -V         # Version and configure options
nginx -V 2>&1 | tr ' ' '\n' | grep -- '--with-' # Modules
ls -al /usr/lib/nginx/modules                   # Additional modules by --modules-path=/usr/lib/nginx/modules
```

### Nginx variables examples
```shell
$protocol=TCP
$status=200
$hostname=ubuntu
$server_name=
$ssl_preread_server_name=-          (http)
$ssl_preread_server_name=holder.loc (https)
$server_addr=127.0.0.2
$remote_addr=127.0.0.1
$upstream_addr=127.0.0.1:8019
```



Useful Notes
------------

### Useful links
Nginx all directives: <https://nginx.org/ru/docs/dirindex.html>
- stream_core:     <https://nginx.org/ru/docs/stream/ngx_stream_core_module.html>
- stream_proxy:    <https://nginx.org/ru/docs/stream/ngx_stream_proxy_module.html>
- stream_ssl:      <https://nginx.org/ru/docs/stream/ngx_stream_ssl_module.html>
- stream_upstream: <https://nginx.org/ru/docs/stream/ngx_stream_upstream_module.html>

Nginx as a Reverse Stream Proxy: <https://www.eigenmagic.com/2021/09/20/nginx-as-a-reverse-stream-proxy/>

#### Detect HTTP headers for stream
- Extracting HTTP Host Header from nginx Stream Proxy: <https://serverfault.com/questions/1015880/extracting-http-host-header-from-nginx-stream-proxy>
- How nginx processes a TCP/UDP session: <https://nginx.org/en/docs/stream/stream_processing.html>
- Support stream TLS termination protocol detection: <https://trac.nginx.org/nginx/ticket/1951>


### Windows flow (when docker is installed inside WSL2)
```text
               Windows (host OS)
    +--------------------------------------+
    | localhost = 127.0.0.1                |
    |                                      |
    | WSL2 adapter gives WSL its IP:       |
    |     egxample: 172.27.205.45          |
    | Windows talks to WSL only via this   |
    +--------------------------------------+
                      ▲
                      |
                Windows → WSL2
                      |
                      ▼
            WSL2 (Linux subsystem)
    +--------------------------------------+
    | eth0 = 172.27.205.45                 |
    | This is WSL's "host" for Docker      |
    |                                      |
    | Docker Engine installed inside WSL   |
    | creates bridge network:              |
    |                                      |
    | docker0 = 172.17.0.1                 |
    +--------------------------------------+
                      ▲
                      |
              WSL → Docker Engine
                      |
                      ▼
         Docker containers (bridge network)
    +------------------------------------------+
    | app1: 172.17.0.2                         |
    | app2: 172.17.0.3                         |
    | ...                                      |
    +------------------------------------------+
```

How traffic flows:

- Windows → WSL:
  - Uses WSL IP 172.27.x.x
  - Example: `http://172.27.205.45:8080`

- Windows → Docker container inside WSL:
  - Windows must use WSL IP + exposed port
  - Example:
      container exposes 8080
      Windows opens: `http://172.27.205.45:8080`

- WSL → Docker container:
  - Uses docker0 network (172.17.x.x)
  - Example: `curl 172.17.0.2:80`

- Docker container → WSL:
  - Uses 172.17.0.1 → 172.27.x.x NAT
  - Usually containers access WSL via 172.17.0.1 (docker0 gateway)

Key IPs in this setup:
- 127.0.0.1  - Windows localhost
- 172.27.x.x - WSL2 IP visible from Windows
- 172.17.x.x - Docker bridge network inside WSL
- 172.17.0.1 - Docker default gateway inside WSL
