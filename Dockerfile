FROM golang:1.9.2-alpine

RUN apk add --no-cache --update alpine-sdk

COPY . /go/src/github.com/conde-nast-international/k8s-auth
RUN cd /go/src/github.com/conde-nast-international/k8s-auth && make release-binary

FROM alpine:3.4
RUN apk add --update ca-certificates openssl

WORKDIR /go/src/github.com/conde-nast-international/k8s-auth
COPY --from=0 /go/src/github.com/conde-nast-international/k8s-auth/bin/k8s-auth /usr/local/bin/k8s-auth
WORKDIR /

ENTRYPOINT ["k8s-auth"]