FROM openjdk:11-jdk-slim

MAINTAINER Rolf Kleef <rolf@drostan.org>

# IATI Engine:
# Ant XML/XSLT
# BaseX
# xmlstarlet, source-highlight
# node, bower
# LibreOffice
#
# docker run -it --rm=true -v /home/...your project path.../:/root antxml-engine ...target...

ENV ANT_VERSION    1.10.1
ENV SAXON_MAIN     9.8
ENV SAXON_VERSION  9-8-0-4J
ENV BASEX_VERSION  8.6.6
ENV BASEX_SHORT    866
ENV NODE_VERSION   6.10.0

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
    wget less git xmlstarlet libreoffice-calc libreoffice-java-common source-highlight unzip xz-utils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} /opt/ant

RUN wget -q http://files.basex.org/releases/${BASEX_VERSION}/BaseX${BASEX_SHORT}.zip && \
  unzip BaseX${BASEX_SHORT}.zip && \
  rm BaseX${BASEX_SHORT}.zip && \
  mv basex /opt

RUN wget -q https://downloads.sourceforge.net/project/saxon/Saxon-HE/${SAXON_MAIN}/SaxonHE${SAXON_VERSION}.zip && \
  unzip SaxonHE${SAXON_VERSION}.zip saxon9he.jar && \
  rm SaxonHE${SAXON_VERSION}.zip && \
  cp *.jar /opt/basex/lib && \
  mv *.jar /opt/ant/lib

RUN wget -q https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz &&\
  tar -xvf node-v${NODE_VERSION}-linux-x64.tar.xz && \
  rm node-v${NODE_VERSION}-linux-x64.tar.xz && \
  mv node-v${NODE_VERSION}-linux-x64 /opt/node

ENV ANT_HOME /opt/ant

# for Xspec:
ENV SAXON_HOME /opt/ant/lib

ENV PATH $PATH:/opt/ant/bin:/opt/basex/bin:/opt/node/bin:/root/docker/iati-engine/bin

# Adding a user with the same uid as on the host system, to make managing created files easier
# It's also possible to run everything as root or another user: in that case, creating the init directories
# is better done on the host system, to make sure the normal user can add and remove files from them.
# We apparently need to have a user known to the system to run LibreOffice in headless mode.
# TODO Improve this, it works for my own situation right now.
RUN useradd -u 1001 -U -ms /bin/bash iati-engine && \
  echo "iati-engine ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN npm install -g bower

ENV HOME /home/iati-engine
COPY . $HOME
