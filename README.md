Local Revers Proxy
==================
Simple proxy server for local development that allows using the basic ports 80 and 443, which will be proxied to other ports depending on the specified domain.

For example, when navigating to the URL https://my-site.loc, the request will be forwarded (proxied) to https://localhost:44310, where another web server, such as one running in a Docker container, is operating.

Thanks to this approach, we can run many local web servers (e.g., Nginx) on different ports and work with all sites simultaneously, as if they are all running on port 80 or 443.

SSL note: "Local Reverse Proxy" is not responsible for setting up and verifying SSL certificates—it simply proxies everything to the specified port. Certificates should be located and installed on the proxied servers.


Installation
------------
- Copy `sites.conf.sample` to `sites.conf`: run `cp sites.conf.sample sites.conf`.
- Set up your sites in `sites.conf`.
- Run `make d.up`.
- Go to any of your site.


How to set up site in sites.conf
--------------------------------
Тут есть два варината конфигурации для разных портов 80 (http) 443 (https). 

Все очень просто: 
- Если ваш сайт работат только по http, то следует добавить его в http блок.
- Если ваш сайт работат только по https, то следует добавить его в https блок.
- Если он работат на обоим схемам (например редиректит с http на https), то нужно добавить в оба блока. Это может быть нужно, чтобы проверять как работает редирект.


Useful links
------------
Nginx all directives: <https://nginx.org/ru/docs/dirindex.html>
  - stream_core:     <https://nginx.org/ru/docs/stream/ngx_stream_core_module.html>
  - stream_proxy:    <https://nginx.org/ru/docs/stream/ngx_stream_proxy_module.html>
  - stream_ssl:      <https://nginx.org/ru/docs/stream/ngx_stream_ssl_module.html>
  - stream_upstream: <https://nginx.org/ru/docs/stream/ngx_stream_upstream_module.html>

Nginx as a Reverse Stream Proxy: <https://www.eigenmagic.com/2021/09/20/nginx-as-a-reverse-stream-proxy/>

### Detect HTTP headers for stream
- Extracting HTTP Host Header from nginx Stream Proxy: <https://serverfault.com/questions/1015880/extracting-http-host-header-from-nginx-stream-proxy>
- How nginx processes a TCP/UDP session: <https://nginx.org/en/docs/stream/stream_processing.html>
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



Nginx variables examples
------------------------
$protocol=TCP
$status=200
$hostname=ubuntu
$server_name=
$ssl_preread_server_name=-          (http)
$ssl_preread_server_name=holder.loc (https)
$server_addr=127.0.0.2
$remote_addr=127.0.0.1
$upstream_addr=127.0.0.1:8019
