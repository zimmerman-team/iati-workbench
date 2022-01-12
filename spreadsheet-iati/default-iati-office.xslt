<?xml version="1.0" encoding="UTF-8"?>
<!--  IATI workbench: produce and use IATI data
  Copyright (C) 2016-2022, drostan.org and data4development.org
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.
  
  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->  

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

  <xsl:template match="iati-organisations">
    <xsl:result-document method="xml" href="{$filebase}.organisation-budgets.fods">
      <xsl:variable name="data">
        <file>
          <xsl:apply-templates select="//total-budget"/>
          <xsl:apply-templates select="//recipient-country-budget"/>
          <xsl:apply-templates select="//recipient-region-budget"/>
          <xsl:apply-templates select="//recipient-org-budget"/>
        </file>
      </xsl:variable>
      <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
    </xsl:result-document>    

    <xsl:result-document method="xml" href="{$filebase}.organisation-documents.fods">
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
      
      <column name="General description" style="co4">{description[not(@type) or @type='1']/narrative[1]}</column>
      <column name="Main objectives and outcomes" style="co4">{description[@type='2']/narrative[1]}</column>
      <column name="Target group or reach" style="co4">{description[@type='3']/narrative[1]}</column>
      <column name="Background" style="co4">{description[@type='4']/narrative[1]}</column>
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
      <column name="Contact department" style="co2">{contact-info/department/narrative}</column>
      <column name="Contact person" style="co2">{contact-info/person-name/narrative}</column>
      <column name="Contact job title" style="co2">{contact-info/job-title/narrative}</column>
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
      
      <column name="Flow type">{flow-type/@code}</column>
      <column name="Finance type">{finance-type/@code}</column>
      <column name="Aid type">{aid-type/@code}</column>
      <column name="Aid type vocabulary">{aid-type/@vocabulary}</column>
      <column name="Tied status">{tied-status/@code}</column>
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
      <column name="Indicator reference">{reference/@code}</column>
      <column name="Indicator title" style="co4">{title/narrative}</column>
      <column name="Indicator description" style="co4">{description/narrative}</column>
      <column name="Ascending">{@ascending}</column>
      <column name="Baseline year">{baseline/@year}</column>
      <column name="Baseline" type="value">{baseline/@value}</column>
      <column name="Baseline comment" style="co4">{baseline/comment/narrative}</column>
      <column name="Start date" type="date"/>
      <column name="End date" type="date"/>
      <column name="Target" type="value"/>
      <column name="Target comment"/>
      <column name="Actual" type="value"/>
      <column name="Actual comment"/>
      <column name="Dimension 1 name">{baseline/dimension[1]/@name}</column>
      <column name="Dimension 1 value">{baseline/dimension[1]/@value}</column>
      <column name="Dimension 2 name">{baseline/dimension[2]/@name}</column>
      <column name="Dimension 2 value">{baseline/dimension[2]/@value}</column>
    </row>
    <xsl:apply-templates select="period"/>
  </xsl:template>

  <xsl:template match="period">
    <row>
      <column name="IATI activity identifier" style="co3">{../../../iati-identifier}</column>
      <column name="Activity name" style="co4">{../../../title/narrative[1]}</column>
      
      <column name="Result title" style="co4">{../../title/narrative}</column>
      <column name="Result description" style="co4">{../../description/narrative}</column>
      <column name="Result type">{../../@type}</column>
      <column name="Aggregation status">{../../@aggregation-status}</column>
      
      <column name="Indicator measure">{../@measure}</column>
      <column name="Indicator reference">{../reference/@code}</column>
      <column name="Indicator title" style="co4">{../title/narrative}</column>
      <column name="Indicator description" style="co4">{../description/narrative}</column>
      <column name="Ascending">{../@ascending}</column>
      <column name="Baseline year"/>
      <column name="Baseline" type="value"/>
      <column name="Baseline comment" style="co4"/>
      <column name="Start date" type="date">{period-start/@iso-date}</column>
      <column name="End date" type="date">{period-end/@iso-date}</column>
      <column name="Target" type="value">{target/@value}</column>
      <column name="Target comment">{target/comment}</column>
      <column name="Actual" type="value">{actual/@value}</column>
      <column name="Actual comment">{actual/comment}</column>
      <column name="Dimension 1 name">{actual/dimension[1]/@name}</column>
      <column name="Dimension 1 value">{actual/dimension[1]/@value}</column>
      <column name="Dimension 2 name">{actual/dimension[2]/@name}</column>
      <column name="Dimension 2 value">{actual/dimension[2]/@value}</column>
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

  <xsl:template match="iati-activity/document-link">
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

  <!-- Organisation budgets are all in the same format (can be a single file) -->
  <xsl:template match="total-budget|recipient-country-budget|recipient-region-budget|recipient-org-budget">
    <row>
      <column name="IATI organisation identifier" style="co3">{../organisation-identifier}</column>
      
      <column name="Budget status">{@status}</column>
      <column name="Budget start date" type="date">{period-start/@iso-date}</column>
      <column name="Budget end date" type="date">{period-end/@iso-date}</column>
      <column name="Currency">{value/@currency}</column>
      <column name="Budget" type="value">{value}</column>
      <column name="Value date" type="date">{value/@value-date}</column>
      <column name="Country code">{recipient-country/@code}</column>
      <column name="Region code">{recipient-region/@code}</column>
      <column name="Region name">{recipient-region/narrative[1]}</column>
      <column name="Region vocabulary">{recipient-region/@vocabulary}</column>
      <column name="Recipient organisation identifier">{recipient-region/@ref}</column>
      <column name="Recipient organisation name">{recipient-region/narrative[1]}</column>
    </row>
  </xsl:template>
  
  <xsl:template match="iati-organisation/document-link">
    <row>
      <column name="IATI organisation identifier" style="co3">{../organisation-identifier}</column>
      
      <column name="Recipient country code">{recipient-country/@code}</column>
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
