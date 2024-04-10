#!/bin/sh

mkdir -p /config/jmeter
cd /config/jmeter

export JVM_ARGS="$JVM_ARGS -Djava.util.prefs.userRoot=/config/jmeter"

exec /opt/jmeter/bin/jmeter
