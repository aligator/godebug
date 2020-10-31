FROM golang:1.15.3-alpine3.12
ENV CGO_ENABLED 0

RUN apk update && apk add bash inotify-tools git

RUN mkdir /build/
WORKDIR /build/

# installing Delve debugger
RUN go get github.com/derekparker/delve/cmd/dlv

COPY startScript.sh /usr/bin/startScript.sh
RUN chmod +x /usr/bin/startScript.sh

EXPOSE 40000

ENTRYPOINT ["startScript.sh"]