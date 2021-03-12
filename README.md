# Docker images for tests

## Prerequsites

* docker
* docker-compose

edit the `.env` if needed, then run:

```
docker-compose up -d
```

## Containers

* Nginx
* InfluxDB
* Grafana
* [Graphite](https://hub.docker.com/r/vimagick/graphite)

## Mounted volumes

The volumes are configured to mount in the current directory for `nginx`, `grafana`, `graphite`, and `influxdb`, feel free to change if needed


Check to make sure they are up, e.g.:

```
docker ps
docker logs nginx
docker logs grafana
docker logs influxdb
docker logs graphite
```

## Firewall
In CrapOs or RHEL, either disable the firewall or open the ports for influx/nginx/grafana



# Software Needed

1. VDBench		Installed on machine where benchmarks are run
2. Grafana		Installed on machine where Grafana and Web pages are hosted
3. Apache web server	Installed on machine where Grafana and Web pages are hosted


# Scripts

## Update, 2021-01-22 cdukes
I re-wrote everything to a perl script, the new script is a **lot** easier to use.

To use, edit `runtests.ini` to your liking and run:

```
./runtests.pl
```

or

```
./runtests -h
```
