<?xml version="1.0" encoding="UTF-8"?>
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
    <xsl:variable name="path" select="@path"/>
    <xsl:copy>
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:for-each select="doc(/val:*/@system-id)">
        <xsl:attribute name="iati-identifier">{key('element', $path)/ancestor-or-self::iati-activity/iati-identifier}</xsl:attribute>
      </xsl:for-each>      
      <xsl:text>{.}</xsl:text>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>