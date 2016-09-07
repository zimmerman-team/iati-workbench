<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activity" mode="rules" priority="1.1">

  <xsl:if test="not(starts-with(string(iati-identifier), reporting-org/@ref))">
    <iati-me:feedback type="warning" class="identifiers">
      The activity identifier usually begins with the organisation identifier
      of the reporting organisation.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="1.2">

  <xsl:if test="@ref != functx:trim(@ref)">
    <iati-me:feedback type="warning" class="identifiers">
      An organisation identifier should not start or end with spaces or
      newlines.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(@ref)">
    <iati-me:feedback type="info" class="identifiers">
      No organisation identifier is given.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@ref and not(
      matches(@ref, '^[0-9]{5}$') or
      matches(@ref, '^[A-Z]{2}(-.+)*$'))">
    <iati-me:feedback type="danger" class="identifiers" src="iati"
      href="http://iatistandard.org/202/organisation-identifiers/">
      The identifier does not conform to the organisation identifier standard.
    </iati-me:feedback>
  </xsl:if>

  <xsl:variable name="RegistrationAgency" select="replace(@ref, '([^-]+-[^-]+).*', '$1')"/>

  <xsl:if test="matches(@ref, '^.+-.+-') and
    matches($RegistrationAgency, '[a-z]')">
    <iati-me:feedback type="warning" class="identifiers">
      The registration agency part in an organisation identifier
      should be in uppercase.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@provider-activity-id=''">
    <iati-me:feedback type="warning" class="identifiers">
      The <code>provider-activity-id</code> attribute should not be empty but
      omitted if you don't have the activity identifier.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@receiver-activity-id=''">
    <iati-me:feedback type="warning" class="identifiers">
      The <code>receiver-activity-id</code> attribute should not be empty but
      omitted if you don't have the activity identifier.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
