Local Revers Proxy
==================
Simple proxy server for local development that allows using the basic ports 80 and 443, which will be proxied to other ports depending on the specified domain.

For example, when navigating to the URL `https://my-site.loc`, the request will be forwarded (proxied) to `https://localhost:44310`, where another web server, such as one running in a Docker container, is operating.

Thanks to this approach, we can run many local web servers (e.g., Nginx) on different ports and work with all sites simultaneously, as if they are all running on port 80 or 443.

SSL note: "Local Reverse Proxy" is not responsible for setting up and verifying SSL certificates—it simply proxies everything to the specified port. Certificates should be located and installed on the proxied servers.


Installation
------------
- Run `cp config/sites.conf.sample config/sites.conf` - copy "sites.conf.sample" to "sites.conf".
- Set up your sites in `sites.conf`.
- Run `make d.up`.
- Go to any of your site.


### How to set up site in "sites.conf"
There are two configuration options for different ports: 80 (http) and 443 (https).

It's very simple:
- Open `config/sites.conf` file.
- If your site works only over http, add it to the http block.
- If your site works only over https, add it to the https block.
- If it works on both schemes (e.g., redirects from http to https), add it to both blocks. This might be necessary to check how the redirect works.



Something Useful
----------------

### Nginx

#### Connect to the container:
```shell
make nginx.connect
# OR
docker exec -it REVERSE_PROXY_nginx sh
```

#### Helpful commands inside container:
```shell
nginx -t         # Test config
nginx -T         # Test & Dump config
nginx -s reload  # reload the config file without stopping the server
nginx -s quit    # stop the Nginx server graceful (allowing active connections to complete)
nginx -s stop    # stop the Nginx server
nginx -V         # version and configure options
nginx -V 2>&1 | tr ' ' '\n' | grep -- '--with-' # modules
ls -al /usr/lib/nginx/modules                   # additional modules by --modules-path=/usr/lib/nginx/modules
```


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
- Support stream tls termination protocol detection: <https://trac.nginx.org/nginx/ticket/1951>



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
