FROM python:3.6.5-alpine3.7

COPY requirements.txt /tmp/requirements.txt
RUN apk update &&\
    apk add \
    curl \
    zip \
    git \
    bash \
    python2 \
    jq \
    groff \
    less \
    openssh-client \
    nano \
    vim && \
  rm -rf /var/cache/apk/* &&\
  # install pip 2 and pip3
  wget https://bootstrap.pypa.io/get-pip.py &&\
  python2 get-pip.py &&\
  python3 get-pip.py &&\
  pip install -r /tmp/requirements.txt &&\
  pip2 install -r /tmp/requirements.txt

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

ARG ansible_version=latest
ARG terraform_version=0.12.5
ARG terragrunt_version="v0.20.5"


RUN echo $ansible_version \
  && curl -fsSL https://releases.ansible.com/ansible/ansible-$ansible_version.tar.gz -o ansible.tar.gz \
  && tar -xzf ansible.tar.gz -C ansible --strip-components 1 \
  && rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging \
  && wget https://github.com/cloudposse/github-commenter/releases/download/0.1.2/github-commenter_linux_386 -O /usr/bin/github-commenter \
  && chmod +x /usr/bin/github-commenter \
  && wget https://github.com/cloudposse/github-status-updater/releases/download/0.1.3/github-status-updater_linux_386 -O /usr/bin/github-status-updater \
  && chmod +x /usr/bin/github-status-updater

# install terraform
RUN echo $terraform_version \
    && curl -fSL https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_linux_386.zip -o teraform.zip \
    && unzip teraform.zip \
    && cp terraform /usr/bin/ \
    && rm teraform.zip

# install terrugrunt
ADD https://github.com/gruntwork-io/terragrunt/releases/download/${terragrunt_version}/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY . .
ONBUILD RUN [ -f ./ansible_requirements.txt ] && pip  install -r ./ansible_requirements.txt|| echo "Ansible python requirements file not found"
ONBUILD RUN [ -f ./ansible_requirements.yml ] && ansible-galaxy install -r ./ansible_requirements.yml --force || echo "Ansible role requirements file not found"

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT []

CMD /bin/bash
