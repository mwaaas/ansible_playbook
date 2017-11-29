FROM gliderlabs/alpine:3.4

RUN \
  apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

ARG ansible_version=2.4.1.0

RUN echo $ansible_version \
  && curl -fsSL https://releases.ansible.com/ansible/ansible-$ansible_version.tar.gz -o ansible.tar.gz \
  && tar -xzf ansible.tar.gz -C ansible --strip-components 1 \
  && rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging


RUN apk update \
    && apk add zip jq git make bash openssh\
    && pip install boto3==1.4.7 \
    && pip install awsebcli==3.10.6 \
    && pip install j2==1.2.1 \
    && pip install j2cli==0.3.1.post0 \
    && pip install awscli==1.11.168 \
    && curl "https://raw.githubusercontent.com/SumoLogic/sumologic-aws-lambda/master/cloudwatchlogs/cloudwatchlogs_lambda.js" > /tmp/cloudwatchlogs_lambda.js\
    && zip -j /tmp/lambda_log_shipper.zip /tmp/cloudwatchlogs_lambda.js

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
