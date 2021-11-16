<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com">
  
  <!-- file will be copied into the workspace config/ dir -->
  <xsl:import href="/home/iati-workbench/lib/iati.me/csvxml-iati.xslt"/>
  <xsl:import href="/home/iati-workbench/spreadsheet-iati/default-templates.xsl"/>
  <xsl:import href="csvxml-iati.xslt"/>

  <xsl:param name="filename"/>
  <xsl:variable name="file" select="functx:substring-before-last($filename,'.csv.xml')"/>
</xsl:stylesheet>
