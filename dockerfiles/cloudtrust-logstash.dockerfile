FROM cloudtrust-baseimage:f27

ARG logstash_service_git_tag

###
###  Prepare the system stuff
###

RUN echo -e "\
[elasticsearch-6.x]\n\
name=Elasticsearch repository for 6.x packages\n\
baseurl=https://artifacts.elastic.co/packages/6.x/yum\n\
gpgcheck=1\n\
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\n\
enabled=1\n\
autorefresh=1\n\
type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo

RUN dnf install -y java java-1.8.0-openjdk.x86_64 logstash && \
    dnf clean all

WORKDIR /cloudtrust
RUN git clone git@github.com:cloudtrust/logstash-service.git

WORKDIR /cloudtrust/logstash-service
RUN git checkout ${logstash_service_git_tag} && \
    install -v -m644 -o root -g root deploy/etc/security/limits.d/* /etc/security/limits.d/ && \
    install -v -m644 -o root -g root deploy/etc/monit.d/* /etc/monit.d/ && \
    install -v -d -m755 -o root -g root /etc/systemd/system/logstash.service.d/ && \ 
    install -v -m644 -o root -g root deploy/etc/systemd/system/logstash.service /etc/systemd/system/logstash.service && \
    install -v -m644 -o root -g root deploy/etc/systemd/system/logstash.service.d/* /etc/systemd/system/logstash.service.d/

##
##  Enable services
##

RUN systemctl enable logstash.service && \
    systemctl enable monit.service
  
