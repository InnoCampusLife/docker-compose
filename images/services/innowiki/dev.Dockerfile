FROM dperson/moinmoin

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      python-ldap \
      && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./moinmoin-memodump/memodump.py /usr/local/share/moin/data/plugin/theme
COPY ./moinmoin-memodump/memodump    /usr/local/lib/python2.7/dist-packages/MoinMoin/web/static/htdocs/memodump

COPY ./wikiconfig.py /usr/local/share/moin/wikiconfig.py
COPY ./img/logo.png /usr/local/lib/python2.7/dist-packages/MoinMoin/web/static/htdocs/common/
ADD fs/usr/bin /usr/bin

RUN chmod +x /usr/bin/*.sh

ENTRYPOINT ["entrypoint.sh"]

VOLUME ["/usr/local/share/moin/data"]
