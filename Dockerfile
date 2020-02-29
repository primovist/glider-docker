FROM primovist/golang-docker
RUN apk add --no-cache git
RUN go get -u github.com/nadoo/glider
RUN pwd && ls -lah
WORKDIR /go/bin
CMD ["glider", "-config", "glider.conf"]
