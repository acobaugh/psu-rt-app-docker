FROM quay.io/acobaugh/rt-docker:v4.4.2-4

COPY RT_SiteConfig.pm /opt/rt/etc/
COPY LoadBalancer.html /opt/rt/share/html/NoAuth/
