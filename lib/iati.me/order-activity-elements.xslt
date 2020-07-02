<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
  <xsl:output indent="yes"/>
  
  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:template match="iati-activity">
    <iati-activity>
      <xsl:copy-of select="@*"/>    
      <xsl:apply-templates select="iati-identifier"/>
      <xsl:apply-templates select="reporting-org"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="description"/>
      <xsl:apply-templates select="participating-org"/>
      <xsl:apply-templates select="other-identifier"/>
      <xsl:apply-templates select="activity-status"/>
      <xsl:apply-templates select="activity-date"/>
      <xsl:apply-templates select="contact-info"/>
      <xsl:apply-templates select="activity-scope"/>
      <xsl:apply-templates select="recipient-country"/>
      <xsl:apply-templates select="recipient-region"/>
      <xsl:apply-templates select="location"/>
      <xsl:apply-templates select="sector"/>
      <xsl:apply-templates select="country-budget-items"/>
      <xsl:apply-templates select="humanitarian-scope"/>
      <xsl:apply-templates select="policy-marker"/>
      <xsl:apply-templates select="collaboration-type"/>
      <xsl:apply-templates select="default-flow-type"/>
      <xsl:apply-templates select="default-finance-type"/>
      <xsl:apply-templates select="default-aid-type"/>
      <xsl:apply-templates select="default-tied-status"/>
      <xsl:apply-templates select="budget"/>
      <xsl:apply-templates select="planned-disbursement"/>
      <xsl:apply-templates select="capital-spend"/>
      <xsl:apply-templates select="transaction"/>
      <xsl:apply-templates select="document-link"/>
      <xsl:apply-templates select="related-activity"/>
      <xsl:apply-templates select="legacy-data"/>
      <xsl:apply-templates select="conditions"/>
      <xsl:apply-templates select="result"/>
      <xsl:apply-templates select="crs-add"/>
      <xsl:apply-templates select="fss"/>
    </iati-activity>
  </xsl:template>
</xsl:stylesheet>
