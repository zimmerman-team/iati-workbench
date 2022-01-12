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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:val="http://saxon.sf.net/ns/validation"
  exclude-result-prefixes="xs"
  version="3.0"
  expand-text="yes">
  
  <xsl:output indent="yes"/>
  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:key name="element" match="*" use="path()"/>
  
  <xsl:template match="val:error">
    <xsl:variable name="path" select="replace(@path, '(^.*iati-activity\[\d+\]).*$', '$1')"/>
    <xsl:copy>
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:for-each select="doc(/val:*/@system-id)">
        <xsl:attribute name="iati-identifier">{key('element', $path)/iati-identifier}</xsl:attribute>
      </xsl:for-each>      
      <xsl:text>{.}</xsl:text>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>