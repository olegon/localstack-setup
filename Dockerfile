FROM mesosphere/aws-cli

COPY ./opt/wait-healthcheck.sh /opt/wait-healthcheck.sh

RUN apk update \
    && apk add curl jq \
    && chmod +x /opt/wait-healthcheck.sh

ENTRYPOINT [ "/opt/wait-healthcheck.sh" ]
