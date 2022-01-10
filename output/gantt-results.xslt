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

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="iati-me functx">

  <xsl:import href="../lib/functx.xslt"/>

  <xsl:template match="/">
    <project>
      <xsl:for-each-group select="//iati-activity" group-by="reporting-org/@ref">
        <xsl:variable name="org" select="concat(count(ancestor::node()),
           '00000000', count(preceding::node()))"/>
        <task>
          <pID><xsl:value-of select="$org"/></pID>
          <pName><xsl:value-of select="functx:trim(current-group()[1]/reporting-org)"/></pName>
          <pGroup>1</pGroup>
          <pClass>ggroupwhite</pClass>
          <pLink>http://d-portal.org/ctrack.html?publisher=<xsl:value-of select="current-grouping-key()"/>#view=publisher</pLink>
        </task>
        <xsl:apply-templates select="current-group()">
          <xsl:with-param name="org" select="$org"/>
        </xsl:apply-templates>
      </xsl:for-each-group>
    </project>
  </xsl:template>

  <xsl:template match="iati-activity">
    <xsl:param name="org"/>
    <xsl:variable name="activity" select="concat(count(ancestor::node()),
       '00000000', count(preceding::node()))"/>
    <task>
        <pID><xsl:value-of select="$activity"/></pID>
        <pName><xsl:value-of select="functx:trim(title[1]/narrative[1])"/></pName>
        <pStart><xsl:value-of select="functx:sort(activity-date[@type=('1','2')]/@iso-date)[1]"/></pStart>
        <pEnd><xsl:value-of select="reverse(functx:sort(activity-date[@type=('3','4')]/@iso-date))[1]"/></pEnd>
        <pGroup>1</pGroup>
        <pParent><xsl:value-of select="$org"/></pParent>
        <pLink>http://d-portal.org/ctrack.html?publisher=<xsl:value-of select="reporting-org/@ref"/>#view=act&amp;aid=<xsl:value-of select="iati-identifier"/></pLink>
        <!-- <pClass>gtaskred</pClass>
        <pLink></pLink>
        <pComp>0</pComp>
        <pParent>2</pParent>
        <pOpen>1</pOpen>
        <pDepend>2,24</pDepend>
        <pCaption>A caption</pCaption> -->
        <pNotes><xsl:value-of select="functx:trim(description[1]/narrative[1])"/></pNotes>
    </task>
    <xsl:apply-templates select="result">
      <xsl:with-param name="activity" select="$activity"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="result">
    <xsl:param name="activity"/>
    <xsl:variable name="result" select="concat(count(ancestor::node()),
       '00000000', count(preceding::node()))"/>
    <task>
        <pID><xsl:value-of select="$result"/></pID>
        <pName><xsl:value-of select="functx:trim(title[1]/(narrative,data(.))[1])"/></pName>
        <pGroup>1</pGroup>
        <pParent><xsl:value-of select="$activity"/></pParent>
        <pClass>ggroupgrey</pClass>
        <pNotes><xsl:value-of select="functx:trim(description[1]/(narrative,data(.))[1])"/></pNotes>
    </task>
    <xsl:apply-templates select="indicator">
      <xsl:with-param name="result" select="$result"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="indicator">
    <xsl:param name="result"/>
    <xsl:variable name="indicator" select="concat(count(ancestor::node()),
       '00000000', count(preceding::node()))"/>
    <task>
        <pID><xsl:value-of select="$indicator"/></pID>
        <pName><xsl:value-of select="functx:trim(title[1]/(narrative,data(.))[1])"/></pName>
        <pGroup>2</pGroup>
        <pParent><xsl:value-of select="$result"/></pParent>
    </task>
    <xsl:apply-templates select="period">
      <xsl:with-param name="indicator" select="$indicator"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="period">
    <xsl:param name="indicator"/>
    <xsl:variable name="period" select="concat(count(ancestor::node()),
       '00000000', count(preceding::node()))"/>
    <task>
        <pID><xsl:value-of select="$period"/></pID>
        <pName>Period</pName>
        <pStart><xsl:value-of select="period-start/@iso-date"/></pStart>
        <pEnd><xsl:value-of select="period-end/@iso-date"/></pEnd>
        <pParent><xsl:value-of select="$indicator"/></pParent>
        <pGroup>0</pGroup>
        <xsl:variable name="target" select="number(target/@value)"/>
        <xsl:variable name="actual" select="number(actual/@value)"/>
        <xsl:variable name="perc" select="round(1000*($actual div $target)) div 10"/>
        <xsl:if test="string($target) != 'NaN' and string($actual) != 'NaN'
          and $target != 0">
          <pComp><xsl:value-of select="min(($perc, 120))"/></pComp>
          <pClass>
            <xsl:choose>
              <xsl:when test="$perc >= 120">gtaskyellow</xsl:when>
              <xsl:when test="$actual >= $target">gtaskgreen</xsl:when>
              <xsl:when test="($actual lt $target) and (current-date() gt xs:date(period-end/@iso-date))">gtaskyellow</xsl:when>
              <xsl:otherwise>gtaskblue</xsl:otherwise>
            </xsl:choose>
          </pClass>
        </xsl:if>
        <pNotes>
          <xsl:value-of select="functx:trim(../description[1]/narrative[1])"/>
          &lt;p&gt;
            Target: <xsl:value-of select="$target"/>
            &lt;br/&gt;<xsl:value-of select="target/comment/narrative"/>
          &lt;/p&gt;
          &lt;p&gt;
            Actual: <xsl:value-of select="$actual"/>
            &lt;br/&gt;<xsl:value-of select="actual/comment/narrative"/>
          &lt;/p&gt;
        </pNotes>
    </task>
  </xsl:template>

</xsl:stylesheet>
