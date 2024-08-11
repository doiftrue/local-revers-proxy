Installation
============
TODO


How to add a new site
---------------------
TODO


Useful
------
Nginx all directives: <https://nginx.org/ru/docs/dirindex.html>
  - stream_core:     <https://nginx.org/ru/docs/stream/ngx_stream_core_module.html>
  - stream_proxy:    <https://nginx.org/ru/docs/stream/ngx_stream_proxy_module.html>
  - stream_ssl:      <https://nginx.org/ru/docs/stream/ngx_stream_ssl_module.html>
  - stream_upstream: <https://nginx.org/ru/docs/stream/ngx_stream_upstream_module.html>

Nginx as a Reverse Stream Proxy: <https://www.eigenmagic.com/2021/09/20/nginx-as-a-reverse-stream-proxy/>

### Detect HTTP info for stream
- Extracting HTTP Host Header from nginx Stream Proxy: <https://serverfault.com/questions/1015880/extracting-http-host-header-from-nginx-stream-proxy>
- Support stream tls termination protocol detection: <https://trac.nginx.org/nginx/ticket/1951>



Nginx
-----
### Go into the container:
```shell
make nginx.connect
# OR
docker exec -it REVERSE_PROXY_nginx sh
```

### Helpful commands inside container:
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
NOTE: fastcgi_params see inside container `/etc/nginx/fastcgi_params`.



Nginx variables examples
------------------------
$protocol=TCP
$status=200
$hostname=kamaubuntu
$server_name=
$ssl_preread_server_name=-          (http)
$ssl_preread_server_name=holder.loc (https)
$server_addr=127.0.0.2
$remote_addr=127.0.0.1
$upstream_addr=127.0.0.1:8019
