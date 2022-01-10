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
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  xmlns:merge="http://iati.me/merge"
  expand-text="yes"
  exclude-result-prefixes="xs functx">
  
  <xsl:output indent="yes"/>

  <xsl:variable name="file"/>
  <xsl:variable name="reporting-org"/>
  <xsl:variable name="reporting-org-type"/>
  <xsl:variable name="reporting-org-name"/>
  <xsl:variable name="include-reporting-org-as-role"/>
  <xsl:variable name="default-participating-role"/>
  
  <xsl:include href="default-templates-org.xsl"/>
  
  <!--Activities: -->
  <xsl:template match="record[contains(lower-case($file), 'projects')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI Activity Identifier'), $reporting-org) and not(merge:boolean(merge:entry(., 'Exclusion applies?')))">
      <xsl:variable name="lang" select="lower-case(merge:entry(., 'Language', 'en'))"/>
      <iati-activity default-currency="{merge:entry(., 'Currency')}"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{$lang}"
        merge:id="{merge:entry(., 'IATI activity identifier')}">
        <xsl:if test="functx:trim(merge:entry(., 'Humanitarian activity'))!=''">
          <xsl:attribute name="humanitarian" select="merge:boolean(merge:entry(., 'Humanitarian activity'))"/>
        </xsl:if>
        <iati-identifier>{merge:entry(., 'IATI activity identifier')}</iati-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative xml:lang="{$lang}">{$reporting-org-name}</narrative>
        </reporting-org>
        <contact-info type="{merge:entry(., 'Contact info type')}">
          <organisation>
            <narrative xml:lang="{$lang}">{merge:entry(., 'Contact info organisation')}</narrative>
          </organisation>
          <department>
            <narrative xml:lang="{$lang}">{merge:entry(., 'Contact department')}</narrative>
          </department>
          <person-name>
            <narrative xml:lang="{$lang}">{merge:entry(., 'Contact person')}</narrative>
          </person-name>
          <job-title>
            <narrative xml:lang="{$lang}">{merge:entry(., 'Contact job title')}</narrative>
          </job-title>
          <telephone>{merge:entry(., 'Contact telephone')}</telephone>
          <email>{merge:entry(., 'Contact email')}</email>
          <website>{merge:entry(., 'Contact website')}</website>
          <mailing-address>
            <narrative xml:lang="{$lang}">{merge:entry(., 'Contact mailing address')}</narrative>
          </mailing-address>
        </contact-info>
        
        <title>
          <narrative xml:lang="{$lang}">{merge:entry(., 'Activity name')}</narrative>
        </title>
        
        <description type="1">
          <narrative xml:lang="{$lang}">{merge:entry(., 'General description', 'n/a')}</narrative>
        </description>
        <description type="2">
          <narrative xml:lang="{$lang}">{merge:entry(., 'Main objectives and outcomes')}</narrative>
        </description>
        <description type="3">
          <narrative xml:lang="{$lang}">{merge:entry(., ('Target group or reach', 'Targetgroup or reach'))}</narrative>
        </description>
        <description type="4">
          <narrative xml:lang="{$lang}">{merge:entry(., 'Background')}</narrative>
        </description>
        
        <xsl:if test="$include-reporting-org-as-role=('1', '2', '3', '4')">
          <participating-org role="{$include-reporting-org-as-role}"
            type="{$reporting-org-type}"
            ref="{$reporting-org}">
            <narrative xml:lang="{$lang}">{$reporting-org-name}</narrative>
          </participating-org>          
        </xsl:if>
        
        <activity-status code="{(merge:entry(., 'Activity status'), '2')[1]}"/>
        <activity-date type="1" iso-date="{merge:date(merge:entry(., 'Planned start date', ''))}"/>
        <activity-date type="2" iso-date="{merge:date(merge:entry(., 'Actual start date', ''))}"/>
        <activity-date type="3" iso-date="{merge:date(merge:entry(., 'Planned end date', ''))}"/>
        <activity-date type="4" iso-date="{merge:date(merge:entry(., 'Actual end date', ''))}"/>
        
        <activity-scope code="{merge:entry(., 'Activity scope')}"/>
        
        <!-- Budget may be in the project file -->
        <xsl:if test="merge:entry(., ('Budget', 'Total Budget')) != ''">
          <budget status="{merge:entry(., 'Budget status', '1')}" type="{merge:entry(., 'Budget type', '1')}">
            <xsl:variable name="start-date">
              <xsl:choose>
                <xsl:when test="merge:entry(., 'Budget start date')!=''">{merge:entry(., 'Budget start date')}</xsl:when>
                <xsl:when test="merge:entry(., 'Actual start date')!=''">{merge:entry(., 'Actual start date')}</xsl:when>
                <xsl:otherwise>{merge:entry(., 'Planned start date')}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="end-date">
              <xsl:choose>
                <xsl:when test="merge:entry(., 'Budget end date')!=''">{merge:entry(., 'Budget end date')}</xsl:when>
                <xsl:when test="merge:entry(., 'Actual end date')!=''">{merge:entry(., 'Actual end date')}</xsl:when>
                <xsl:otherwise>{merge:entry(., 'Planned end date')}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <period-start iso-date="{merge:date($start-date)}"/>
            <period-end iso-date="{merge:date($end-date)}"/>
            <value value-date="{merge:date($start-date)}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Amount')), 'EUR')[1]}">{merge:currency-value(merge:entry(., ('Budget', 'Total Budget')))}</value>
          </budget>
        </xsl:if>
        
        <xsl:if test="functx:trim(merge:entry(., 'Humanitarian scope type 1'))!=''">
          <humanitarian-scope type="{functx:trim(merge:entry(., 'Humanitarian scope type 1'))}" 
            vocabulary="{merge:entry(., 'Humanitarian vocabulary 1')}" 
            code="{merge:entry(., 'Humanitarian code 1')}"/>
        </xsl:if>        
        
        <xsl:if test="functx:trim(merge:entry(., 'Humanitarian scope type 2'))!=''">
          <humanitarian-scope type="{functx:trim(merge:entry(., 'Humanitarian scope type 2'))}" 
            vocabulary="{merge:entry(., 'Humanitarian vocabulary 2')}" 
            code="{merge:entry(., 'Humanitarian code 2')}"/>
        </xsl:if>        
        
        <!-- Policy marker may be in the project file -->
        <xsl:if test="merge:entry(., 'Policy marker') != ''">
          <policy-marker significance="{merge:entry(., ('Policy significance', 'Significance'))}"
            code="{merge:entry(., 'Policy marker')}"
            vocabulary="1"/>
        </xsl:if>
        
        <related-activity ref="{merge:entry(., 'IATI parent activity identifier')}" type="1"/>
        
        <collaboration-type code="{merge:entry(., 'Collaboration type')}"/>
        <default-flow-type code="{merge:entry(., 'Default flow type')}"/>
        <default-finance-type code="{merge:entry(., 'Default finance type')}"/>
        <default-aid-type code="{merge:entry(., 'Default aid type')}"/>
        <default-tied-status code="{merge:entry(., 'Default tied status')}"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <!--  Budgets: -->
  <xsl:template match="record[contains(lower-case($file), 'budgets')
    and not(contains(lower-case($file), 'organisation-budgets'))]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <budget status="{merge:entry(., 'Budget status')}" type="{merge:entry(., 'Budget type')}">
          <period-start iso-date="{merge:date(merge:entry(., 'Budget start date'))}"/>
          <period-end iso-date="{merge:date(merge:entry(., 'Budget end date'))}"/>
          <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Budget start date')))[1]}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Budget')))[1]}">{merge:currency-value(merge:entry(., 'Budget'))}</value>
        </budget>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Policy markers: -->
  <xsl:template match="record[contains(lower-case($file), 'policy')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <policy-marker significance="{merge:entry(., ('Significance', 'Policy significance'))}" code="{merge:entry(., 'Policy marker')}" vocabulary="1"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Sectors: -->
  <xsl:template match="record[contains(lower-case($file), 'sectors')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier'), $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <sector percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}" code="{merge:entry(., 'Sector code')}" vocabulary="{(merge:entry(., ('Sector vocabulary', 'Sector vocabulaire')))[1]}">
          <narrative>{merge:entry(., 'Sector name')}</narrative>
        </sector>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Transactions: -->
  <xsl:template match="record[contains(lower-case($file), 'transactions')]">
    <xsl:if test="starts-with(merge:entry(., ['IATI activity identifier', 'IATI identifier'])[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., ['IATI activity identifier', 'IATI identifier'])}">
        <transaction ref="{merge:entry(., 'Reference')}">
          <transaction-type code="{entry[@name=('Type', 'Transaction Type Code')]}"/>
          <transaction-date iso-date="{merge:date(merge:entry(., 'Date'))}" />
          <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Date')))[1]}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Amount')))[1]}">{merge:currency-value(merge:entry(., 'Amount'))}</value>
          <description>
            <narrative>{merge:entry(., 'Description')}</narrative>
          </description>
          <xsl:if test="merge:entry(., 'Provider organisation')!='' or merge:entry(., 'Provider organisation identifier')!=''">
            <provider-org ref="{merge:entry(., ('Provider organisation identifier', 'Provider organization identifier'))}" provider-activity-id="{merge:entry(., 'Provider activity identifier')}" type="{merge:entry(., ('Provider organisation type', 'Provider organization type'))}">
              <narrative>{merge:entry(., 'Provider organisation')}</narrative>
            </provider-org>            
          </xsl:if>
          <xsl:if test="merge:entry(., 'Receiver organisation')!='' or merge:entry(., 'Receiver organisation identifier')!=''">
            <receiver-org ref="{merge:entry(., ('Receiver organisation identifier', 'Receiver organization identifier'))}" receiver-activity-id="{merge:entry(., 'Receiver activity identifier')}" type="{merge:entry(., ('Receiver organisation type', 'Receiver organization type'))}">
              <narrative>{merge:entry(., 'Receiver organisation')}</narrative>
            </receiver-org>
          </xsl:if>
          <xsl:if test="merge:entry(., 'Flow type')!=''">
            <flow-type code="{merge:entry(., 'Flow type')}"/>
          </xsl:if>
          <xsl:if test="merge:entry(., 'Finance type')!=''">
            <finance-type code="{merge:entry(., 'Finance type')}"/>
          </xsl:if>
          <xsl:if test="merge:entry(., 'Aid type')!=''">
            <aid-type code="{merge:entry(., 'Aid type')}" vocabulary="{merge:entry(., 'Aid type vocabulary')}"/>
          </xsl:if>
          <xsl:if test="merge:entry(., 'Tied status')!=''">
            <tied-status code="{merge:entry(., 'Tied status')}"/>
          </xsl:if>
        </transaction>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Results: -->
  <xsl:template match="record[contains(lower-case($file), 'results')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <result
          type="{merge:entry(., 'Result type')}"
          merge:id="{merge:entry(., 'Result reference')}---{merge:entry(., 'Result title')}">
          <xsl:if test="merge:entry(., 'Aggregation status') != ''"><xsl:attribute name="aggregation-status">{merge:boolean(merge:entry(., 'Aggregation status'))}</xsl:attribute></xsl:if>
          <title>
            <narrative>{merge:entry(., 'Result title')}</narrative>
          </title>
          <description>
            <narrative>{merge:entry(., 'Result description')}</narrative>
          </description>
          
          <indicator
            merge:id="{merge:entry(., 'Indicator reference')}---{merge:entry(., 'Indicator title')}"
            measure="{merge:entry(., 'Indicator measure')}">
            <xsl:if test="merge:entryExists(., 'Ascending')">
              <xsl:attribute name="ascending" select="merge:boolean(merge:entry(., 'Ascending'))"/>
            </xsl:if>
            <xsl:if test="merge:entry(., 'Indicator reference')!=''">
              <reference vocabulary="99" code="{merge:entry(., 'Indicator reference')}"/>
            </xsl:if>
            
            <title>
              <narrative>{merge:entry(., 'Indicator title')}</narrative>
            </title>
            <description>
              <narrative>{merge:entry(., 'Indicator description')}</narrative>
            </description>
            
            <xsl:if test="merge:entry(., 'Baseline year')!=''">
              <baseline year="{merge:entry(., 'Baseline year')}" value="{merge:decimal(merge:entry(., 'Baseline'))}"
                merge:id="{merge:entry(., 'Baseline year')}--{merge:entry(., 'Baseline')}-1-{merge:entry(., 'Dimension 1 name')}--{merge:entry(., 'Dimension 1 value')}-2-{merge:entry(., 'Dimension 2 name')}--{merge:entry(., 'Dimension 2 value')}">
                <xsl:apply-templates select="." mode="locations"/>
                <xsl:apply-templates select="." mode="dimensions"/>
                <comment>
                  <narrative>{merge:entry(., 'Baseline comment')}</narrative>
                </comment>
              </baseline>
            </xsl:if>
            
            <xsl:if test="merge:entry(., 'Start date')!=''">
              <period>
                <period-start iso-date="{merge:date(merge:entry(., ('Period Start date', 'Start Date')))}"/>
                <period-end iso-date="{merge:date(merge:entry(., ('Period End date', 'End Date')))}"/>
                <xsl:if test="merge:entry(., 'Target')!='' or merge:entry(., 'Target comment')!=''">
                  <target value="{merge:decimal(merge:entry(., 'Target'))}">
                    <xsl:apply-templates select="." mode="locations"/>
                    <xsl:apply-templates select="." mode="dimensions"/>
                    <comment>
                      <narrative>{merge:entry(., 'Target comment')}</narrative>
                    </comment>
                  </target>
                </xsl:if>
                <xsl:if test="merge:entry(., 'Actual')!='' or merge:entry(., 'Actual comment')">
                  <actual value="{merge:decimal(merge:entry(., 'Actual'))}">
                    <xsl:apply-templates select="." mode="locations"/>
                    <xsl:apply-templates select="." mode="dimensions"/>
                    <comment>
                      <narrative>{merge:entry(., 'Actual comment')}</narrative>
                    </comment>
                  </actual>
                </xsl:if>
              </period>
            </xsl:if>
          </indicator>
        </result>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="dimensions">
    <xsl:if test="merge:entry(., 'Dimension 1 name')!=''">
      <dimension name="{merge:entry(., 'Dimension 1 name')}" value="{merge:entry(., 'Dimension 1 value')}"/>
    </xsl:if>
    <xsl:if test="merge:entry(., 'Dimension 2 name')!=''">
      <dimension name="{merge:entry(., 'Dimension 2 name')}" value="{merge:entry(., 'Dimension 2 value')}"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="locations">
    <xsl:if test="merge:entry(., 'Location reference')!=''">
      <location ref="{merge:entry(., 'Location reference')}"/>
    </xsl:if>
  </xsl:template>
    
  <!--  Geo: -->
  <xsl:template match="record[contains(lower-case($file), 'countries')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <xsl:choose>
          <xsl:when test="merge:entry(., 'Country code')!=''">
            <recipient-country code="{merge:entry(., 'Country code')}" percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}">
              <xsl:if test="merge:entry(., 'Country name')!=''">
                <narrative>{merge:entry(., 'Country name')}</narrative>
              </xsl:if>
            </recipient-country>
          </xsl:when>
          <xsl:when test="merge:entry(., 'Region code')!=''">
            <recipient-region code="{merge:entry(., 'Region code')}" percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}">
              <xsl:if test="merge:entry(., 'Region name')!=''">
                <narrative>{merge:entry(., 'Region name')}</narrative>
              </xsl:if>
            </recipient-region>
          </xsl:when>          
        </xsl:choose>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  
  <!--  Participating: -->
  <xsl:template match="record[contains(lower-case($file), 'participating')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <participating-org role="{merge:entry(., ('Role', 'Organisation Role'), $default-participating-role)}" 
          type="{merge:entry(., ('Type', 'Organisation Type'))}" ref="{merge:entry(., 'Organisation identifier')}" activity-id="{merge:entry(., 'Activity identifier')}">
          <narrative>{merge:entry(., 'Organisation name')}</narrative>
        </participating-org>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Location: -->
  <xsl:template match="record[contains(lower-case($file), 'location')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <location ref="{merge:entry(., 'Location reference')}">
          <location-reach code="{merge:entry(., 'Reach')}"/>
          <location-id vocabulary="{merge:entry(., 'Location id vocabulary')}" code="{merge:entry(., 'Location id code')}"/>
          <name>
            <narrative>{merge:entry(., 'Location name')}</narrative>
          </name>
          <description>
            <narrative>{merge:entry(., 'Location description')}</narrative>
          </description>
          <activity-description>
            <narrative>{merge:entry(., 'Activity description')}</narrative>
          </activity-description>
          <administrative vocabulary="{(merge:entry(., 'Administrative level vocabulary'), 'A4')[1]}" 
            level="{(merge:entry(., 'Administrative level'), '1')[1]}" 
            code="{(merge:entry(., 'Administrative level code'), merge:entry(., 'Location admin country'))[1]}" />
          <point srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <pos>{merge:entry(., 'Latitude')} {merge:entry(., 'Longitude')}</pos>
          </point>
          <exactness code="{merge:entry(., 'Exactness')}"/>
          <feature-designation code="{merge:entry(., 'Location type code')}"/>
        </location>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Documents: -->
  <xsl:template match="record[contains(lower-case($file), 'documents')
    and not(contains(lower-case($file), 'organisation-documents'))]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier'), $reporting-org)">
      
      <!-- Replace Google Drive sharing links (open a preview page) with direct download links -->
      <xsl:variable name="url" select="replace(
        replace(merge:entry(., 'Web address'), 
          '^https://drive.google.com/open\?id=(.+)', 
          'https://drive.google.com/uc?export=download&amp;id=$1'),
        
        '^https://drive.google.com/file/d/(.+)/view\?usp=sharing', 
        'https://drive.google.com/uc?export=download&amp;id=$1')"/>

      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <document-link format="{merge:format(merge:entry(., 'Format'))}" url="{$url}">
          <title>
            <narrative>
              <xsl:if test="merge:entry(., 'Document language')!=''">
                <xsl:attribute name="xml:lang" select="lower-case(merge:entry(., 'Document language'))"/>
              </xsl:if>
              <xsl:value-of select="merge:entry(., 'Document title')"/>
            </narrative>
          </title>
          <description>
            <narrative>
              <xsl:if test="merge:entry(., 'Document language')!=''">
                <xsl:attribute name="xml:lang" select="lower-case(merge:entry(., 'Document language'))"/>
              </xsl:if>
              <xsl:value-of select="merge:entry(., 'Document description')"/>
            </narrative>
          </description>
          <category code="{merge:entry(., 'Category')}"/>
          <xsl:if test="merge:entry(., 'Document language')!=''">
            <language code="{lower-case(merge:entry(., 'Document language'))}" />
          </xsl:if>
          <xsl:if test="merge:entry(., 'Document date')!=''">
            <document-date iso-date="{merge:date(merge:entry(., 'Document date'))}" />
          </xsl:if>
        </document-link>
      </iati-activity>          
    </xsl:if>
  </xsl:template>  
  
  <!--  Related: -->
  <xsl:template match="record[contains(lower-case($file), 'related')]">
    <xsl:if test="starts-with(merge:entry(., 'From IATI activity identifier'), $reporting-org)">
      <iati-activity merge:id="{merge:entry(., ('From IATI activity identifier'))}">
        <related-activity ref="{merge:entry(., ('To IATI activity identifier'))}" 
          type="{merge:entry(., ('Type'))}"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>