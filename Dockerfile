FROM alpine:3.19 as jmeter

ARG JMETER_VERSION="5.6.3"
ENV MIRROR_HOST https://archive.apache.org/dist/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN    apk update \
    && apk upgrade \
    && apk add ca-certificates \
    && update-ca-certificates \
    && apk add --update tzdata curl unzip bash \
    && mkdir -p /tmp/dependencies  \
    && curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p /opt/jmeter  \
    && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz --strip-components 1 -C /opt/jmeter  \
    && rm -rf /opt/jmeter/docs/ \
    && rm -rf /opt/jmeter/printable_docs/ \
    && rm -rf /opt/jmeter/licenses/

RUN curl -L https://jmeter.apache.org/images/favicon.png > /icon.png

# ------------------------------------------------------------------------------

FROM jlesage/baseimage-gui:alpine-3.19-v4

RUN add-pkg \
        java-common \
        openjdk21-jre \
        ttf-dejavu

RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo "Europe/Berlin" >  /etc/timezone

COPY --from=jmeter /opt/jmeter /opt/jmeter

# Set the name of the application.
RUN set-cont-env APP_NAME "JMeter"

# Generate and install favicons.
RUN APP_ICON_URL=https://jmeter.apache.org/images/favicon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Define mountable directories.
VOLUME ["/output"]

# Copy the start script.
COPY startapp.sh /startapp.sh
