<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.pnp-software.com/XSLTdoc">

<xsl:template match="iati-activities" mode="walk">
  <xsl:apply-templates select="iati-activity" mode="#current"/>
</xsl:template>

<xd:doc>
  Match activities that do not point to a parent activity in this dataset, 
  or where another activity points to it as a child.
</xd:doc>
<xsl:template match="iati-activity[not(
    related-activity[@type='1' and @ref=//iati-identifier] 
    or
    iati-identifier = //related-activity[@type='2']/@ref
  )]" mode="walk">

  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="iati-activity" mode="walk"/>

<xsl:template match="iati-activity" mode="descend">
  <xsl:param name="activity-level" tunnel="yes" select="xs:integer(1)"/>
  <xsl:variable name="id" select="iati-identifier"/>
  <xsl:variable name="childIds" select="distinct-values((
    related-activity[type='2']/@ref,
    //iati-activity[related-activity[@type='1' and @ref=$id]]/iati-identifier
    ))"/>
    
  <xsl:apply-templates select="//iati-activity[iati-identifier=$childIds]">
    <xsl:with-param name="activity-level" select="$activity-level + 1" tunnel="yes"/>
  </xsl:apply-templates>
</xsl:template>
  
</xsl:stylesheet>