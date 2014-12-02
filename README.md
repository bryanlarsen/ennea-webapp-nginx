ennea-webapp-nginx
==================

Automatically create nginx site configuration files based on consul service availability

This is a component of [EnneaHost](https://github.com/bryanlarsen/enneahost), but was designed to be independently useful

# Usage

- Register your service in the consul service catalog.  We recommend [registrator](https://progrium/registrator) to do this automatically.

- Create a key in Consul named "webapp/<service-name>".  The value can be anything, it's currently not used.

- Ennea-webapp-nginx will create an nginx configuration file `/etc/nginx/sites-enabled/<service-name>.conf` to proxy the service and reload nginx.

# Configuration

You can set the following keys in consul:

- `<hostname>/public_ip`.  If set, your service will be available on `http://<service>.<public_ip>.xip.io`.  This is very useful for development environments.
- `<service-name>/cname`.  The DNS address that your site should be available at.  Set's the `server_name` directive in nginx.
- `<service-name>/public`.  The location of any static files that nginx should service directly.  This is the `root` directive in nginx.

You can also directly modify the file `webapp-nginx.outer-ctmpl`.  If you make useful modifications to this file, pull requests are always welcome.

## Prerequisites

- upstart
- nginx
- [Consul](http://consul.io)
- [consul-template](https://github.com/hashicorp/consul-template)

## Installation

Run `install.sh` as root.   There are two configuration variables that you can pass to the install script if you wish to modify the defaults

- `TEMPLATE_DIR`: default `$(pwd)/templates`.  The directory to hold intermediate template files.
- `CONSUL_TEMPLATE_EXEC`: default `$(which consul-template) -consul consul.service.consul:8500`.  consul-template invocation
- `NGINX_SITES_DIR`: default `/etc/nginx/sites-enabled`

```
$ sudo TEMPLATE_DIR=/var/ennea-templates ./install.sh
```
