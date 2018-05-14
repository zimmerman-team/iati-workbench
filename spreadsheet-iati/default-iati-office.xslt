<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:x="http://iati.me/export"
  xmlns:o="http://iati.me/office">

  <xsl:template match="/">
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Projects'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//iati-activity" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Budgets'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//budget" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Transactions'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//transaction" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Results'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//indicator" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Related-activities'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//related-activity" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Participating'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//participating-org" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Countries-and-regions'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="(//recipient-country,//recipient-region)" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Sectors'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//sector" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="create-file">
      <xsl:with-param name="filepart" select="'Documents'" tunnel="yes"/>
      <xsl:with-param name="dataset" select="//document-link" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="iati-activity" mode="office-spreadsheet-cells" x:export="Projects">
    <xsl:copy-of copy-namespaces="no" select="o:cell(iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(title/narrative[1])" x:heading="Activity name" x:column="co4"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(related-activity[@type='1']/@ref[1])" x:heading="IATI parent activity identifier" x:column="co2"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-status/@code)" x:heading="Activity status"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-date[@type='1']/@iso-date)" x:heading="Planned start date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-date[@type='2']/@iso-date)" x:heading="Actual start date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-date[@type='3']/@iso-date)" x:heading="Planned end date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-date[@type='4']/@iso-date)" x:heading="Actual end date"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(description[@type='1'])" x:heading="General description" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@xml:lang)" x:heading="Language"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@default-currency)" x:heading="Currency"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(activity-scope/@code)" x:heading="Activity scope"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(collaboration-type/@code)" x:heading="Collaboration type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(default-flow-type/@code)" x:heading="Default flow type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(default-finance-type/@code)" x:heading="Default finance type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(default-aid-type/@code)" x:heading="Default aid type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(default-tied-status/@code)" x:heading="Default tied status"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/@type)" x:heading="Contact info type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/organisation/narrative)" x:heading="Contact info organisation" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/telephone)" x:heading="Contact telephone" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/email)" x:heading="Contact email" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/website)" x:heading="Contact website" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(contact-info/mailing-address/narrative)" x:heading="Contact mailing address" x:column="co4"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(policy-marker/@code)" x:heading="Policy marker"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(policy-marker/@significance)" x:heading="Policy significance"/>
  </xsl:template>

  <xsl:template match="budget" mode="office-spreadsheet-cells" x:export="Budgets">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative[1])" x:heading="Activity name" x:column="co4"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(@type)" x:heading="Budget type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@status)" x:heading="Budget status"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period-start/@iso-date)" x:heading="Budget start date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period-end/@iso-date)" x:heading="Budget end date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value/@currency)" x:heading="Currency"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value)" x:heading="Budget"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value/@value-date)" x:heading="Value date"/>
  </xsl:template>
  
  <xsl:template match="transaction" mode="office-spreadsheet-cells" x:export="Transactions">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative[1])" x:heading="Activity name" x:column="co4"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(transaction-type/@code)" x:heading="Type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(transaction-date/@iso-date)" x:heading="Date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value/@currency)" x:heading="Currency"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value)" x:heading="Amount"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(value/@value-date)" x:heading="Value date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@ref)" x:heading="Reference" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(description/narrative[1])" x:heading="Description" x:column="co4"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(provider-org/narrative)" x:heading="Provider organisation"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(provider-org/@ref)" x:heading="Provider organisation identifier"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(provider-org/@provider-activity-id)" x:heading="Provider activity identifier"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(receiver-org/narrative)" x:heading="Receiver organisation"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(receiver-org/@ref)" x:heading="Receiver organisation identifier"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(receiver-org/@receiver-activity-id)" x:heading="Receiver activity identifier"/>
  </xsl:template>

  <xsl:template match="indicator" mode="office-spreadsheet-cells" x:export="Results">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../../title/narrative[1])" x:heading="Activity name" x:column="co4"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative)" x:heading="Result title" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../description/narrative)" x:heading="Result description" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../@type)" x:heading="Result type"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../@aggregation-status)" x:heading="Aggregation status"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(@measure)" x:heading="Indicator measure"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(title/narrative)" x:heading="Indicator title" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(description/narrative)" x:heading="Indicator description" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@ascending)" x:heading="Ascending"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(baseline/@year)" x:heading="Baseline year"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(baseline/@value)" x:heading="Baseline"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(baseline/comment/narrative)" x:heading="Baseline comment" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/period-start/@iso-date)" x:heading="Start date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/period-end/@iso-date)" x:heading="End date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/target/@value)" x:heading="Target"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/target/comment)" x:heading="Target comment"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/actual/@value)" x:heading="Actual"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(period/actual/comment)" x:heading="Actual comment"/>
  </xsl:template>

  <xsl:template match="related-activity" mode="office-spreadsheet-cells" x:export="Related-activities">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="From IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title[1])" x:heading="Title" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@ref)" x:heading="To IATI activity identifier" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@type)" x:heading="Type"/>
  </xsl:template>

  <xsl:template match="participating-org" mode="office-spreadsheet-cells" x:export="Participating">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative[1])" x:heading="Activity name" x:column="co4"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(@role)" x:heading="Role"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@type)" x:heading="Type"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(narrative)" x:heading="Organisation name" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@ref)" x:heading="Organisation identifier" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@activity-id)" x:heading="Activity identifier" x:column="co2"/>
  </xsl:template>

  <xsl:template match="recipient-country|recipient-region" mode="office-spreadsheet-cells" x:export="Countries-and-regions">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative[1])" x:heading="Activity name" x:column="co4"/>

    <xsl:copy-of copy-namespaces="no" select="o:cell(.[name(.)='recipient-country']/narrative)" x:heading="Country name"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(.[name(.)='recipient-country']/@code)" x:heading="Country code"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(.[name(.)='recipient-region']/narrative)" x:heading="Region name"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(.[name()='recipient-region']/@code)" x:heading="Region code"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@vocabulary[name(.)='recipient-region'])" x:heading="Region vocabulary"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@percentage)" x:heading="Budget percentage"/>
  </xsl:template>

  <xsl:template match="sector" mode="office-spreadsheet-cells" x:export="Sectors">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title/narrative[1])" x:heading="Activity name" x:column="co4"/>
    
    <xsl:copy-of copy-namespaces="no" select="o:cell(narrative)" x:heading="Sector name"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@vocabulary)" x:heading="Sector vocabulary"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@vocabulary-uri)" x:heading="Sector vocabulary URI" x:column="co2"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@code)" x:heading="Sector code"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@percentage)" x:heading="Budget percentage"/>
  </xsl:template>

  <xsl:template match="document-link" mode="office-spreadsheet-cells" x:export="Documents">
    <xsl:copy-of copy-namespaces="no" select="o:cell(../iati-identifier)" x:heading="IATI activity identifier" x:column="co3"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(../title[1])" x:heading="Activity Title" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(title/narrative)" x:heading="Document title" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(language/@code)" x:heading="Document language"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(document-date/@iso-date)" x:heading="Document date"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(category/@code)" x:heading="Category"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@url)" x:heading="Web address" x:column="co4"/>
    <xsl:copy-of copy-namespaces="no" select="o:cell(@format)" x:heading="Format" x:column="co2"/>
  </xsl:template>

</xsl:stylesheet>
