<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:val="http://saxon.sf.net/ns/validation"
  exclude-result-prefixes="xs"
  version="3.0"
  expand-text="yes">
  
  <xsl:output method="text"/>
  
  <xsl:key name="element" match="*" use="path()"/>
  
  <xsl:template match="val:validation-report">
    <xsl:text>{@system-id}: {val:results/@errors} errors, {val:results/@warnings} warnings&#xa;</xsl:text>
    <xsl:apply-templates select="val:error"/>
  </xsl:template>
  
  <xsl:template match="val:error">
    <xsl:variable name="path" select="@path"/>
    <xsl:for-each select="doc(/val:*/@system-id)">
      <xsl:text>{key('element', $path)/ancestor-or-self::iati-activity/iati-identifier}: </xsl:text>
    </xsl:for-each>
    <xsl:text>{.}&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>