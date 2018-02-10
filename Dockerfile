FROM quay.io/acobaugh/rt:v4.4.2-5

COPY RT_SiteConfig.pm /opt/rt/etc/
COPY LoadBalancer.html /opt/rt/share/html/NoAuth/
