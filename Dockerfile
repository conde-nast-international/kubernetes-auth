FROM golang:1.9.2-alpine

RUN apk add --no-cache --update alpine-sdk

COPY . /go/src/github.com/conde-nast-international/k8s-auth
RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 && chmod +x /usr/local/bin/dep
WORKDIR /go/src/github.com/conde-nast-international/k8s-auth
RUN dep ensure -vendor-only
RUN make release-binary

FROM alpine:3.4
RUN apk add --update ca-certificates openssl

WORKDIR /go/src/github.com/conde-nast-international/k8s-auth
COPY --from=0 /go/src/github.com/conde-nast-international/k8s-auth/bin/k8s-auth /usr/local/bin/k8s-auth
WORKDIR /

ENTRYPOINT ["k8s-auth"]
