FROM boomi/atom:3.2.0

RUN yum -y install python3-pip && \
    pip3 install awscli

RUN wget -q -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x ./jq && \
    cp jq /usr/bin

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 9090 45588 7800

ENTRYPOINT ["./entrypoint.sh"]

CMD ["/sbin/init"]