FROM ubuntu:16.04

RUN apt update && \
  apt -y install curl python-pip python-dev python3-dev git libxml2-dev \
  libxslt1-dev python-openssl python3-openssl python-pyasn1 libffi-dev \
  libssl-dev build-essential unzip && \
  pip install -UI pbr setuptools pytz && \
  pip install -UI git+https://github.com/openstack/python-openstackclient

ENV TERRAFORM_VERSION=0.11.8
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN pip install ansible

ENV NOMAD_VERSION=0.8.4
RUN curl https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip > nomad_${NOMAD_VERSION}_linux_amd64.zip && \
    unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /bin && \
    rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip

ENV CONSUL_VERSION=0.9.3
RUN curl https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /bin && \
    rm -f consul_${CONSUL_VERSION}_linux_amd64.zip
