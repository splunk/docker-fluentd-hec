FROM fluent/fluentd:v1.2.0-debian

LABEL maintainer="Gimi Liang <zliang@splunk.com>"

# expecting fluent-plugin-splunk-hec
COPY *.gem /tmp/

RUN apt-get update \
 && apt-get install -y jq \
 && buildDeps=" \
      make gcc g++ libc-dev autoconf automake libtool libltdl-dev\
      ruby-dev \
      wget bzip2 gnupg dirmngr \
    " \
 && apt-get install -y --no-install-recommends $buildDeps \
 && update-ca-certificates \
 && gem install fluent-plugin-systemd -v 0.3.1 \
 && gem install fluent-plugin-detect-exceptions -v 0.0.11 \
 && gem install fluent-plugin-concat -v 2.2.2 \
 && gem install fluent-plugin-prometheus -v 1.0.1 \
 && gem install fluent-plugin-jq -v 0.5.1 \
 && gem install oj -v 3.5.1 \
 && gem install /tmp/*.gem \
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
