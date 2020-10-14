<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="">

  <xsl:import href="../functx.xslt"/>

  <xsl:function name="merge:get-code-from-list">
    <xsl:param name="list"/>
    <xsl:param name="text"/>
    <xsl:variable name="codelist" select="doc(concat(
      '../schemata/2.03/codelist/', $list, '.xml' ))"/>
    <xsl:value-of select="(
      $codelist//codelist-item[some $name in name/narrative satisfies (lower-case($name)=lower-case($text))]/code,
      $text)[1]"/>
  </xsl:function>
</xsl:stylesheet>
