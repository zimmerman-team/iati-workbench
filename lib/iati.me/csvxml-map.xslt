<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' expand-text="yes" xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:export="http://iati.me/export"
  xmlns:functx="http://www.functx.com">
  
  <xsl:output method="text"/>

  <xsl:import href="../functx.xslt"/>
  
  <xsl:template match="/">
    <xsl:text>File,Column&#xa;</xsl:text>   
    <xsl:apply-templates select="dir/f[ends-with(@n, '.csv.xml')]">
      <xsl:sort select="@n"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="f">
      <xsl:apply-templates select="doc(concat('/workspace/tmp/',@n))/csv/record[1]/entry">
        
        <xsl:with-param name="filename" select="substring-before(@n,'.csv.xml')"/>
      </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="entry">
    <xsl:param name="filename"/>
    <xsl:text>{$filename},{@name}&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>