# TeXBin

TeXBin is a service for posting and serving TeX documents as PDFs. It's also a
simple application that I've put together in order to study [Docker](http://docker.com).

**Disclaimer:** This app is just a proof of concept, so it's not really made
for production use!

## Features

* Easily deployed as a Docker container
* Automatic partition of uploaded files for fast disk lookups
* Configurable via the `.env` file

## Dependencies

* [Ruby](http://ruby-lang.org)
* [Vagrant](http://vagrantup.com)
* [Docker](http://docker.com)

## Running Texbin

### Vagrant + Docker

Just run `vagrant up --no-parallel --provider=docker` in order to build the
required images and start the containers in the proper order. This command
*will* take several minutes to complete. Go grab a coffee.

After it's done, run `vagrant status` to make sure all containers are up and
running. Then, visit <http://localhost> to open the application.

At this point, feel free to change some code and refresh the browser to see
the changes right away, without the need to reload the container yourself.

### Docker (in the cloud)

Here's how to do it manualy so you can automate the process however you want.

First, clone this project in your server and run `docker build -t texbin .`
in order to build the base image.

After that, go to `config/docker/texbin_deploy` and change whatever config
you want. Then, run `docker build -t texbin_<env> .` to build the image
tailored for the environment `env` (.i.e. `production`).

Do the same procedure in `config/docker/nginx` and build the image with
`docker build -t texbin_nginx .`.

Finally, it's time to start the containers:

```bash

$ sudo docker run --name texbin_mongodb -d mongo
$ sudo docker run --name texbin_<env>_1 -d --link texbin_mongodb:mongodb texbin_prod
$ sudo docker run --name texbin_nginx_1 -d --link texbin_<env>_1:app --volumes-from texbin_<env>_1 -p 80:80 texbin_nginx
```

Run `docker ps` to make sure all containers are up and running. Then, visit
<http://your-server-ip> to open the application.
