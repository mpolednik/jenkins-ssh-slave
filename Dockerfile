FROM jenkinsci/slave:alpine
LABEL maintainer="mail@goposky.com"

# setup SSH server
USER root
ARG JENKINS_AGENT_HOME=/home/jenkins
ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}
RUN apk --update add --no-cache openssh openssh-client python2 python2-dev py2-pip python3 python3-dev git \
  && apk add terraform=0.11.13-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && apk add ansible=2.7.9-r1 musl=1.1.22-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && rm -rf /var/cache/apk/* \
  && sed -ie 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config \
  && sed -ir 's/#PidFile \/run\/sshd.pid/PidFile \/home\/jenkins\/.ssh\/sshd.pid/' /etc/ssh/sshd_config \
  && sed -ir '/jenkins/ s/\/sbin\/halt/\/bin\/sh/' /etc/passwd \
  && chown -R jenkins:jenkins /etc/ssh \
  && env | grep _ >> /etc/environment \
  && pip install botocore boto3 \
  && pip3 install botocore boto3
USER jenkins
EXPOSE 2222
COPY setup-sshd /usr/local/bin/setup-sshd
ENTRYPOINT ["setup-sshd"]
