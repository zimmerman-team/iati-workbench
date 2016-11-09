<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="">

  <xsl:import href="../lib/functx.xslt"/>

  <xsl:param name="delimiter" select=" ',' "/>
  <xsl:output method="text" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="//transaction[provider-org/@provider-activity-id and receiver-org/@receiver-activity-id]">
    <xsl:value-of select="transaction-type/@code"/><xsl:text>, </xsl:text>
    <xsl:value-of select="provider-org/@provider-activity-id"/><xsl:text> </xsl:text>
    <xsl:text>[</xsl:text><xsl:value-of select="value"/><xsl:text>] </xsl:text>
    <xsl:value-of select="receiver-org/@receiver-activity-id"/><xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="text()|@*">
  </xsl:template>
</xsl:stylesheet>
