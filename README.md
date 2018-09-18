# Alpine based Jenkins SSH slave image
This is an alpine based Jenkins slave running sshd as user jenkins.

Usage:
```
docker run -e "JENKINS_SLAVE_SSH_PUBKEY=<public key>" goposky/jenkins-ssh-slave:alpine
```

