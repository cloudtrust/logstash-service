# logstash-service

ARG logstash_service_git_tag
ARG config_git_tag
ARG config_repo

docker build --build-arg logstash_service_git_tag=initial --build-arg config_git_tag=master --build-arg config_repo=https://github.com/cloudtrust/dev-config.git -t cloudtrust-logstash -f cloudtrust-logstash.dockerfile .