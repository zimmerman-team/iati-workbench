<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  expand-text="yes">
  <!-- uses XSLT 3.0 expand-text to enable text value templates everywhere -->

<xsl:import href="/root/lib/functx.xslt"/>

<xsl:template match="iati-activities">
  <table class="table">
    <tr>
      <th>Organisation</th>
      <th>Activity</th>
      <th>Start</th>
      <th>End</th>
    </tr>
    <xsl:apply-templates select="." mode="walk"/>
  </table>
</xsl:template>

<xsl:template match="iati-activity">
  <xsl:param name="activity-level" tunnel="yes" select="xs:integer(1)"/>

  <tr>
    <xsl:attribute name="class">activity level-<xsl:value-of select="$activity-level"/></xsl:attribute>

    <td class="">{reporting-org/narrative[1]}</td>
    <td class="title"><a href="{iati-identifier}.html">{title/narrative[1]}</a></td>

    <td class="date">
      <!-- get start date: actual before planned, then earliest date -->
      <xsl:variable name="start" as="element(activity-date)*">
        <xsl:perform-sort select="activity-date[@type=('1', '2')]">
          <xsl:sort select="@type" order="descending"/>
          <xsl:sort select="@iso-date"/>
        </xsl:perform-sort>
      </xsl:variable>

      <xsl:value-of select="$start[1]/@iso-date"/>
    </td>
    <td class="date">
      <!-- get end date: actual before planned, then latest date -->
      <xsl:variable name="start" as="element(activity-date)*">
        <xsl:perform-sort select="activity-date[@type=('3', '4')]">
          <xsl:sort select="@type" order="descending"/>
          <xsl:sort select="@iso-date" order="descending"/>
        </xsl:perform-sort>
      </xsl:variable>

      <xsl:value-of select="$start[1]/@iso-date"/>
    </td>
  </tr>
  <xsl:apply-templates select="." mode="descend"/>
</xsl:template>

</xsl:stylesheet>
