#
# Fork from cloudbees/jenkins-ci.org-docker.
# OpenJDK changed to Oracle JRE.
# To be used with slaves.
#
FROM re6exp/debian-jessie-oracle-jre-8

RUN apt-get update && apt-get install -y wget git curl zip && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_UID 1000
ENV JENKINS_GID 89
ENV JENKINS_UC https://updates.jenkins-ci.org
ENV JENKINS_VERSION 1.605
ENV JENKINS_DWNLD_URL http://mirrors.jenkins-ci.org/war/$JENKINS_VERSION/jenkins.war

RUN groupadd -g "$JENKINS_GID" -r redmine
RUN useradd -d "$JENKINS_HOME" -u "$JENKINS_UID" -g "$JENKINS_GID" -m -s /bin/bash jenkins
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY assets/init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-angent-port.groovy
COPY assets/jenkins.sh /usr/local/bin/jenkins.sh
COPY assets/plugins.sh /usr/local/bin/plugins.sh

RUN curl -L $JENKINS_DWNLD_URL -o /usr/share/jenkins/jenkins.war

EXPOSE 8080
EXPOSE 50000

RUN chown -R ${JENKINS_UID}:"$JENKINS_GID" "$JENKINS_HOME" /usr/share/jenkins/ref

VOLUME $JENKINS_HOME

USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
CMD []