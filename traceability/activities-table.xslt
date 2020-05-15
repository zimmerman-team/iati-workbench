<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"
  expand-text="yes">
  
  <xsl:output method="text"/>
  
  <xsl:variable name="corpus" select="collection('/workspace/input/?select=*.xml')/*/iati-activity"/>
  
  <xsl:template match="/">
    <xsl:text>"iati-identifier", "partnership", "partnership-name", "hierarchy", "organisation", "level", "class", "published?", "upstream", "upstream organisation", "in this", "in up"</xsl:text>    
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="activity">
    <xsl:text>"{.}", "{@partnership}", "{@partnership-name}", "{@hierarchy}", "{@org}", "{@level}", "{@class}", "{@published}", "{@up}", "{@up_org}", "{@in_this}", "{@in_up}"</xsl:text>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>