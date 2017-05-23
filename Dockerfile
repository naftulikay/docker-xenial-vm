FROM ubuntu:16.04
MAINTAINER Naftuli Kay <me@naftuli.wtf>
# with credits upstream: https://hub.docker.com/r/geerlingguy/docker-centos7-ansible/

# install dependencies.
RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends \
       python-software-properties \
       software-properties-common \
       rsyslog systemd systemd-cron sudo >/dev/null \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean >/dev/null

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
