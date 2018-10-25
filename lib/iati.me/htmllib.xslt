<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0'
  xmlns:functx="http://www.functx.com"
  xmlns:htmllib="http://www.iati.me/htmllib"
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'>

  <xsl:function name="htmllib:toHtml" as="xs:string">
    <xsl:param name="text" as="xs:string*"/>
    <xsl:value-of>
      <xsl:for-each select="tokenize($text[1], '&#xa;|&#xd;|&#xa;&#xd;')">
        <xsl:if test="position()>1"><br/></xsl:if>
        <xsl:value-of select="current()"/>
      </xsl:for-each>
    </xsl:value-of>
  </xsl:function>

</xsl:stylesheet>
