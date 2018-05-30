<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  exclude-result-prefixes="xs"
  expand-text="yes"
  version="3.0">
  
  <xsl:variable name="file"/>
  <xsl:variable name="reporting-org"/>
  <xsl:variable name="reporting-org-type"/>
  
  <!--Activities: -->
  <xsl:template match="record[starts-with($file, 'Projects')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'], $reporting-org) and not(merge:boolean(entry[@name='Exclusion applies?']))">
      <iati-activity default-currency="{entry[@name='Currency']}"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{(entry[@name='Language'],'en')[1]}"
        merge:id="{entry[@name='IATI activity identifier']}">
        <iati-identifier>{entry[@name='IATI activity identifier']}</iati-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative>{$reporting-org-name}</narrative>
        </reporting-org>
        <contact-info type="{entry[@name='Contact info type']}">
          <organisation>
            <narrative>{entry[@name='Contact info organisation']}</narrative>
          </organisation>
          <telephone>{entry[@name='Contact telephone']}</telephone>
          <email>{entry[@name='Contact email']}</email>
          <website>{entry[@name='Contact website']}</website>
          <mailing-address>{entry[@name='Contact mailing address']}</mailing-address>
        </contact-info>
        
        <title>
          <narrative>{entry[@name='Activity name']}</narrative>
        </title>
        
        <description type="1">
          <narrative>{entry[@name='General description']}</narrative>
        </description>
        <description type="2">
          <narrative>{entry[@name='Main objectives and outcomes']}</narrative>
        </description>
        <description type="3">
          <narrative>{entry[@name='Targetgroup or reach']}</narrative>
        </description>
        <description type="4">
          <narrative>{entry[@name='Background']}</narrative>
        </description>
        
        <activity-status code="{entry[@name='Activity status']}"/>
        <activity-date type="1" iso-date="{merge:date(entry[@name='Planned start date'])}"/>
        <activity-date type="2" iso-date="{merge:date(entry[@name='Actual start date'])}"/>
        <activity-date type="3" iso-date="{merge:date(entry[@name='Planned end date'])}"/>
        <activity-date type="4" iso-date="{merge:date(entry[@name='Actual end date'])}"/>
        
        <activity-scope code="{entry[@name='Activity scope']}"/>
        
        <!-- Budget may be in the project file -->
        <xsl:if test="entry[@name='Total Budget'] != ''">
          <budget status="1" type="1">
            <xsl:variable name="start-date">
              <xsl:choose>
                <xsl:when test="entry[@name='Actual start date']!=''">{entry[@name='Actual start date']}</xsl:when>
                <xsl:otherwise>{entry[@name='Planned start date']}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="end-date">
              <xsl:choose>
                <xsl:when test="entry[@name='Actual end date']!=''">{entry[@name='Actual end date']}</xsl:when>
                <xsl:otherwise>{entry[@name='Planned end date']}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <period-start iso-date="{merge:date($start-date)}"/>
            <period-end iso-date="{merge:date($end-date)}"/>
            <value value-date="{merge:date($start-date)}" currency="EUR">{merge:decimal(entry[@name='Total Budget'])}</value>
          </budget>
        </xsl:if>
        
        <!-- Policy marker may be in the project file -->
        <xsl:if test="entry[@name='Policy marker'] != ''">
          <policy-marker significance="{entry[@name='Policy significance']}"
            code="{entry[@name='Policy marker']}"
            vocabulary="1"/>
        </xsl:if>
        
        <related-activity ref="{entry[@name='IATI parent activity identifier']}" type="1"/>
        
        <collaboration-type code="{entry[@name='Collaboration type']}"/>
        <default-flow-type code="{entry[@name='Default flow type']}"/>
        <default-finance-type code="{entry[@name='Default finance type']}"/>
        <default-aid-type code="{entry[@name='Default aid type']}"/>
        <default-tied-status code="{entry[@name='Default tied status']}"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <!--  Budgets: -->
  <xsl:template match="record[starts-with($file, 'Budgets')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <budget status="{entry[@name='Budget status']}" type="{entry[@name='Budget type']}">
          <period-start iso-date="{merge:date(entry[@name='Budget start date'])}"/>
          <period-end iso-date="{merge:date(entry[@name='Budget end date'])}"/>
          <value value-date="{merge:date(entry[@name='Value date'])}" currency="{entry[@name='Currency']}">{merge:decimal(entry[@name='Budget'])}</value>
        </budget>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Policy markers: -->
  <xsl:template match="record[starts-with($file, 'Policy')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <policy-marker significance="{entry[@name='Significance']}" code="{entry[@name='Policy marker']}" vocabulary="1"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Sectors: -->
  <xsl:template match="record[starts-with($file, 'Sectors')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <sector percentage="{merge:decimal(entry[@name='Budget percentage'])}" code="{entry[@name='Sector code']}" vocabulary="1">
          <narrative>{entry[@name='Sector name']}</narrative>
        </sector>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Transactions: -->
  <xsl:template match="record[starts-with($file, 'Transactions')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <transaction ref="{entry[@name='Reference']}">
          <transaction-type code="{entry[@name=('Type', 'Transaction Type Code')]}"/>
          <transaction-date iso-date="{merge:date(entry[@name='Date'])}" />
          <value value-date="{(merge:date(entry[@name='Value date']), merge:date(entry[@name='Date']))[1]}" currency="{entry[@name='Currency']}">{merge:decimal(entry[@name=('Amount', ' Amount ')])}</value>
          <description>
            <narrative>{entry[@name='Description']}</narrative>
          </description>
          <xsl:if test="entry[@name='Provider organisation']!='' or entry[@name='Provider organisation identifier']!=''">
            <provider-org ref="{entry[@name='Provider organisation identifier']}" provider-activity-id="{entry[@name='Provider activity identifier']}" type="{entry[@name='Provider organisation type']}">
              <narrative>{entry[@name='Provider organisation']}</narrative>
            </provider-org>            
          </xsl:if>
          <xsl:if test="entry[@name='Receiver organisation']!='' or entry[@name='Receiver organisation identifier']!=''">
            <receiver-org ref="{entry[@name='Receiver organisation identifier']}" receiver-activity-id="{entry[@name='Receiver activity identifier']}" type="{entry[@name='Receiver organisation type']}">
              <narrative>{entry[@name='Receiver organisation']}</narrative>
            </receiver-org>
          </xsl:if>
        </transaction>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Results: -->
  <xsl:template match="record[starts-with($file, 'Results')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <result
          type="{entry[@name='Result type']}"
          merge:id="{entry[@name='Result title']}">
          <xsl:if test="entry[@name='Aggregation status'] != ''"><xsl:attribute name="aggregation-status">{merge:boolean(entry[@name='Aggregation status'])}</xsl:attribute></xsl:if>
          <title>
            <narrative>{entry[@name='Result title']}</narrative>
          </title>
          <description>
            <narrative>{entry[@name='Result description']}</narrative>
          </description>
          
          <indicator
            merge:id="{entry[@name='Indicator title']}"
            measure="{entry[@name='Indicator measure']}">
            <!--ascending="true">-->
            <xsl:if test="entry[@name='Indicator reference']!=''">
              <reference vocabulary="99" code="{entry[@name='Indicator reference']}"/>
            </xsl:if>
            
            <title>
              <narrative>{entry[@name='Indicator title']}</narrative>
            </title>
            <description>
              <narrative>{entry[@name='Indicator description']}</narrative>
            </description>
            
            <xsl:if test="entry[@name='Baseline year']!=''">
              <baseline year="{entry[@name='Baseline year']}" value="{merge:decimal(entry[@name='Baseline'])}">
                <comment>
                  <narrative>{entry[@name='Baseline comment']}</narrative>
                </comment>
              </baseline>
            </xsl:if>
            
            <xsl:if test="entry[@name='Start date']!=''">
              <period>
                <period-start iso-date="{merge:date(entry[@name='Start date'])}"/>
                <period-end iso-date="{merge:date(entry[@name='End date'])}"/>
                <xsl:if test="entry[@name='Target']!=''">
                  <target value="{merge:decimal(entry[@name='Target'])}">
                    <comment>
                      <narrative>{entry[@name="Target comment"]}</narrative>
                    </comment>
                  </target>
                </xsl:if>
                <xsl:if test="entry[@name='Actual']!=''">
                  <actual value="{merge:decimal(entry[@name='Actual'])}">
                    <comment>
                      <narrative>{entry[@name='Actual comment']}</narrative>
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
  
  <!--  Geo: -->
  <xsl:template match="record[starts-with($file, 'Countries')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <xsl:choose>
          <xsl:when test="entry[@name='Country code']!=''">
            <recipient-country code="{entry[@name='Country code']}" percentage="{merge:decimal(entry[@name='Budget percentage'])}">
              <xsl:if test="entry[@name='Country name']!=''">
                <narrative>{entry[@name='Country name']}</narrative>
              </xsl:if>
            </recipient-country>
          </xsl:when>
          <xsl:when test="entry[@name='Region code']!=''">
            <recipient-region code="{entry[@name='Region code']}" percentage="{merge:decimal(entry[@name='Budget percentage'])}">
              <xsl:if test="entry[@name='Region name']!=''">
                <narrative>{entry[@name='Region name']}</narrative>
              </xsl:if>
            </recipient-region>
          </xsl:when>          
        </xsl:choose>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  
  <!--  Participating: -->
  <xsl:template match="record[starts-with($file, 'Participating')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'][1], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <participating-org role="{entry[@name='Role']}" type="{entry[@name='Type']}" ref="{entry[@name='Organisation identifier']}" activity-id="{entry[@name='Activity identifier']}">
          <narrative>{entry[@name='Organisation name']}</narrative>
        </participating-org>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Documents: -->
  <xsl:template match="record[starts-with($file, 'Documents') or ends-with($file, 'Documents')]">
    <xsl:if test="starts-with(entry[@name='IATI activity identifier'], $reporting-org)">
      <iati-activity merge:id="{entry[@name='IATI activity identifier']}">
        <document-link format="{entry[@name='Format']}" url="{entry[@name='Web address']}">
          <title>
            <narrative><xsl:value-of select="entry[@name='Document title']"/></narrative>
          </title>
          <description>
            <narrative><xsl:value-of select="entry[@name='Document description']"/></narrative>
          </description>
          <category code="{entry[@name='Category']}"/>
          <xsl:if test="entry[@name='Document language']!=''">
            <language code="{entry[@name='Document language']}" />
          </xsl:if>
          <document-date iso-date="{merge:date(entry[@name='Document date'])}" />
        </document-link>
      </iati-activity>          
    </xsl:if>
  </xsl:template>  
</xsl:stylesheet>