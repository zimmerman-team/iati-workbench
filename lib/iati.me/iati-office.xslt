<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:export="http://iati.me/export"
  xmlns:functx="http://www.functx.com">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="../office/spreadsheet.xslt"/>
  <xsl:import href="/workspace/config/iati-office.xslt"/>

  <xsl:param name="filename"/>
  <xsl:variable name="filebase" select="functx:substring-before-last($filename,'.xml')"/>

  <xsl:template name="create-file">
    <xsl:param name="filepart" tunnel="yes"/>
    <xsl:param name="dataset" tunnel="yes"/>
    <xsl:result-document method="xml" href="{$filebase}.{$filepart}.ods.xml">
      <xsl:call-template name="office-spreadsheet-file">
        <xsl:with-param name="fileconfig" select="doc('/workspace/config/iati-office.xslt')//xsl:template[@export:export!='']" tunnel="yes"/>
        <xsl:with-param name="date-elements" select="('iso-date','value-date')" tunnel="yes"/>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
