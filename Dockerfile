FROM ruby:2.5.1-slim

LABEL maintainer="Gimi Liang <zliang@splunk.com>"

# skip runtime bundler installation
ENV FLUENTD_DISABLE_BUNDLER_INJECTION 1

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends dumb-init libjemalloc1 jq \
 && buildDeps="make gcc wget g++" \
 && apt-get install -y --no-install-recommends $buildDeps \
 && gem install -N \
        fluentd:1.2.3 \
        fluent-plugin-systemd:0.3.1 \
        fluent-plugin-concat:2.2.2 \
        fluent-plugin-prometheus:1.0.1 \
        fluent-plugin-jq:0.5.1 \
        fluent-plugin-splunk-hec:1.0.1 \
        oj:3.5.1 \
 && chmod +x /usr/bin/dumb-init \
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* $GEM_HOME/cache/*.gem \
 && mkdir -p /fluentd/etc

 # See https://packages.debian.org/stretch/amd64/libjemalloc1/filelist
ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
COPY entrypoint.sh /fluentd/entrypoint.sh

ENTRYPOINT ["/fluentd/entrypoint.sh"]
CMD ["-h"]
