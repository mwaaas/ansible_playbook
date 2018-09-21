FROM python:3.6.5-alpine3.7

COPY requirements.txt /tmp/requirements.txt
RUN apk update &&\
    apk add \
    curl \
    zip \
    bash \
    python2 \
    openssh-client  && \
  rm -rf /var/cache/apk/* &&\
  pip install -r /tmp/requirements.txt

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

ARG ansible_version=2.4.1.0

RUN echo $ansible_version \
  && curl -fsSL https://releases.ansible.com/ansible/ansible-$ansible_version.tar.gz -o ansible.tar.gz \
  && tar -xzf ansible.tar.gz -C ansible --strip-components 1 \
  && rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging \
  && wget https://github.com/cloudposse/github-commenter/releases/download/0.1.2/github-commenter_linux_386 -O /usr/bin/github-commenter \
  && chmod +x /usr/bin/github-commenter



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
