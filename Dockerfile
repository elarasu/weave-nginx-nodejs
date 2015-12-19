# nginx-nodejs image 
#   docker build -t elarasu/weave-nginx-nodejs .
#
FROM elarasu/weave-supervisord
MAINTAINER elarasu@outlook.com

# Install requirements
RUN  apt-get update  \
  && apt-get upgrade -y \
  && apt-get install -yq ssh nodejs sudo cron git ca-certificates nodejs-legacy npm \
       build-essential g++ nginx \
       --no-install-recommends \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Expose Nginx on port 80 and 443
EXPOSE 80
EXPOSE 443

# Add service config files
ADD conf/nginx.conf /etc/nginx/

# Add Supervisord config files
ADD conf/cron.sv.conf /etc/supervisor/conf.d/
ADD conf/nginx.sv.conf /etc/supervisor/conf.d/

CMD supervisord

