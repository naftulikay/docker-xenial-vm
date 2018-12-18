# docker-xenial-vm [![Build Status][travis.svg]][travis] [![Docker Build][docker.svg]][docker]

A lightweight Ubuntu 16.04 Xenial VM in Docker, primarily used for integration testing of Ansible roles.

Available on Docker Hub as [`naftulikay/xenial-vm`][docker].

## Usage

The image and container can be built and started like so:

```
$ docker build -t naftulikay/xenial-vm:latest
$ docker run -d --name xenial -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged \
      naftulikay/xenial-vm:latest
$ docker exec -it xenial wait-for-boot
```

View [`docker-compose.yml`](./docker-compose.yml) for a working reference on how to build and run the image/container.

## License

Licensed at your discretion under either:

 - [MIT License](./LICENSE-MIT)
 - [Apache License, Version 2.0](./LICENSE-APACHE)

 [docker]: https://hub.docker.com/r/naftulikay/xenial-vm/
 [docker.svg]: https://img.shields.io/docker/automated/naftulikay/xenial-vm.svg?maxAge=2592000
 [travis]: https://travis-ci.org/naftulikay/docker-xenial-vm/
 [travis.svg]: https://travis-ci.org/naftulikay/docker-xenial-vm.svg?branch=master
