
Apache JMeter installed inside [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) (Docker Image with streamed Desktop via VNC inside HTML5 Website).

# Run

    docker run -d --name jmeter-gui \
        -p 5800:5800 \
        -p 5900:5900 \
        -e VNC_PASSWORD=hugo1234 \
        -v /your/persistent/storage:/config \
        dersimn/jmeter-gui

Place `.jmx` files inside `/config/jmeter`. See [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) for more parameters to configure this image.

# Build

    docker buildx create --name mybuilder
    docker buildx use mybuilder

    docker buildx build \
        --platform linux/amd64,linux/arm64 \
        -t dersimn/jmetter-gui \
        --push \
        .
