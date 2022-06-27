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
<!--
  This stylesheet takes a directory listing in XML format as input,
  selects the generated partial IATI files,
  and creates two IATI files (activities and organisations).
-->
<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:import href="../functx.xslt"/>
  <xsl:include href="lib-merge.xslt"/>
  <xsl:include href="merge-activities.xslt"/>
  <xsl:include href="merge-organisations.xslt"/>

  <xsl:template match="/dir">
    <xsl:variable name="docs" select="document(f/@n[ends-with(.,'.generated.xml')])"/>

    <xsl:result-document method="xml" href="iati-activities.xml">
      <xsl:call-template name="merge-activities">
        <xsl:with-param name="input-activities" select="$docs//iati-activity"/>
      </xsl:call-template>
    </xsl:result-document>

    <xsl:result-document method="xml" href="iati-organisations.xml">
      <xsl:call-template name="merge-organisations">
        <xsl:with-param name="input-organisations" select="$docs//iati-organisation"/>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
