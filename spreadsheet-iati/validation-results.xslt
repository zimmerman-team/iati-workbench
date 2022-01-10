<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:val="http://saxon.sf.net/ns/validation"
  exclude-result-prefixes="xs"
  version="3.0"
  expand-text="yes">

  <xsl:output method="text"/>

  <xsl:template match="val:validation-report">
    <xsl:text>{string-join((
      'IATI identifier',
      'line',
      'element in activity',
      'message'
    ), ", ")}&#xa;</xsl:text>
    <xsl:apply-templates select="val:error"/>
  </xsl:template>

  <xsl:template match="val:error">
    <xsl:text>{string-join((
      @iati-identifier,
      @line,
      replace(@path, '^.*iati-activity\[\d+\]/(.*)$', '$1')=>replace('Q{}', '', 'q'),
      '&quot;' || .  || '&quot;'), ", ")
    }&#xa;</xsl:text>

  </xsl:template>
</xsl:stylesheet>