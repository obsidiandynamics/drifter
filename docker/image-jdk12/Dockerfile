FROM openjdk:12.0-jdk-oraclelinux7

RUN set -x; \
    chmod +x run-sshd.sh; \
    echo root:root | chpasswd; \
    yum-config-manager --enable ol7_addons; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo; \
    yum install -y docker-ce git openssh-server which iputils telnet docker-compose vim net-tools
ADD vagrant-ssh-key.pub /root/.ssh/authorized_keys
COPY *_key* /etc/ssh/
COPY launcher.sh .

CMD ["./launcher.sh"]