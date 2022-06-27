<?xml version="1.0" encoding="UTF-8"?>
<!--  IATI workbench: produce and use IATI data
  Copyright (C) 2016-2022, drostan.org and data4development.org

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://aida.tools/merge"
  exclude-result-prefixes="">

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:template match="iati-activity">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="merge:id" select="iati-identifier"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="result">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="merge:id" select="title/narrative[1]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="indicator">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="merge:id" select="(reference/@code,title/narrative)[1]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- add client-specific templates -->
  <xsl:include href="nuffic/akvo-s2i.xslt"/>
  <!-- override top-level iati-activity processing to include client-specific templates -->
  <xsl:template match="iati-activity[reporting-org/@ref='NL-KVK-41150085']">
    <xsl:apply-templates select="." mode="nuffic"/>
  </xsl:template>

</xsl:stylesheet>
