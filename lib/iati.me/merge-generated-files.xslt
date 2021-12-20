<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all">

  <xsl:output indent="yes"/>

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="merge-activities.xslt"/>
  <xsl:import href="merge-organisations.xslt"/>

  <xsl:template match="/dir">
    <xsl:variable name="docs" select="document(f/@n[ends-with(.,'.generated.xml')])"/>

    <xsl:call-template name="merge-activities">
      <xsl:with-param name="input-activities" select="$docs//iati-activity"/>
    </xsl:call-template>

    <xsl:call-template name="merge-organisations">
      <xsl:with-param name="input-organisations" select="$docs//iati-organisation"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
