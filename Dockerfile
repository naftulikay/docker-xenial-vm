FROM ubuntu:16.04
MAINTAINER Naftuli Kay <me@naftuli.wtf>
# with credits upstream: https://hub.docker.com/r/geerlingguy/docker-ubuntu1604-ansible/

ENV TERM=xterm LANG=en_US.UTF-8

# install a basic system
RUN apt-get update >/dev/null \
    # install and configure minimum locales
    && apt-get install -y language-pack-en >/dev/null \
    # install systemd, dbus, and just about everything required to "boot" a system
    && apt-get install -y --no-install-recommends \
       python-software-properties software-properties-common apt-utils \
       rsyslog dbus systemd systemd-cron sudo less >/dev/null \
    # remove the getty, not gonna work
    && rm -f /etc/systemd/system/getty.target.wants/getty\@tty1.service \
    # remove cpu scaling frequency changer
    && update-rc.d ondemand remove && rm -f /etc/init.d/ondemand  \
    # clean apt cache to make this step cleaner
    && rm -Rf /var/lib/apt/lists/* \
    && apt-get clean

# configure rsyslog
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# install the latest stable ansible
RUN add-apt-repository -y ppa:ansible/ansible >/dev/null \
  && apt-get update >/dev/null \
  && apt-get install -y --no-install-recommends ansible > /dev/null \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# configure ansible
RUN printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts \
  && printf "[defaults]\nretry_files_enabled=false" > /etc/ansible/ansible.cfg

# fake out the init system so it'll work
COPY bin/fake-initctl /
RUN chmod +x /fake-initctl \
  && rm -fr /sbin/initctl \
  && ln -s /fake-initctl /sbin/initctl

# our own utility for awaiting systemd "boot" in the container
COPY bin/systemd-await-target /usr/bin/systemd-await-target
COPY bin/wait-for-boot /usr/bin/wait-for-boot

# fix broken case where selinux enforcing on host breaks guest boot; create start links arbitrarily
COPY units/selinux-remount-fs.service /etc/systemd/system/
RUN mkdir -p /etc/systemd/system/basic.target.wants \
  && chmod 0644 /etc/systemd/system/selinux-remount-fs.service \
  && ln -s /etc/systemd/system/selinux-remount-fs.service \
    /etc/systemd/system/basic.target.wants/selinux-remount-fs.service

ENTRYPOINT ["/lib/systemd/systemd"]
