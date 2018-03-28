FROM cloudtrust-baseimage:f27

ARG logstash_service_git_tag
ARG config_git_tag
ARG config_repo

###
###  Prepare the system stuff
###

RUN echo -e "[logstash-6.x]\nname=Elastic repository for 6.x packages\nbaseurl=https://artifacts.elastic.co/packages/6.x/yum\ngpgcheck=1\ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\nenabled=1\nautorefresh=1\ntype=rpm-md" >> /etc/yum.repos.d/logstash.repo && \
    dnf install -y java java-1.8.0-openjdk.x86_64 logstash && \
    dnf clean all

##
##  Enable services
##

RUN systemctl enable logstash.service && \
    systemctl enable monit.service
  