<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="document-link" mode="rules" priority="6.1">
  <xsl:variable name="unlikelyformats" select="(
    'application/javascript'
    )"/>

  <xsl:if test="@format=$unlikelyformats">
    <iati-me:feedback type="info" class="information" id="6.1.1">
      The type is specified as <code><xsl:value-of select="@format"/></code>.
      This is an unlikely format for a document.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
