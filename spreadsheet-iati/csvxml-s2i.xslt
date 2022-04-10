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
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <!-- add generic templates -->
  <xsl:include href="default-templates-act.xsl"/>
  <xsl:include href="default-templates-org.xsl"/>
  <xsl:import href="../lib/iati.me/csvxml-s2i.xslt"/>

  <!-- add client-specific templates -->
  <xsl:include href="nuffic-templates.xsl"/>
  <!-- override top-level csv processing to include client-specific templates -->
  <xsl:template match="csv">
    <iati-activities version="2.03" generated-datetime="{current-dateTime()}" xml:lang="en">
      <xsl:apply-templates select="record"/>
      <xsl:choose>
        <xsl:when test="$reporting-org='NL-KVK-41150085'">
          <xsl:apply-templates select="record" mode="nuffic"/>
        </xsl:when>
      </xsl:choose>
    </iati-activities>
  </xsl:template>
</xsl:stylesheet>
