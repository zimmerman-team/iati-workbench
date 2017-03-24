<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activities" mode="rules" priority="100.1">

  <xsl:if test="not(//transaction[transaction-type/@code='11'
    and provider-org/@ref='XM-DAC-7'
    and provider-org/@provider-activity-id])">

    <iati-me:feedback type="warning" class="traceability" src="minbuza" id="100.1.1">
      Include at least one activity with a transaction
      of type <code>11</code> (incoming commitment) that refers to the
      Ministry (<code>XM-DAC-7</code>) as the provider, and that refers to
      a specific activity identifier of the Ministry.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="iati-activity" mode="rules" priority="100.2">

  <xsl:if test="not(//@provider-activity-id
    or //@receiver-org-activity
    or participating-org/@activity-id
    or related-activity/@ref)">
    <iati-me:feedback type="info" class="traceability" src="minbuza" id="100.2.1">
      An activity should contain links to other activities,
      for instance to indicate where funding comes from or goes to, or how it
      relates to overarching programmes or underlying projects.
      This helps understand the complete flow, and prevent double
      counting.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
