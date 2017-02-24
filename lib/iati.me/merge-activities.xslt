<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="/iati-activities">
  <iati-activities>
    <xsl:copy-of select="@*[.!='']" />
    <xsl:for-each-group select="//iati-activity" group-by="iati-identifier[.!='']">
      <iati-activity>
        <xsl:copy-of select="current-group()/@*[name(.)!='xml-lang']" />
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="data(current-group()/@*[name(.)='xml-lang'][1])"/>
        </xsl:attribute>
        <iati-identifier><xsl:copy-of select="current-grouping-key()"/></iati-identifier>
        <xsl:apply-templates select="current-group()/reporting-org[1]"/>
        <xsl:apply-templates select="current-group()/title"/>
        <xsl:apply-templates select="current-group()/description"/>
        <xsl:apply-templates select="current-group()/participating-org"/>
        <xsl:apply-templates select="current-group()/other-identifier"/>
        <xsl:apply-templates select="current-group()/activity-status"/>
        <xsl:apply-templates select="current-group()/activity-date"/>
        <xsl:apply-templates select="current-group()/activity-date"/>
        <xsl:apply-templates select="current-group()/contact-info"/>
        <xsl:apply-templates select="current-group()/activity-scope"/>
        <xsl:apply-templates select="current-group()/recipient-country[@code!='']"/>
        <xsl:apply-templates select="current-group()/recipient-region[@code!='']"/>
        <xsl:apply-templates select="current-group()/location"/>
        <xsl:apply-templates select="current-group()/sector"/>
        <xsl:apply-templates select="current-group()/country-budget-items"/>
        <xsl:apply-templates select="current-group()/humanitarian-scope"/>
        <xsl:apply-templates select="current-group()/policy-marker"/>
        <xsl:apply-templates select="current-group()/collaboration-type"/>
        <xsl:apply-templates select="current-group()/default-flow-type"/>
        <xsl:apply-templates select="current-group()/default-finance-type"/>
        <xsl:apply-templates select="current-group()/default-aid-type"/>
        <xsl:apply-templates select="current-group()/default-tied-status"/>
        <xsl:apply-templates select="current-group()/budget"/>
        <xsl:apply-templates select="current-group()/planned-disbursement"/>
        <xsl:apply-templates select="current-group()/capital-spend"/>
        <xsl:apply-templates select="current-group()/transaction"/>
        <xsl:apply-templates select="current-group()/document-link"/>
        <xsl:apply-templates select="current-group()/related-activity[@ref!='']"/>
        <xsl:apply-templates select="current-group()/conditions"/>
        <xsl:apply-templates select="current-group()/result"/>
        <xsl:apply-templates select="current-group()/resultcrs-add"/>
        <xsl:apply-templates select="current-group()/fss"/>
      </iati-activity>
    </xsl:for-each-group>
  </iati-activities>
</xsl:template>

<!-- ignore these elements -->
<xsl:template match="description[not (narrative!='')]" />
<xsl:template match="comment[not (narrative!='')]" />
<xsl:template match="baseline[@year='']" />

<!-- copy the rest -->
<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*[.!='']" />
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
