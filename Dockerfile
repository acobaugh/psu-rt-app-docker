FROM cobaugh/rt-docker:v4.4.2-3

COPY RT_SiteConfig.pm /opt/rt/etc/
COPY LoadBalancer.html /opt/rt/share/html/NoAuth/
