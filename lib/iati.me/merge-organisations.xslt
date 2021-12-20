<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx merge">

  <xsl:output indent="yes"/>

  <xsl:template name="merge-organisations">
    <xsl:param name="input-organisations"/>
    <iati-organisations version="2.03" generated-datetime="{current-dateTime()}" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xsi:noNamespaceSchemaLocation="http://iatistandard.org/203/schema/downloads/iati-organisations-schema.xsd">
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment>Data4Development Spreadsheets2IATI converter service https://data4development.nl</xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:for-each-group select="$input-organisations" group-by="functx:trim(@merge:id)">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:if test="not(@merge:exclude='true')">
          <iati-organisation>
            <xsl:copy-of select="current-group()/@*[.!='' and not(name(.)=('merge:id', 'merge:exclude'))]" />
            <organisation-identifier><xsl:copy-of select="current-grouping-key()"/></organisation-identifier>
            <name>
              <xsl:apply-templates select="(current-group()/name/narrative)  [1]"/>
            </name>

            <xsl:apply-templates select="(current-group()/reporting-org)[1]"/>
            
            <xsl:apply-templates select="current-group()/total-budget"/>
            <xsl:apply-templates select="current-group()/recipient-org-budget"/>
            <xsl:apply-templates select="current-group()/recipient-region-budget"/>
            <xsl:apply-templates select="current-group()/recipient-country-budget"/>
            
            <xsl:apply-templates select="current-group()/total-expenditure"/>
            
            <xsl:apply-templates select="current-group()/document-link[@url!='']"/>
          </iati-organisation>
        </xsl:if>
      </xsl:for-each-group>
    </iati-organisations>
  </xsl:template>

  <!-- ignore these elements: -->
  <xsl:template match="narrative            [not(text())]"/>

  <!-- text elements without any narrative element with actual content -->
  <xsl:template match="name                 [not(narrative!='')]"/>

  <!-- copy the rest -->
  <!-- <xsl:template match="*[not(functx:is-node-in-sequence-deep-equal(.,preceding-sibling::*)) and not(name()='dir')]"> -->
  <xsl:template match="*">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
