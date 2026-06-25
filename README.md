Local Reverse Proxy
===================
A local proxy server that lets you use standard 80 and 443 ports, forwarding requests to configured ports based on the request domain.

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
- Add each domain to the map for the scheme it must handle.
- Specify only the destination port in each map value. 
  INFO: The destination IP is read from `PROXIED_HOST_IP` (normaly it is 127.0.0.1).
- If a site works on both schemes (e.g., redirects from HTTP to HTTPS), add it to both maps. This might be necessary to check how the redirect works.

Example:
```nginx
# HTTP sites
map $http_preread_server_name $internal_port {
  hostnames;
  holder.loc    8010;
  pbnwp.loc     8011;
  default       9;
}

# HTTPS (SSL) sites
map $ssl_preread_server_name $ssl_internal_port {
  hostnames;
  holder.loc    44310;
  pbnwp.loc     44311;
  default       9;
}
```

RECOMENDATION: Keep `default 9;` in both maps unless you intentionally want unknown domains to reach another default service. The proxy connects to `$proxied_host_ip:9`, which is expected to be closed, so unmatched Host/SNI values fail instead of showing one of your sites.



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
$upstream_addr=127.0.0.1:9     (unmatched domain, when PROXIED_HOST_IP=127.0.0.1)
$upstream_addr=127.0.0.1:8010  (matched HTTP domain, when PROXIED_HOST_IP=127.0.0.1)
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


### Windows Flow (for docker desktop + WSL2)
```text
│               
│    +--------- Windows (host OS) ----------+
│    │ localhost = 127.0.0.1                │
│    │                                      │
├────┤ WSL2 adapter gives WSL its IP:       │
│    │     egxample: 172.27.205.45          │
│    │ Windows talks to WSL only via this   │
│    +--------------------------------------+
│ ▲
├───── WSL2 (Linux subsystem)
│ ▼
│    +---------------- WSL2 ----------------+
│    │ eth0 = 172.27.205.45                 │
│    │ This is WSL's "host" for Docker      │
│    │                                      │
│    │ INFO:                                │
├────┤  Docker Engine installed inside WSL. │
│    │  OR Docker Desctop is used that      │
│    │     imulate docker inside WSL.       │
│    +--------------------------------------+
│ ▲                     
├───── Docker Containers
│ ▼
│    +-- Bridge network --+
│    │ app1: 172.17.0.2   │
├────┤ app2: 172.17.0.3   │
│    │ ...                │
│    +--------------------+
│
```

Key IPs in this setup:
- 127.0.0.1  - Windows localhost
- 172.27.x.x - WSL2 IP visible from Windows
- 172.17.x.x - Docker bridge network inside WSL
- 172.17.0.1 - Docker default gateway inside WSL

How traffic flows:

- Windows → WSL: Uses WSL IP `172.27.x.x`

- Windows → Docker container:
  We must use WSL IP + exposed port
  Example: when container exposes 8080,
  Windows opens: `http://172.27.205.45:8080`

- WSL → Docker container:
  Uses docker0 network (172.17.x.x): `curl 172.17.0.2:80`

- Docker container → WSL:
  Uses `172.17.0.1` → `172.27.x.x` NAT
  Usually containers access WSL via 172.17.0.1 (docker0 gateway)
