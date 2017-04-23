<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="iati-me functx">

  <xsl:template match="iati-activity">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="iati-identifier"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="result">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="title/narrative[1]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="indicator">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="(reference/@code,title/narrative)[1]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- copy the rest -->
  <xsl:template match="*">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
