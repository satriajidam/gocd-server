FROM alpine:3.8

LABEL \
  gocd.version="18.8.0" \
  description="A modified version of GoCD server with dynamic go user based on alpine linux" \
  maintainer="Agastyo Satriaji Idam <play.satriajidam@gmail.com>" \
  gocd.full.version="18.8.0-7433" \
  gocd.git.sha="4bf750d09bf4dba76a2b7ce0d72e88ecdfdbd96a"

# the ports that go server runs on
EXPOSE 8153 8154

# force encoding
ENV LANG=en_US.utf8

RUN \
  # install dependencies and other helpful CLI tools
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk add --no-cache openjdk8-jre-base git mercurial subversion tini openssh-client bash su-exec curl && \
  # download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/18.8.0-7433/generic/go-server-18.8.0-7433.zip" > /tmp/go-server.zip && \
  # unzip the zip file into /go-server, after stripping the first path prefix
  unzip /tmp/go-server.zip -d / && \
  rm /tmp/go-server.zip && \
  mv go-server-18.8.0 /go-server && \
  mkdir -p /docker-entrypoint.d

COPY logback-include.xml /go-server/config/logback-include.xml
COPY install-gocd-plugins /usr/local/sbin/install-gocd-plugins
COPY git-clone-config /usr/local/sbin/git-clone-config
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
