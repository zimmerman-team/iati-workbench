<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:variable name="orgs-not">
  <xsl:if test="doc-available('/workspace/config/policy.xml')">
    <xsl:copy-of select="doc('/workspace/config/policy.xml')/policy/exclusions/organisation"/>
  </xsl:if>
</xsl:variable>
<xsl:variable name="orgs-ok">
  <xsl:if test="doc-available('/workspace/config/policy.xml')">
    <xsl:copy-of select="doc('/workspace/config/policy.xml')/policy/inclusions/organisation"/>
  </xsl:if>
</xsl:variable>

<xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="200.1">
  <xsl:if test="@ref=($orgs-not/organisation/@ref)">
    <iati-me:feedback type="danger" class="exclusions" src="exclusions" id="200.1.1">
      The organisation identifier is on your exclusion policy list.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="narrative=($orgs-not/organisation/narrative)">
    <iati-me:feedback type="danger" class="exclusions" src="exclusions" id="200.1.2">
      The organisation name is on your exclusion policy list.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@ref=($orgs-ok/organisation/@ref)">
    <iati-me:feedback type="success" class="inclusions" src="inclusions" id="200.1.3">
      The organisation identifier is on your inclusion policy list.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
