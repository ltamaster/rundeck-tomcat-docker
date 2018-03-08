FROM tomcat:9.0.5-jre8

RUN apt-get -y update && \
    apt-get -y install \
        sudo \
        git \
        uuid-runtime \
        net-tools \
        jq \
        openssh-server \
        openssh-client \
        apt-transport-https \
        vim


# add GPG key
RUN curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" > /tmp/bintray.gpg.key
RUN apt-key add - < /tmp/bintray.gpg.key


# add cli tool debian repo
ARG CLI_DEB_URL=https://dl.bintray.com/rundeck/rundeck-deb
ARG CLI_VERS=1.0.17-1
ARG API_KEY

RUN echo "deb $CLI_DEB_URL /" | sudo tee -a /etc/apt/sources.list

RUN test -f $HOME/data/rd.deb && dpkg -i $HOME/data/rd.deb || true
RUN test -f $HOME/data/rd.deb || apt-get -y update
RUN test -f $HOME/data/rd.deb || apt-get -y install rundeck-cli=$CLI_VERS


ENV RDECK_BASE=/opt/rundeck

RUN mkdir -p $RDECK_BASE
RUN mkdir -p $RDECK_BASE/scripts

COPY rundeck $RDECK_BASE
COPY scripts $RDECK_BASE/scripts
COPY data    $RDECK_BASE/data
COPY data/rundeckpro.war $CATALINA_HOME/webapps

RUN chmod -R a+x $RDECK_BASE/scripts/*

RUN export API_KEY=$API_KEY


EXPOSE 8080

WORKDIR $CATALINA_HOME
ADD config/tomcat-users.xml $CATALINA_HOME/conf


# Start the instance.
CMD $RDECK_BASE/scripts/config.sh && catalina.sh run
