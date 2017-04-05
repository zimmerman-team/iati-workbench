<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="iati-me functx">

  <xsl:import href="../lib/iati.me/csv-iati.xslt"/>
  <xsl:import href="/workspace/config/csvxml-iati.xslt"/>

  <xsl:param name="filename"/>
  <xsl:variable name="file" select="functx:substring-before-last($filename,'.xls.csv.xml')"/>

  <xsl:template match="/csv">
    <iati-activities>
      <xsl:apply-templates select="record"/>
    </iati-activities>
  </xsl:template>

</xsl:stylesheet>
