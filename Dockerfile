FROM amazonlinux:2
LABEL maintainer "Yuya Ito <i.yuuya@gmail.com>"

RUN yum install -y openssh-server \
 && rm -rf /car/cache/yum/* \
 && yum clean all

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
 && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa \
 && ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

RUN sed -ri 's/^PermitRootLogin forced-commands-only/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
 && echo "root:" | chpasswd

EXPOSE 22

RUN ( \
      echo '#!/bin/sh' \
   && echo 'system start sshd' \
    ) >> /root/docker-entrypoint.sh \
 && chmod 755 /root/docker-entrypoint.sh

RUN mkdir /data

CMD docker-entrypoint.sh
