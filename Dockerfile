FROM golang:alpine as builder

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOARCH amd64
WORKDIR /go/src/github.com/nadoo/
RUN apk add --update --no-cache git build-base tzdata zip ca-certificates
RUN git clone --depth=1 https://github.com/nadoo/glider.git /go/src/github.com/nadoo/glider
RUN cd /go/src/github.com/nadoo/glider \
    && go build -v -ldflags="-s -w"

FROM alpine
LABEL maintainer="primovist" \
        org.label-schema.name="glider-docker"

ENV TZ Asia/Shanghai
WORKDIR /etc/glider/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/github.com/nadoo/glider/config/glider.conf.example /etc/glider/glider.conf
COPY --from=builder /go/src/github.com/nadoo/glider/glider /glider

CMD ["/glider", "-config", "/etc/glider/glider.conf"]