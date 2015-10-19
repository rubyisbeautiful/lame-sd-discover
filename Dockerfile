FROM rubyisbeautiful/centos6-ruby-2.2.3:latest

MAINTAINER <Tripcase Ops> ops_support@tripcase.com

RUN yum install -y haproxy wget

ENV CONSUL_AGENT 127.0.0.1
ENV CONSUL_PORT 8500
ENV SERVICE_PORT 80
ENV SERVICE_NAME web
ENV PATH /bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

EXPOSE ${SERVICE_PORT}

RUN wget https://github.com/hashicorp/consul-template/releases/download/v0.11.0/consul_template_0.11.0_linux_amd64.zip && \
    unzip consul_template_0.11.0_linux_amd64.zip && \
    mv -f consul-template /usr/local/bin/consul-template && \
    rm -f consul_template_0.11.0_linux_amd64.zip

COPY ./haproxy.cfg.ctmpl /tmp/haproxy.cfg.ctmpl

CMD consul-template \
    -consul ${CONSUL_AGENT}:${CONSUL_PORT} \
    -template "/tmp/haproxy.cfg.ctmpl:/etc/haproxy/haproxy.cfg:service haproxy restart"
