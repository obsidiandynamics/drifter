FROM openjdk:12.0-jdk-oraclelinux7

ADD vagrant-ssh-key.pub /root/.ssh/authorized_keys
COPY *_key* /etc/ssh/
COPY run-sshd.sh .
RUN set -x; \
    chmod +x run-sshd.sh; \
    echo root:root | chpasswd; \
    yum install -y git openssh-server which

CMD ["./run-sshd.sh"]