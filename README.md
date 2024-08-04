Installation
============
TODO


How to add a new site
---------------------
TODO


Useful
------
Nginx all directives: https://nginx.org/ru/docs/dirindex.html
  - stream_proxy: https://nginx.org/ru/docs/stream/ngx_stream_proxy_module.html
  - stream_upstream: https://nginx.org/ru/docs/stream/ngx_stream_upstream_module.html

Nginx as a Reverse Stream Proxy: https://www.eigenmagic.com/2021/09/20/nginx-as-a-reverse-stream-proxy/


Nginx
-----
Go into the container:
```shell
make nginx.connect
# OR
docker exec -it nginx sh
```

Commands inside container:
```shell
nginx -t         # Test config
nginx -T         # Test & Dump config
nginx -s reload  # reload the configuration file
nginx -s quit    # graceful shutdown
```
NOTE: fastcgi_params see inside container `/etc/nginx/fastcgi_params`.
