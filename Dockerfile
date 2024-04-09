FROM jlesage/baseimage-gui:alpine-3.19-v4

RUN \
    add-pkg \
        java-common \
        openjdk21-jre tzdata curl unzip bash \
        ca-certificates

ARG JMETER_VERSION="5.6.3"
ENV MIRROR_HOST https://archive.apache.org/dist/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN update-ca-certificates \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo "Europe/Berlin" >  /etc/timezone \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /tmp/dependencies  \
    && curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p /opt  \
    && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
    && rm -rf /tmp/dependencies \
    && rm -rf /opt/apache-jmeter-${JMETER_VERSION}/docs/ \
    && rm -rf /opt/apache-jmeter-${JMETER_VERSION}/printable_docs/ \
    && rm -rf /opt/apache-jmeter-${JMETER_VERSION}/licenses/ \
    && mkdir -p /opt/userclasspath

RUN add-pkg fontconfig ttf-dejavu
RUN add-pkg gtk+3.0

# Copy the start script.
COPY startapp.sh /startapp.sh

# Set the name of the application.
RUN set-cont-env APP_NAME "JMeter"
