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
<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all"
  expand-text="yes">
  
  <xsl:import href="../../lib/functx.xslt"/>
  <xsl:include href="../../lib/iati.me/lib-merge.xslt"/>
  <xsl:include href="../../lib/iati.me/merge-activities.xslt"/>
  
  <!-- our version of on-no-match="shallow-copy", without copying namespaces -->
  <xsl:template match=".">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
