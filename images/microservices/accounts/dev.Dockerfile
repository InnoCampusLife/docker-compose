FROM ubuntu:16.04


# utils

RUN apt-get update \
	&& apt-get -y install wget \
	&& apt-get -y install nano

# environment

RUN apt-get -y install python3 \
	&& apt-get -y install python3-pip

# packages

RUN pip3 install pymongo flask flask_restful

# expected build-time variables

ARG ACCOUNTS_VERSION
ARG WEB_HOST
ARG WEB_PORT
ARG DB_HOST
ARG DB_PORT

# exported environment variables

ENV ACCOUNTS_VERSION=$ACCOUNTS_VERSION
ENV WEB_HOST=$WEB_HOST
ENV DB_HOST=$DB_HOST
ENV DB_PORT=$DB_PORT

# pre-run movements

ENTRYPOINT [ -f /srv/accounts/entry.py ] && python3.5 /srv/accounts/entry.py || \
	echo "Nothing to start.\nPlease, put desired version of accounts microservice under ./data/dev/accounts directory"

EXPOSE 5000
