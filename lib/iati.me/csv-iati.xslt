<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  exclude-result-prefixes="">

  <xsl:import href="../functx.xslt"/>

  <xsl:template match="csv">
    <iati-activities version="2.02" generated-datetime="2017-01-01T00:00:00" xml:lang="en">
      <xsl:apply-templates select="record"/>
    </iati-activities>
  </xsl:template>

  <xsl:template match="record">
    <iati-activity default-currency="EUR" hierarchy="1" humanitarian="false" last-updated-datetime="2017-01-01T00:00:00"
      merge:id="{entry[@name='IATI Identifier']}">
        <iati-identifier><xsl:value-of select="entry[@name='IATI Identifier']"/></iati-identifier>
        <reporting-org ref="" type="">
            <narrative></narrative>
        </reporting-org>
        <title>
            <narrative></narrative>
        </title>
        <description>
            <narrative></narrative>
        </description>
        <participating-org role="" type="" ref="" activity-id="">
            <narrative></narrative>
        </participating-org>
        <activity-status code=""/>
        <activity-date type="" iso-date="2017-01-01"/>
        <activity-scope code=""/>
        <budget status="" type="">
            <period-start iso-date="2017-01-01"/>
            <period-end iso-date="2017-01-01"/>
            <value value-date="2017-01-01" currency="EUR">0</value>
        </budget>
        <transaction humanitarian="false" ref="">
          <transaction-type code=""/>
          <transaction-date iso-date="2017-01-01"/>
          <value value-date="2017-01-01" currency="EUR">0</value>
          <description><narrative></narrative></description>
          <provider-org ref="" type="" provider-activity-id=""><narrative></narrative></provider-org>
          <receiver-org ref="" type="" receiver-activity-id=""><narrative></narrative></receiver-org>
          <disbursement-channel code=""/>
          <sector code="" vocabulary="" vocabulary-uri=""><narrative></narrative></sector>
          <recipient-country code=""><narrative></narrative></recipient-country>
          <recipient-region code="" vocabulary="" vocabulary-uri=""><narrative></narrative></recipient-region>
          <flow-type code=""/>
          <finance-type code=""/>
          <aid-type code=""/>
          <tied-status code=""/>
        </transaction>
        <document-link format="" url="">
            <title>
                <narrative></narrative>
            </title>
            <category code=""/>
        </document-link>
        <related-activity ref="" type=""/>
        <result type="" aggregation-status="false">
            <xsl:attribute name="merge:id"></xsl:attribute>
            <title>
                <narrative></narrative>
            </title>
            <description>
                <narrative></narrative>
            </description>
            <indicator measure="" ascending="true">
                <xsl:attribute name="merge:id"></xsl:attribute>
                <title>
                    <narrative></narrative>
                </title>
                <description>
                    <narrative></narrative>
                </description>
                <reference vocabulary="" code="" indicator-uri=""></reference>
                <baseline year="2017" value="0">
                    <comment>
                        <narrative></narrative>
                    </comment>
                </baseline>
                <period>
                    <period-start iso-date="2017-01-01"/>
                    <period-end iso-date="2017-01-01"/>
                    <target value="">
                        <location ref=""/>
                        <dimension name="" value=""/>

                        <comment>
                            <narrative></narrative>
                        </comment>
                    </target>
                    <actual value="">
                        <comment>
                            <narrative></narrative>
                        </comment>
                    </actual>

                </period>
            </indicator>
        </result>
    </iati-activity>

  </xsl:template>

</xsl:stylesheet>
