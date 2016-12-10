FROM ubuntu:16.04


# utils

RUN apt-get update \
	&& apt-get -y install wget \
	&& apt-get -y install nano

# environment

RUN apt-get install -y ruby2.3 ruby2.3-dev 
RUN apt-get install -y libgmp-dev build-essential
RUN apt-get install -y libmysqlclient-dev
RUN apt-get install -y mysql-client

# packages

RUN gem install bundler

# expected build-time variables

ARG INNOPOINTS_VERSION
ARG WEB_HOST
ARG WEB_PORT
ARG DB_HOST
ARG DB_PORT
ARG ACCOUNTS_HOST
ARG ACCOUNTS_PORT
ARG ACCOUNTS_VERSION

# exported environment variables

ENV INNOPOINTS_VERSION=$INNOPOINTS_VERSION
ENV WEB_HOST=$WEB_HOST
ENV WEB_PORT=$WEB_PORT
ENV DB_HOST=$DB_HOST
ENV DB_PORT=$DB_PORT
ENV MYSQL_DB_HOST=$DB_HOST
ENV MYSQL_DB_PORT=$DB_PORT
ENV ACCOUNTS_HOST=$ACCOUNTS_HOST
ENV ACCOUNTS_PORT=$ACCOUNTS_PORT
ENV ACCOUNTS_VERSION=$ACCOUNTS_VERSION

# pre-run movements

RUN wget https://github.com/InnoDevelopment/Innopoints/archive/$INNOPOINTS_VERSION.tar.gz \
	&& mkdir -p /srv/innopoints \
	&& tar -xvzf $INNOPOINTS_VERSION.tar.gz -C /srv/innopoints --strip-components=1 \
	&& rm /$INNOPOINTS_VERSION.tar.gz
RUN bundle install --gemfile=/srv/innopoints/Gemfile

ENTRYPOINT ruby /srv/innopoints/main_v2.rb

EXPOSE 4567

