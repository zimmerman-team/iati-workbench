<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activity" mode="rules" priority="1.1">

  <xsl:if test="not(starts-with(string(iati-identifier), reporting-org/@ref))">
    <iati-me:feedback type="warning" class="identifiers">
      <iati-me:message>
        The activity identifier usually begins with the organisation identifier
        of the reporting organisation.
      </iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="1.2">

  <xsl:if test="@ref != functx:trim(@ref)">
    <iati-me:feedback type="warning" class="identifiers">
      <iati-me:message>
        An organisation identifier should not start or end with spaces or
        newlines.
      </iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:variable name="RegistrationAgency" select="replace(@ref, '([^-]+-[^-]+).*', '$1')"/>

  <xsl:if test="matches($RegistrationAgency, '[a-z]')">
    <iati-me:feedback type="warning" class="identifiers">
      <iati-me:message>
        The organisation registration agency part in an organisation identifier
        should be in uppercase.
      </iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
