<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  expand-text="yes">

  <xsl:import href="../lib/functx.xslt"/>
  <xsl:import href="../lib/office/spreadsheet.xslt"/>
  <xsl:param name="filename"/>
  <xsl:variable name="filebase" select="functx:substring-before-last($filename,'.xml')"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/iati-activities">
    <xsl:result-document method="xml" href="{$filebase}.Projects.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="iati-activity"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.budgets.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//budget"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.transactions.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//transaction"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.results.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//indicator"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.related-activities.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//related-activity"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.participating.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//participating-org"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.countries-and-regions.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="(//recipient-country,//recipient-region)"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.sectors.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//sector"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
    
    <xsl:result-document method="xml" href="{$filebase}.documents.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//document-link"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    
  </xsl:template>

  <xsl:template match="iati-activity">
    <row>
      <column name="IATI activity identifier" style="co3">{iati-identifier}</column>
      <column name="Activity name" style="co4">{title/narrative[1]}</column>
      
      <column name="IATI parent activity identifier" style="co2">{related-activity[@type='1']/@ref[1]}</column>
      
      <column name="Activity status">{activity-status/@code}</column>
      <column name="Planned start date" type="date">{activity-date[@type='1']/@iso-date}</column>
      <column name="Actual start date" type="date">{activity-date[@type='2']/@iso-date}</column>
      <column name="Planned end date" type="date">{activity-date[@type='3']/@iso-date}</column>
      <column name="Actual end date" type="date">{activity-date[@type='4']/@iso-date}</column>
      
      <column name="General description" style="co4">{description[@type='1']}</column>
      <column name="Language">{@xml:lang}</column>
      <column name="Currency">{@default-currency}</column>
      
      <column name="Activity scope">{activity-scope/@code}</column>
      <column name="Collaboration type">{collaboration-type/@code}</column>
      <column name="Default flow type">{default-flow-type/@code}</column>
      <column name="Default finance type">{default-finance-type/@code}</column>
      <column name="Default aid type">{default-aid-type/@code}</column>
      <column name="Default tied status">{default-tied-status/@code}</column>
      
      <column name="Contact info type">{contact-info/@type}</column>
      <column name="Contact info organisation" style="co2">{contact-info/organisation/narrative}</column>
      <column name="Contact telephone" style="co2">{contact-info/telephone}</column>
      <column name="Contact email" style="co2">{contact-info/email}</column>
      <column name="Contact website" style="co2">{contact-info/website}</column>
      <column name="Contact mailing address" style="co4">{contact-info/mailing-address/narrative}</column>
      
      <column name="Policy marker">{policy-marker/@code}</column>
      <column name="Policy significance">{policy-marker/@significance}</column>
    </row>
  </xsl:template>

  <xsl:template match="budget">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title/narrative[1]}</column>
      
      <column name="Budget type">{@type}</column>
      <column name="Budget status">{@status}</column>
      <column name="Budget start date" type="date">{period-start/@iso-date}</column>
      <column name="Budget end date" type="date">{period-end/@iso-date}</column>
      <column name="Currency">{value/@currency}</column>
      <column name="Budget" type="value">{value}</column>
      <column name="Value date" type="date">{value/@value-date}</column>
    </row>
  </xsl:template>

  <xsl:template match="transaction">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title/narrative[1]}</column>
      
      <column name="Type">{transaction-type/@code}</column>
      <column name="Date" type="date">{transaction-date/@iso-date}</column>
      <column name="Currency">{value/@currency}</column>
      <column name="Amount" type="value">{value}</column>
      <column name="Value date" type="date">{value/@value-date}</column>
      <column name="Reference" style="co2">{@ref}</column>
      <column name="Description" style="co4">{description/narrative[1]}</column>
      
      <column name="Provider organisation">{provider-org/narrative}</column>
      <column name="Provider organisation identifier">{provider-org/@ref}</column>
      <column name="Provider activity identifier">{provider-org/@provider-activity-id}</column>
      <column name="Receiver organisation">{receiver-org/narrative}</column>
      <column name="Receiver organisation identifier">{receiver-org/@ref}</column>
      <column name="Receiver activity identifier">{receiver-org/@receiver-activity-id}</column>
      <column name="Disbursement channel">{disbursement-channel}</column>
    </row>
  </xsl:template>

  <xsl:template match="indicator">
    <row>
      <column name="IATI activity identifier" style="co3">{../../iati-identifier}</column>
      <column name="Activity name" style="co4">{../../title/narrative[1]}</column>
      
      <column name="Result title" style="co4">{../title/narrative}</column>
      <column name="Result description" style="co4">{../description/narrative}</column>
      <column name="Result type">{../@type}</column>
      <column name="Aggregation status">{../@aggregation-status}</column>
      
      <column name="Indicator measure">{@measure}</column>
      <column name="Indicator title" style="co4">{title/narrative}</column>
      <column name="Indicator description" style="co4">{description/narrative}</column>
      <column name="Ascending">{@ascending}</column>
      <column name="Baseline year">{baseline/@year}</column>
      <column name="Baseline" type="value">{baseline/@value}</column>
      <column name="Baseline comment" style="co4">{baseline/comment/narrative}</column>
      <column name="Start date" type="date">{period/period-start/@iso-date}</column>
      <column name="End date" type="date">{period/period-end/@iso-date}</column>
      <column name="Target" type="value">{period/target/@value}</column>
      <column name="Target comment">{period/target/comment}</column>
      <column name="Actual" type="value">{period/actual/@value}</column>
      <column name="Actual comment">{period/actual/comment}</column>
    </row>
  </xsl:template>

  <xsl:template match="related-activity">
    <row>
      <column name="From IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Title" style="co4">{../title[1]}</column>
      <column name="To IATI activity identifier" style="co2">{@ref}</column>
      <column name="Type">{@type}</column>
    </row>
  </xsl:template>

  <xsl:template match="participating-org">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title/narrative[1]}</column>
      
      <column name="Role">{@role}</column>
      <column name="Type">{@type}</column>
      
      <column name="Organisation name" style="co4">{narrative}</column>
      <column name="Organisation identifier" style="co2">{@ref}</column>
      <column name="Activity identifier" style="co2">{@activity-id}</column>
    </row>
  </xsl:template>

  <xsl:template match="recipient-country|recipient-region">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title/narrative[1]}</column>
      
      <column name="Country name">{.[name(.)='recipient-country']/narrative}</column>
      <column name="Country code">{.[name(.)='recipient-country']/@code}</column>
      <column name="Region name">{.[name(.)='recipient-region']/narrative}</column>
      <column name="Region code">{.[name()='recipient-region']/@code}</column>
      <column name="Region vocabulary">{@vocabulary[name(.)='recipient-region']}</column>
      <column name="Budget percentage" type="percentage">{@percentage}</column>
    </row>
  </xsl:template>

  <xsl:template match="sector">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title/narrative[1]}</column>
      
      <column name="Sector name">{narrative}</column>
      <column name="Sector vocabulary">{@vocabulary}</column>
      <column name="Sector vocabulary URI" style="co2">{@vocabulary-uri}</column>
      <column name="Sector code">{@code}</column>
      <column name="Budget percentage" type="percentage">{@percentage}</column>
    </row>
  </xsl:template>

  <xsl:template match="document-link">
    <row>
      <column name="IATI activity identifier" style="co3">{../iati-identifier}</column>
      <column name="Activity name" style="co4">{../title[1]}</column>
      <column name="Document title" style="co4">{title/narrative}</column>
      <column name="Document description" style="co4">{description/narrative}</column>
      <column name="Document language">{language/@code}</column>
      <column name="Document date" type="date">{document-date/@iso-date}</column>
      <column name="Category">{category/@code}</column>
      <column name="Web address" style="co4">{@url}</column>
      <column name="Format" style="co2">{@format}</column>
    </row>
  </xsl:template>

</xsl:stylesheet>
