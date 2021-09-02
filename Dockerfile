FROM openjdk:11-jdk-slim

LABEL maintainer="Rolf Kleef <rolf@drostan.org>" \
  description="Spreadsheets2IATI Engine for AIDA" \
  repository="https://github.com/data4development/iati-workbenchtree/aida"

# create a non-root user iati-workbench that will contain the code in its home folder 
ARG \
  UNAME=iati-workbench \
  GID=1000 \
  UID=1000

ENV \
  ANT_VERSION=1.10.1 \
  SAXON_VERSION=9.8.0-14 \
  WEBHOOK_VERSION=2.6.8 \
  BASEX_VERSION=8.6.6\
  BASEX_SHORT=866 \
  \
  HOME=/home/iati-workbench \
  ANT_HOME=/opt/ant \
  SAXON_HOME=/opt/ant \
  BASEX_HOME=/opt/basex

RUN groupadd -g $GID -o $UNAME && \
  useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

RUN apt-get update && \
  apt-get -y install --no-install-recommends wget less git xmlstarlet libreoffice-calc libreoffice-java-common unzip xz-utils && \
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

ENV PATH ${PATH}:${ANT_HOME}/bin:${BASEX_HOME}/bin

WORKDIR ${HOME}
USER $UNAME
COPY --chown=$UID:$GID . ${HOME}

ENTRYPOINT ["/opt/ant/bin/ant", "-e"]
CMD ["-p"]
