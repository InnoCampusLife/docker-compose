FROM nginx:1.11


RUN rm /etc/nginx/conf.d/default.conf || true
ADD fs/etc/nginx/conf.d/ /etc/nginx/conf.d


EXPOSE 8770 7433
