<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:export="http://iati.me/export"
  xmlns:o="http://iati.me/office"
  xmlns:functx="http://www.functx.com">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="../office/spreadsheet.xslt"/>

  <xsl:template match="iati-activity" mode="office-spreadsheet-cells" export:export="summary">
    <xsl:copy-of copy-namespaces="no" select="o:cell(iati-identifier)" export:heading="IATI Activity Identifier" export:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(title/narrative[1])" export:heading="Activity Title" export:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(reporting-org/@ref)" export:heading="Reporting Org Id" export:column="co2"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(count(related-activity[@type='1']))" export:heading="# Parent Activities"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(related-activity[@type='2']))" export:heading="# Child Activities"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(count(participating-org[@role='1']))" export:heading="# Funding Orgs"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(participating-org[@role='4']))" export:heading="# Implementing Orgs"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(participating-org[@role='2']))" export:heading="# Accountable Orgs"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(count(distinct-values(sector[@vocabulary='1' or not(@vocabulary)]/@code)))" export:heading="# DAC Sectors"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(count(transaction[transaction-type/@code='11']))" export:heading="# Incoming Commitment Transactions"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(transaction[transaction-type/@code='2']))" export:heading="# Commitment Transactions"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(transaction[transaction-type/@code='1']))" export:heading="# Incoming Funds Transactions"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(transaction[transaction-type/@code='3']))" export:heading="# Disbursement Transactions"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(transaction[transaction-type/@code='4']))" export:heading="# Expenditure Transactions"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(count(result[@type='1']/indicator))" export:heading="# Output result indicators"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(result[@type='2']/indicator))" export:heading="# Outcome result indicators"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(count(result[@type='3']/indicator))" export:heading="# Impact result indicators"/>
  </xsl:template>

  <xsl:template match="/">
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'summary'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//iati-activity" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:param name="filename"/>
  <xsl:variable name="filebase" select="functx:substring-before-last($filename,'.xml')"/>

  <xsl:template name="create-file">
    <xsl:param name="filepart" tunnel="yes"/>
    <xsl:param name="dataset" tunnel="yes"/>
    <xsl:result-document method="xml" href="{$filebase}.{$filepart}.fods">
      <xsl:call-template name="office-spreadsheet-file">
        <xsl:with-param name="fileconfig" select="doc('./iati-summary.xslt')//xsl:template[@export:export!='']" tunnel="yes"/>
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
