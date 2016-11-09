<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="transaction[provider-org and receiver-org]" mode="rules" priority="7.1">

  <xsl:if test="provider-org/@provider-activity-id eq receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial">
      The <code>provider-activity-id</code> and
      <code>receiver-activity-id</code> are the same: financial flows should be between
      different activities.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
