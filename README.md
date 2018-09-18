# Alpine based Jenkins SSH slave image
This is an alpine based Jenkins slave running sshd as user jenkins.
Includes Git and Java 1.8.
SSH with public-private key based authentication.
SSH port 2222 (instead of the default 22).
Usage:
```
docker run -e "JENKINS_SLAVE_SSH_PUBKEY=<public key>" goposky/jenkins-ssh-slave:alpine
```
In Jenkins add node with private key and configure port 2222.

