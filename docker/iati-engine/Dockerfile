FROM openjdk:9

MAINTAINER Rolf Kleef <rolf@drostan.org>

# Ant XML/XSLT engine
#
# docker run -it --rm=true -v /home/...your project path.../:/root antxml-engine ...target...

ENV ANT_VERSION    1.10.1
ENV SAXON_MAIN     9.7
ENV SAXON_VERSION  9-7-0-15J
ENV BASEX_VERSION  8.6

RUN cd && \
  wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} /opt/ant && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz

RUN cd && \
  wget -q http://files.basex.org/releases/${BASEX_VERSION}/BaseX86.zip && \
  unzip BaseX86.zip && \
  mv basex /opt && \
  rm BaseX86.zip

RUN cd && \
  wget -q https://downloads.sourceforge.net/project/saxon/Saxon-HE/${SAXON_MAIN}/SaxonHE${SAXON_VERSION}.zip && \
  unzip SaxonHE${SAXON_VERSION}.zip saxon9he.jar && \
  cp *.jar /opt/basex/lib && \
  mv *.jar /opt/ant/lib && \
  rm SaxonHE${SAXON_VERSION}.zip

ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin:/opt/basex/bin

WORKDIR /root
ENTRYPOINT ["ant"]
