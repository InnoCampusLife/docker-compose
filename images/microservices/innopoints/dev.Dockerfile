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

ENTRYPOINT [ -f /srv/innopoints/main_v2.rb ] && bundle install --gemfile=/srv/innopoints/Gemfile \
	&& mysql -u root -h mysql -e "source /srv/innopoints/database_creation.sql; source /srv/innopoints/database_seed.sql;" \
	# && ruby /srv/innopoints/feel_the_base.rb \
	&& ruby /srv/innopoints/main_v2.rb \
	|| echo "Nothing to start.\nPlease, put desired version of innopoints microservice under ./data/dev/innopoints directory"

EXPOSE 4567
