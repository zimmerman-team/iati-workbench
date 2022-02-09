FROM ubuntu:focal

LABEL maintainer="Rolf Kleef <rolf@drostan.org>" \
  description="Spreadsheets2IATI Engine for AIDA" \
  repository="https://github.com/data4development/iati-workbenchtree/aida"

#  IATI workbench: produce and use IATI data
#  Copyright (C) 2016-2022, drostan.org and data4development.org
  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# create a non-root user iati-workbench that will contain the code in its home folder 
ARG \
  UNAME=iati-workbench \
  GID=1000 \
  UID=1000 \
  DEBIAN_FRONTEND=noninteractive

RUN groupadd -g $GID -o $UNAME && \
  useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

RUN apt-get update && \
  # to remove basex warnings: libjline2-java libjing-java libtagsoup-java libxml-commons-resolver1.1-java
  apt-get -y install --no-install-recommends ant xmlstarlet libreoffice-calc-nogui libreoffice-java-common \
    libsaxonhe-java basex libjline2-java libjing-java libtagsoup-java libxml-commons-resolver1.1-java locales && \
  # enable and generate the locale we want:
  sed -i '/en_IE.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen && \
  ln -s /usr/share/java/Saxon-HE.jar /usr/share/ant/lib && \
  # reduce footprint of this layer:
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/dpkg/info/* && \
  rm -rf /usr/lib/libreoffice/share/gallery/* && \
  rm -rf /usr/lib/libreoffice/share/template/* && \
  rm -rf /usr/lib/libreoffice/share/wizards/* && \
  rm -rf /usr/share/libreoffice/share/config/* && \
  rm -rf /usr/share/doc/*

ENV HOME=/home/$UNAME
ENV LC_ALL=en_IE.UTF-8
WORKDIR $HOME
USER $UNAME
COPY --chown=$UID:$GID . $HOME

ENTRYPOINT ["/usr/bin/ant"]
CMD ["-p"]
