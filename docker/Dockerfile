FROM oraclelinux:latest

ADD vagrant-ssh-key.pub /root/.ssh/authorized_keys
COPY *_key* /etc/ssh/
COPY run-sshd.sh .
RUN set -x; \
    chmod +x run-sshd.sh; \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
    echo root:root | chpasswd

CMD ["./run-sshd.sh"]