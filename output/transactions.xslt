<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="">

  <xsl:import href="../lib/functx.xslt"/>

  <xsl:param name="delimiter" select=" ',' "/>
  <xsl:output method="text" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="//transaction">

  </xsl:template>

</xsl:stylesheet>
