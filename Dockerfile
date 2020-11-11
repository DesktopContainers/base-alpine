FROM alpine
# alpine:3.12

ENV PATH="/container/scripts:${PATH}"

RUN apk add --no-cache runit \
                       \
                       xvfb \
                       x11vnc \
                       openbox \
                       ttf-dejavu \
                       \
                       haproxy \
                       openssl \
                       openssh-server \
                       sudo \
                       \
                       python3 \
                       py3-numpy \
                       sed \
 \
 && ln -s /usr/bin/python3 /usr/bin/python \
 \
 && adduser -D app \
 && passwd -d app \
 \
 && wget -O novnc.tar.gz https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz \
 && tar xvf novnc.tar.gz \
 && ln -s noVNC-* novnc \
 \
 && ln -s /novnc/vnc_lite.html /novnc/index.html \
 \
 && wget -O websockify.tar.gz https://github.com/novnc/websockify/archive/v0.9.0.tar.gz \
 && tar xvf websockify.tar.gz \
 && ln -s websockify-* websockify \
 \
 && chown app -R /websockify* \
 && chown app -R /no*

VOLUME ["/certs"]

EXPOSE 22 80 443 5900

COPY . /container/

HEALTHCHECK CMD ["docker-healthcheck.sh"]
ENTRYPOINT ["entrypoint.sh"]

CMD [ "runsvdir","-P", "/container/config/runit" ]
