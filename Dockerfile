FROM cobaugh/rt-docker:4.4.2-2

COPY RT_SiteConfig.pm /opt/rt/etc/
COPY LoadBalancer.html /opt/rt/share/html/NoAuth/
