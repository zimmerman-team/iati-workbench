FROM openjdk:11-jdk-slim

LABEL maintainer="Rolf Kleef <rolf@drostan.org>" \
  description="IATI Workbench Engine" \
  repository="https://github.com/data4development/iati-workbench"

# To build the container
ENV \
    ANT_VERSION=1.10.1 \
    SAXON_VERSION=9.8.0-14 \
    WEBHOOK_VERSION=2.6.8 \
    BASEX_VERSION=8.6.6\
    BASEX_SHORT=866 \
    \
    HOME=/root \
    ANT_HOME=/opt/ant \
    SAXON_HOME=/opt/ant \
    BASEX_HOME=/opt/basex

WORKDIR /root

RUN apt-get update && \
  apt-get -y install --no-install-recommends wget less git xmlstarlet libreoffice-calc libreoffice-java-common source-highlight unzip xz-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} ${ANT_HOME}

RUN wget -q http://files.basex.org/releases/${BASEX_VERSION}/BaseX${BASEX_SHORT}.zip && \
  unzip BaseX${BASEX_SHORT}.zip && \
  rm BaseX${BASEX_SHORT}.zip && \
  mv basex ${BASEX_HOME}

RUN wget -q https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar && \
  cp *.jar ${BASEX_HOME}/lib && \
  mv *.jar ${ANT_HOME}/lib

ENV PATH ${PATH}:${ANT_HOME}/bin:${BASEX_HOME}/bin:/root/docker/iati-engine/bin

VOLUME /workspace

COPY . $HOME

# (ported from IATI validator, keep in case we add Xspec tests)
# RUN mkdir -p $HOME/tests/xspec && \
#   chmod go+w $HOME/tests/xspec && \
#   mkdir -p /work && \
#   chmod go+w /work && \
#   ln -s /workspace /work/space

ENTRYPOINT ["/opt/ant/bin/ant", "-e"]
CMD ["-p"]
