<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activity" mode="rules" priority="3.1">

  <xsl:if test="count(recipient-country|recipient-region) > 1">
    <xsl:if test="sum((recipient-country|recipient-region)/@percentage) != 100">
      <iati-me:feedback type="danger" class="geo">
        <iati-me:message>
          Percentages for recipient-country and recipient-region don't add up
          to 100%.
        </iati-me:message>
      </iati-me:feedback>
    </xsl:if>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
</xsl:stylesheet>
