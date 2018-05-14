<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:export="http://iati.me/export"
  xmlns:functx="http://www.functx.com">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="../office/spreadsheet.xslt"/>
  <xsl:import href="../../spreadsheet-iati/default-iati-office.xslt"/>
  <xsl:import href="/workspace/config/iati-office.xslt" />

  <xsl:param name="filename"/>
  <xsl:variable name="filebase" select="functx:substring-before-last($filename,'.xml')"/>

  <xsl:template name="create-file">
    <xsl:param name="filepart" tunnel="yes"/>
    <xsl:param name="dataset" tunnel="yes"/>
    <xsl:result-document method="xml" href="{$filepart}.{$filebase}.fods">
      <xsl:call-template name="office-spreadsheet-file">
        <xsl:with-param name="fileconfig" select="doc('/workspace/config/iati-office.xslt')//xsl:template[@export:export!='']" tunnel="yes"/>
        <xsl:with-param name="date-elements" select="('iso-date','value-date')" tunnel="yes"/>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>

  <xsl:function name="export:narrative" as="item()">
    <xsl:param name="item" as="item()?"/>
    <xsl:choose>
      <xsl:when test="$item/narrative">
        <xsl:copy-of select="$item/narrative"/>
      </xsl:when>
      <xsl:when test="string($item)=''">
        <narrative/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$item"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
