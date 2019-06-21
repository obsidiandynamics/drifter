FROM openjdk:12.0-jdk-oraclelinux7

ADD vagrant-ssh-key.pub /root/.ssh/authorized_keys
COPY *_key* /etc/ssh/
RUN set -x; \
    chmod 600 /etc/ssh/ssh_host_rsa_key; \
    chmod 600 /etc/ssh/ssh_host_ecdsa_key; \
    chmod 600 /etc/ssh/ssh_host_ed25519_key; \
    echo root:root | chpasswd; \
    yum-config-manager --enable ol7_addons; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce git openssh-server which iputils telnet docker-compose vim net-tools
RUN echo "UseDNS no" >> /etc/ssh/sshd_config; \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config; \
    echo "KerberosAuthentication no" >> /etc/ssh/sshd_config; \
    echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config; \
    echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config; \
    echo "RhostsRSAAuthentication no" >> /etc/ssh/sshd_config; \
    echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config
COPY launcher.sh .
RUN chmod +x launcher.sh

CMD ["./launcher.sh"]