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
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  xmlns:merge="http://iati.me/merge"
  xmlns:nuffic="http://iati.me/nuffic"
  exclude-result-prefixes="xs functx nuffic"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <!-- imported via spreadsheet-iati/csvxml-iati.xslt -->

  <!--  Transactions: Project Expenditures -->
  <xsl:template match="record[$file=>lower-case()=>contains('businessworld')]" mode="nuffic">
    <xsl:variable name="rawid">
      <xsl:choose>
        <xsl:when test="entry[@name='Subprogram (T)']='Masters'">{entry[@name=('External grant nu. ', 'External Grant number')]}</xsl:when>
        <xsl:when test="entry[@name='Subprogram (T)']='Short Courses'">{entry[@name=('External grant nu. ', 'External Grant number')]}</xsl:when>

        <xsl:when test="entry[@name='Subprogram (T)']='Tailor Made Training'">{entry[@name='Grant (T)']}</xsl:when>
        <xsl:when test="entry[@name='Subprogram (T)']='TMT+'">{entry[@name='Grant (T)']}</xsl:when>
        <xsl:when test="entry[@name='Subprogram (T)']='Institutional Collaboration Projects'">OKP-ICP-{entry[@name='External grant nu. ']}</xsl:when>
        <!-- to add: Refresher Course -->
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$rawid!=''">
      <xsl:variable name="date" select="merge:date(entry[@name='Trans.date'])"/>
      <xsl:variable name="type">
        <xsl:choose>
          <xsl:when test="entry[@name='Account (T)']='Projectsum'">2</xsl:when>
          <xsl:when test="entry[@name='Account (T)']='Expenses programmes'">3</xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$type!=''">
        <iati-activity merge:id="{nuffic:idfix($reporting-org || '-' || $rawid)}">
          <transaction ref="{entry[@name='TransNo']}">
            <transaction-type code="{$type}"/>
            <transaction-date iso-date="{$date}" />
            <value value-date="{$date}" currency="EUR">{merge:decimal(entry[@name='Amount'])}</value>
          </transaction>
        </iati-activity>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!--Activities: -->
  <xsl:template match="record[$file=>lower-case()=>contains('atlas')]" mode="nuffic">
    <!-- TODO: move into proper configuration -->
    <xsl:variable name="contact-email" select="'okp@nuffic.nl'"/>
    <xsl:variable name="contact-website" select="'https://www.nuffic.nl/en'"/>
    <xsl:variable name="contact-address" select="'P.O. Box 29777, 2502 LT The Hague, The Netherlands'"/>
    <xsl:variable name="default-currency" select="'EUR'"/>

    <xsl:variable name="linkname" select="entry[@name='Name'] || '-' || entry[@name='FinancialYear'] || '-' || merge:entry(., ('Organisation name', 'Organistaion name'))"/>
    <xsl:variable name="rawid" select="nuffic:idfix($reporting-org || '-' || $linkname)"/>
    <xsl:if test="true()">
      <iati-activity default-currency="EUR"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{lower-case(merge:entry(., 'Language', 'en'))}"
        merge:id="{nuffic:idfix($rawid)}">
        <iati-identifier>{nuffic:idfix($rawid)}</iati-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative>{$reporting-org-name}</narrative>
        </reporting-org>

        <contact-info type="1">
          <organisation>
            <narrative>{$reporting-org-name}</narrative>
          </organisation>
          <telephone>{merge:entry(., 'Contact telephone')}</telephone>
          <email>{$contact-email}</email>
          <website>{$contact-website}</website>
          <mailing-address>
            <narrative>{$contact-address}</narrative>
          </mailing-address>
        </contact-info>

        <title>
          <narrative>{($linkname, merge:entry(., ('Link met transacties', 'Activity name')))[1]}</narrative>
        </title>

        <description type="1">
          <narrative>{merge:entry(., ('Organisation name', 'Organistaion name', 'Activity name'))}</narrative>
        </description>

        <xsl:if test="$include-reporting-org-as-role=('1', '2', '3', '4')">
          <participating-org role="{$include-reporting-org-as-role}"
            type="{$reporting-org-type}"
            ref="{$reporting-org}">
            <narrative>{$reporting-org-name}</narrative>
          </participating-org>
        </xsl:if>

        <participating-org role="4" type="80">
          <narrative>{merge:entry(., ('Organisation name', 'Organistaion name'))}</narrative>
        </participating-org>

        <activity-status code="4"/>

        <activity-date type="1" iso-date="{merge:date(merge:entry(., 'Planned start date', ''))}"/>
        <activity-date type="2" iso-date="{merge:date(merge:entry(., 'Actual start date', ''))}"/>
        <activity-date type="3" iso-date="{merge:date(merge:entry(., 'Planned end date', ''))}"/>
        <activity-date type="4" iso-date="{merge:date(merge:entry(., 'Actual end date', ''))}"/>

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
        <recipient-country code="{merge:get-code-from-list('Country', merge:entry(., 'Country'))}">
          <narrative>{merge:entry(., 'Country')}</narrative>
        </recipient-country>

        <sector code="11420" vocabulary="1" percentage="100.0"/>

        <!-- Policy marker may be in the project file -->
        <xsl:if test="merge:entry(., 'Policy marker') != ''">
          <policy-marker significance="{merge:entry(., ('Policy significance', 'Significance'))}"
            code="{merge:entry(., 'Policy marker')}"
            vocabulary="1"/>
        </xsl:if>

          <related-activity ref="{nuffic:idfix($reporting-org || '-' || merge:entry(., 'Name'))}" type="1"/>

        <collaboration-type code="1"/>
        <default-flow-type code="30"/>
        <default-finance-type code="110"/>
        <default-aid-type code="C01"/>
        <default-tied-status code="5"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <!--Activities: -->
  <xsl:template match="record[$file=>lower-case()=>contains('delta')]" mode="nuffic">
    <xsl:variable name="contact-email" select="'okp@nuffic.nl'"/>
    <xsl:variable name="contact-website" select="'https://www.nuffic.nl/en'"/>
    <xsl:variable name="contact-address" select="'P.O. Box 29777, 2502 LT The Hague, The Netherlands'"/>
    <xsl:variable name="default-currency" select="'EUR'"/>

    <xsl:variable name="rawid" select="nuffic:idfix($reporting-org || '-' || entry[@name='Activity name'])"/>
    <xsl:if test="merge:entry(., 'Year')=>starts-with('202')">
      <iati-activity default-currency="EUR"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{lower-case(merge:entry(., 'Language', 'en'))}"
        merge:id="{nuffic:idfix($rawid)}">
        <iati-identifier>{nuffic:idfix($rawid)}</iati-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative>{$reporting-org-name}</narrative>
        </reporting-org>

        <contact-info type="1">
          <organisation>
            <narrative>{$reporting-org-name}</narrative>
          </organisation>
          <telephone>{merge:entry(., 'Contact telephone')}</telephone>
          <email>{$contact-email}</email>
          <website>{$contact-website}</website>
          <mailing-address>
            <narrative>{$contact-address}</narrative>
          </mailing-address>
        </contact-info>

        <title>
          <narrative>{merge:entry(., ('Name', 'Activity name'))}</narrative>
        </title>

        <description type="1">
          <narrative>{(merge:entry(., 'Organisation name'), merge:entry(., 'Name'))[1]}</narrative>
        </description>

        <xsl:if test="$include-reporting-org-as-role=('1', '2', '3', '4')">
          <participating-org role="{$include-reporting-org-as-role}"
            type="{$reporting-org-type}"
            ref="{$reporting-org}">
            <narrative>{$reporting-org-name}</narrative>
          </participating-org>
        </xsl:if>

        <participating-org role="4" type="80">
          <narrative>{merge:entry(., 'Organisation name')}</narrative>
        </participating-org>

        <xsl:variable name="status" select="merge:entry(., 'Activity status')"/>
        <xsl:choose>
          <xsl:when test="$status=('Selected')">
            <activity-status code="1"/>
          </xsl:when>
          <xsl:when test="$status=('Report pending', 'Report pending',
          'I-Report required', 'I-Report overdue', 'Assessing I-Report',
          'I-Report required', 'I-Report overdue', 'Assessing I-Report',
          'Approving draft settlement letter for I-Report')">
            <activity-status code="2"/>
          </xsl:when>
          <xsl:when test="$status=('F-Report required', 'F-Report overdue', 'Assessing F-Report',
          'F-Report required', 'F-Report overdue', 'Assessing F-Report', 'F-Report rejected',
          'Approving draft settlement letter for F-Report', 'Draft settlement letter rejected for F-Report')">
            <activity-status code="3"/>
          </xsl:when>
          <xsl:when test="$status=('Closed')">
            <activity-status code="4"/>
          </xsl:when>
          <xsl:when test="$status=('Withdrawn', 'Negatively decided')">
            <activity-status code="5"/>
          </xsl:when>
          <xsl:otherwise>
            <activity-status code="3"/>
          </xsl:otherwise>
        </xsl:choose>

        <activity-date type="1" iso-date="{merge:date(merge:entry(., 'Planned start date', ''))}"/>
        <activity-date type="2" iso-date="{merge:date(merge:entry(., 'Actual start date', ''))}"/>
        <activity-date type="3" iso-date="{merge:date(merge:entry(., 'Planned end date', ''))}"/>
        <activity-date type="4" iso-date="{merge:date(merge:entry(., 'Actual end date', ''))}"/>

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

        <recipient-country code="{merge:get-code-from-list('Country', merge:entry(., 'Country'))}">
          <narrative>{merge:entry(., 'Country')}</narrative>
        </recipient-country>

        <sector code="11420" vocabulary="1" percentage="100.0"/>

        <!-- Policy marker may be in the project file -->
        <xsl:if test="merge:entry(., 'Policy marker') != ''">
          <policy-marker significance="{merge:entry(., ('Policy significance', 'Significance'))}"
            code="{merge:entry(., 'Policy marker')}"
            vocabulary="1"/>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$rawid=>lower-case()=>contains('okp-ma')">
            <related-activity ref="{nuffic:idfix($reporting-org || '-OKP-MA')}" type="1"/>
          </xsl:when>
          <xsl:when test="$rawid=>lower-case()=>contains('okp-sc')">
            <related-activity ref="{nuffic:idfix($reporting-org || '-OKP-SC')}" type="1"/>
          </xsl:when>
        </xsl:choose>

        <collaboration-type code="1"/>
        <default-flow-type code="30"/>
        <default-finance-type code="110"/>
        <default-aid-type code="C01"/>
        <default-tied-status code="5"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <xsl:function name="nuffic:idfix">
    <xsl:param name="i"/>
    <xsl:text>{replace($i, "TMT.+TMT", "TMT")
      =>replace("OKP-TMT-","OKP-TMT.")
      =>replace("OKP/NFP","OKP")
      =>replace("(OKP-.*[0-9]{5}).*", "$1")
      =>replace("NL-KVK-41150085-NL-KVK-41150085-", "NL-KVK-41150085-")
      =>replace("[ ,()]", "-")
      =>replace("--", "-")
      =>replace("-$", "")
      =>replace("\+", "PLUS")
      =>replace("41150085[0-9]+", "41150085")
      =>replace("TMT-[0-9]{4}-call-[0-9]", "TMT")
      =>substring(1,71)}</xsl:text>
  </xsl:function>
</xsl:stylesheet>
