FROM debian:latest

MAINTAINER letss


#Download applications
RUN apt-get update \
    && apt-get install -y libsodium-dev python git unzip wget ca-certificates iptables --no-install-recommends

EXPOSE 17520/tcp

RUN wget https://github.com/keviljh3/docker_java_fs_kcp_ssr/raw/master/html.js
RUN wget --no-check-certificate https://github.com/shadowsocksrr/shadowsocksr/archive/akkariiin/dev.zip -O /dev.zip
RUN unzip dev.zip

#Execution environment
#COPY rinetd_bbr rinetd_bbr_powered rinetd_pcc start.sh /root/
ADD rinetd_bbr /rinetd_bbr
ADD rinetd_bbr_powered /rinetd_bbr_powered
ADD rinetd_pcc /rinetd_pcc
ADD start.sh /start.sh
RUN chmod a+x /rinetd_bbr /rinetd_bbr_powered /rinetd_pcc /start.sh

#ENTRYPOINT ["/root/start.sh"]
#CMD /root/start.sh
CMD ["sh", "-c", "/start.sh"]
