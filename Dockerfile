FROM ubuntu:16.04
MAINTAINER Naftuli Kay <me@naftuli.wtf>
# with credits upstream: https://hub.docker.com/r/geerlingguy/docker-centos7-ansible/

# install and configure systemd;
# > [b]ut systemd starts tons of services in the container like udev, getty logins, ... I only want to run systemd,
# > journald, [...] within the container
# - Dan Walsh: https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends \
       python-software-properties \
       software-properties-common \
       rsyslog systemd systemd-cron sudo >/dev/null \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && ( cd /lib/systemd/system/sysinit.target.wants/; for i in *; do \
      [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; \
    done ); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    apt-get clean >/dev/null

# prevent kernel log from being loaded into rsyslog
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# install ansible
RUN add-apt-repository -y ppa:ansible/ansible >/dev/null \
  && apt-get update >/dev/null \
  && apt-get install -y --no-install-recommends ansible >/dev/null \
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man  \
  && apt-get clean >/dev/null

# install a fake initctl script
COPY initctl_faker .
RUN chmod +x initctl_faker \
  && rm -fr /sbin/initctl \
  && ln -s /initctl_faker /sbin/initctl

# install local inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENTRYPOINT ["/lib/systemd/systemd"]
