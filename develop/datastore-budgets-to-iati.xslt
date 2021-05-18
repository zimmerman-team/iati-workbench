<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:me="http://iati.me/activities/2.03"
  exclude-result-prefixes="xs math xd"
  expand-text="yes"
  version="3.0">
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:output indent="yes"/>
  
  <xsl:template match="/">
    <iati-activities>
      <xsl:apply-templates select="response/result/doc"/>
    </iati-activities>
  </xsl:template>
  
  <xsl:template match="doc">
    <iati-activity me:act-id="{str[@name='iati_identifier']}"
      me:org-id="{str[@name='reporting_org_ref']}">
      <budget type="{str[@name='budget_type']}" status="{str[@name='budget_status']}">
        <period-start iso-date="{str[@name='budget_period_start_iso_date']}" />
        <period-end iso-date="{str[@name='budget_period_end_iso_date']}" />
        <value currency="{str[@name='budget_value_currency']}" 
          value-date="{str[@name='budget_value_date']}">{str[@name='budget_value']}</value>
        <value-usd conversion_rate="{str[@name='budget_usd_conversion_rate']}">{str[@name='budget_value_usd']}</value-usd>
      </budget>
    </iati-activity>
  </xsl:template>
</xsl:stylesheet>