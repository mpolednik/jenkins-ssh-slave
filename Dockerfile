FROM jenkinsci/slave:alpine
LABEL maintainer="mail@goposky.com"

# setup SSH server
USER root
ARG JENKINS_AGENT_HOME=/home/jenkins
ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}
COPY hashi_vault.patch /home/jenkins
RUN apk --update add --no-cache openssh openssh-client python2 python2-dev py2-pip python3 python3-dev git \
  && apk add ansible=2.7.13-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
  && apk add vault --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && apk add make jq wget unzip patch \
  && wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 && chmod +x /usr/local/bin/yq \
  && chown -R jenkins:jenkins /usr/sbin/vault \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && rm -rf /var/cache/apk/* \
  && sed -ie 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config \
  && sed -ir 's/#PidFile \/run\/sshd.pid/PidFile \/home\/jenkins\/.ssh\/sshd.pid/' /etc/ssh/sshd_config \
  && sed -ir '/jenkins/ s/\/sbin\/halt/\/bin\/sh/' /etc/passwd \
  && chown -R jenkins:jenkins /etc/ssh \
  && env | grep _ >> /etc/environment \
  && pip install botocore boto3 hvac \
  && pip3 install botocore boto3 hvac \
  && wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip \
  && unzip terraform_0.11.14_linux_amd64.zip \
  && mv terraform /usr/local/bin/terraform
RUN patch /usr/lib/python3.6/site-packages/ansible/plugins/lookup/hashi_vault.py /home/jenkins/hashi_vault.patch
ENV PATH="/usr/local/bin:$PATH"
USER jenkins
EXPOSE 2222
COPY setup-sshd /usr/local/bin/setup-sshd
ENTRYPOINT ["setup-sshd"]
