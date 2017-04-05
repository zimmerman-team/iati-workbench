FROM openjdk:9-jre

MAINTAINER Rolf Kleef <rolf@drostan.org>

# IATI Engine:
# Ant XML/XSLT
# BaseX
# csvkit
# node, bower
#
# docker run -it --rm=true -v /home/...your project path.../:/root antxml-engine ...target...

ENV ANT_VERSION    1.10.1
ENV SAXON_MAIN     9.7
ENV SAXON_VERSION  9-7-0-15J
ENV BASEX_VERSION  8.6
ENV NODE_VERSION   6.10.0

WORKDIR /root

RUN wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} /opt/ant

RUN wget -q http://files.basex.org/releases/${BASEX_VERSION}/BaseX86.zip && \
  unzip BaseX86.zip && \
  rm BaseX86.zip && \
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

RUN wget -q https://github.com/Ant-Grand/Grand/releases/download/1.9.5/grand-1.9.5.jar -O /opt/ant/lib/grand-1.9.5.jar

ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin:/opt/basex/bin:/opt/node/bin:/root/bin

RUN npm install -g bower && \
  # running bower as non-root user without home dir insists on having a config folder in root...
  mkdir /.config && chmod ugo+rwx /.config && \
  mkdir /.local && chmod ugo+rwx /.local

RUN apt-get update && \
  apt-get -y install --no-install-recommends less git python3 graphviz xmlstarlet

RUN wget -q https://bootstrap.pypa.io/get-pip.py &&\
  python3 get-pip.py &&\
  rm get-pip.py &&\
  pip install csvkit &&\
  pip install Pygments

WORKDIR /root
ENTRYPOINT ["ant"]
