FROM nginx:1.11


RUN rm /etc/nginx/conf.d/default.conf || true
RUN rm /etc/nginx/nginx.conf || true
ADD fs/etc/nginx/conf.d/ /etc/nginx/conf.d
ADD fs/etc/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8770 7433
