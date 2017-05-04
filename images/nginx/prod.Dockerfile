FROM nginx:1.11


ARG FRONTEND_VERSION
ENV FRONTEND_VERSION=$FRONTEND_VERSION


RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf || true
ADD fs/etc/nginx/conf.d/ /etc/nginx/conf.d
ADD fs/etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN apt-get update \
    && apt-get -y install wget

RUN wget https://github.com/InnoDevelopment/frontend/archive/$FRONTEND_VERSION.tar.gz \
	&& mkdir -p /srv/frontend \
	&& tar -xvzf $frontend_VERSION.tar.gz -C /srv/frontend --strip-components=1 \
	&& rm /$FRONTEND_VERSION.tar.gz

EXPOSE 8770 7433
