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
<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all">

  <xsl:output indent="yes"/>

  <xsl:template name="merge-organisations">
    <xsl:param name="input-organisations"/>
    <xsl:comment>Data4Development Spreadsheets2IATI converter service https://data4development.nl</xsl:comment>
    <iati-organisations version="2.03" generated-datetime="{current-dateTime()}" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xsi:noNamespaceSchemaLocation="http://iatistandard.org/203/schema/downloads/iati-organisations-schema.xsd">
      <xsl:for-each-group select="$input-organisations" group-by="functx:trim(@merge:id)">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:if test="not(@merge:exclude='true')">
          <iati-organisation>
            <xsl:copy-of select="current-group()/@*[.!='' and not(name(.)=('merge:id', 'merge:exclude'))]" />
            <organisation-identifier><xsl:copy-of select="current-grouping-key()"/></organisation-identifier>
            <name>
              <xsl:apply-templates select="(current-group()/name/narrative)  [1]"/>
            </name>

            <xsl:apply-templates select="(current-group()/reporting-org)[1]"/>
            
            <xsl:apply-templates select="current-group()/total-budget"/>
            <xsl:apply-templates select="current-group()/recipient-org-budget"/>
            <xsl:apply-templates select="current-group()/recipient-region-budget"/>
            <xsl:apply-templates select="current-group()/recipient-country-budget"/>
            
            <xsl:apply-templates select="current-group()/total-expenditure"/>
            
            <xsl:apply-templates select="current-group()/document-link[@url!='']"/>
          </iati-organisation>
        </xsl:if>
      </xsl:for-each-group>
    </iati-organisations>
  </xsl:template>

</xsl:stylesheet>
