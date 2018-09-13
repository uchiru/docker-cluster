FROM ubuntu:16.04

RUN apt update && \
  apt -y install curl python-pip python-dev python3-dev git libxml2-dev libxslt1-dev python-openssl python3-openssl python-pyasn1 libffi-dev libssl-dev build-essential && \
  pip install -UI pbr setuptools pytz && \
  pip install -UI git+https://github.com/openstack/python-openstackclient
