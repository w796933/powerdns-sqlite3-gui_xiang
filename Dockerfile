FROM debian:jessie
#MAINTAINER David Noyes <david@raspberrypython.com>
MAINTAINER ペール <txgfx504@yahoo.co.jp>

ENV DEBIAN_FRONTEND noninteractive
ENV WEBPASSWD changeme
ENV RECURSOR 8.8.8.8

RUN apt-get update && \
    apt-get install -yq pdns-server pdns-backend-sqlite3 git python python-dev python-pip libsasl2-dev libldap2-dev libssl-dev && \
    apt-get clean && \
    apt-get -yq autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/powerdns-admin && \
        git clone --depth 1 https://github.com/ngoduykhanh/PowerDNS-Admin.git /var/lib/powerdns-admin && \
        cd /var/lib/powerdns-admin && \
        pip install virtualenv && \
        virtualenv flask && \
        . ./flask/bin/activate && \
        pip install -r requirements.txt

RUN rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf

COPY ./start.sh /opt/start.sh
COPY ./config.py /var/lib/powerdns-admin/config.py

VOLUME ["/data"]

EXPOSE 53/udp 53/tcp 80 8080

ENTRYPOINT ["/opt/start.sh"]

