<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  exclude-result-prefixes="">

  <xsl:import href="../functx.xslt"/>

  <xsl:template match="csv">
    <iati-activities version="2.02" generated-datetime="{current-dateTime()}" xml:lang="en">
      <xsl:apply-templates select="record"/>
    </iati-activities>
  </xsl:template>

  <xsl:template match="record">
    <!-- This is a fallback for any file not mentioned in the /workspace/config/csvxml-iati.xslt file -->
    <merge:not-processed><xsl:value-of select="$file"/></merge:not-processed>
  </xsl:template>

</xsl:stylesheet>
