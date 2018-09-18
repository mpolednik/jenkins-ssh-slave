FROM jenkinsci/slave:alpine
LABEL maintainer="mail@goposky.com"

# setup SSH server
USER root
ARG JENKINS_AGENT_HOME=/home/jenkins
ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}
RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && rm -rf /var/cache/apk/* \
  && sed -ie 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config \
  && sed -ir 's/#PidFile \/run\/sshd.pid/PidFile \/home\/jenkins\/.ssh\/sshd.pid/' /etc/ssh/sshd_config \
  && sed -ir '/jenkins/ s/\/sbin\/halt/\/bin\/sh/' /etc/passwd \
  && chown -R jenkins:jenkins /etc/ssh \
  && env | grep _ >> /etc/environment
USER jenkins
EXPOSE 2222
COPY setup-sshd /usr/local/bin/setup-sshd
ENTRYPOINT ["setup-sshd"]

