# docker-xenial-vm [![Build Status][svg-travis]][travis]

A lightweight Ubuntu 16.04 Xenial VM in Docker. [Based on `geerlingguy/docker-ubuntu1604-ansible`][upstream], do read
the author's [excellent post][post] about testing Ansible across multiple operating systems.

Published to the Docker Hub as `naftulikay/xenial-vm`.

### Running:

Ubuntu 16.04 uses systemd as an init system, so it requires running in `--privileged` mode with at least read-only
access to the `/sys/fs/cgroup` socket:

```
docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro naftulikay/xenial-vm:latest
```

A lot of the work to discover what was necessary for systemd to run in Docker was be provided by the
[SELinux Man Himself, Dan Walsh][dwalsh], in [some RedHat documentation][redhat-docker-systemd].

### Testing Ansible Roles

To test Ansible roles, pass something of the following to mount your role and execute your tests against it:

```
--volume=$(pwd):/etc/ansible/roles/$ROLE_NAME:ro
```

When starting the container, a container ID is emitted; this can be saved and used to execute commands within the Docker
"VM":

```
docker exec --tty $CONTAINER_ID env TERM=xterm ansible --version
docker exec --tty $CONTAINER_ID env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check
```


 [svg-travis]: https://travis-ci.org/naftulikay/docker-xenial-vm.svg?branch=develop
 [travis]: https://travis-ci.org/naftulikay/docker-xenial-vm/
 [post]: https://www.jeffgeerling.com/blog/2016/how-i-test-ansible-configuration-on-7-different-oses-docker
 [upstream]: https://hub.docker.com/r/geerlingguy/docker-ubuntu1604-ansible/
 [dwalsh]: https://stopdisablingselinux.com/
 [redhat-docker-systemd]: https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
