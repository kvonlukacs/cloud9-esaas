FROM tghastings/alpine-rails:latest

RUN apk --update add build-base g++ make curl wget apache2-utils git libxml2-dev sshfs nodejs-npm bash tmux supervisor \
 && rm -f /var/cache/apk/* \
 && git clone https://github.com/c9/core.git /cloud9 \
 && cd cloud9 \
 && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
 && /cloud9/scripts/install-sdk.sh \
 && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js \
 && mkdir /root/environment \
 && mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/

VOLUME /root/environment

EXPOSE 80 3000

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
