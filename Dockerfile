FROM golang:1-alpine as builder
WORKDIR $GOPATH/src/github.com/loadimpact/k6
ADD . .
RUN apk --no-cache add --virtual .build-deps git make build-base && \
  go get . && CGO_ENABLED=0 go install -a -ldflags '-s -w'

FROM alpine:3.7
RUN apk add --no-cache ca-certificates

RUN adduser -D -u 1001 -G root jenkins
RUN echo "jenkins ALL= NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /opt
RUN mkdir -p k6
RUN chmod -R +r /opt/k6

USER jenkins
WORKDIR /opt/k6

COPY --from=builder /go/bin/k6 /usr/bin/k6
# ENTRYPOINT ["k6"]
