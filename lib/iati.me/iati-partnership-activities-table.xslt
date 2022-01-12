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
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  xmlns:me="http://iati.me"
  expand-text="yes">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="../office/spreadsheet.xslt"/>
  
  <xsl:variable name="partnerships" select="doc('/workspace/output/activities.xml')"/>
  <xsl:variable name="subset" select="doc('/workspace/output/subset.xml')"/>
<!--  <xsl:variable name="currencies" select="(//value/@currency, //iati-activity/@default-currency-code)=>distinct-values()=>sort()"/>-->
  <xsl:variable name="budgets" select="doc('/workspace/output/budgets-adhoc.xml')"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/iati-activities">
    <xsl:variable name="data">
      <file>
        <xsl:apply-templates select="iati-activity">
          <xsl:sort select="iati-identifier"/>
        </xsl:apply-templates>
      </file>
    </xsl:variable>
    <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
  </xsl:template>

  <xsl:template match="iati-activity">
    <xsl:variable name="id" select="iati-identifier/data()"/>
    <xsl:variable name="meta" select="$partnerships//activity[.=$id]"/>
    <xsl:variable name="subact" select="$subset//record[entry[@name='Activity_id']=$id]"/>
    <xsl:variable name="b" select="$budgets//b[@act=$id]"/>
    <xsl:variable name="act" select="."/>
    <xsl:for-each select="$subact/entry[@name='PortfolioID']=>distinct-values()=>sort()">
      <row>
        <column name="Partnership" style="co1">{$meta/@partnership}</column>
        <column name="Partnership name" style="co2">{$meta/@partnership-name}</column>
        <column name="Partnership upstream" style="co2">{$meta/@up}</column>
        <column name="Partnership level" style="co1">{$meta/@level}</column>
        
        <column name="PortfolioID" style="co1">{.}</column>
        
        <column name="Organisation" style="co3">{$act/reporting-org/narrative[1]}</column>
        <column name="Organisation identifier" style="co3">{$act/reporting-org/@ref}</column>
        <column name="IATI activity identifier" style="co3">{$act/iati-identifier}</column>
        <column name="Activity name" style="co4">{$act/title/narrative[1]}</column>
        
        <column name="Start date" style="co1">{($act/activity-date[@type="2"], $act/activity-date[@type="1"])[1]/@iso-date}</column>
        <column name="(planned)" style="co1">{$act/activity-date[@type="1"]/@iso-date}</column>
        <column name="(actual)" style="co1">{$act/activity-date[@type="2"]/@iso-date}</column>
        <column name="End date" style="co1">{($act/activity-date[@type="4"], $act/activity-date[@type="3"])[1]/@iso-date}</column>
        <column name="(planned)" style="co1">{$act/activity-date[@type="3"]/@iso-date}</column>
        <column name="(actual)" style="co1">{$act/activity-date[@type="4"]/@iso-date}</column>
        <column name="Status" style="co1">{$act/activity-status/@code}</column>
        
        <column name="Budgets:" style="co1"></column>
        <column name="Currency" style="co1">{$b/value/@currency=>string-join(', ')}</column>
        <column name="Value" style="co1">{me:nonzero(sum($b/value/double))}</column>
        <column name="in USD" style="co1">{me:nonzero(sum($b/value/@usd))}</column>
        
        <column name="DAC5 sectors" style="co1">{($act/sector[@vocabulary='1' or not(@vocabulary)]/@code)=>sort()=>string-join(', ')}</column>
        <column name="DAC5 percentages" style="co1">{($act/sector[@vocabulary='1' or not(@vocabulary)]/@percentage)=>sort()=>string-join(', ')}</column>
        
        <column name="SDG goal sectors" style="co1">{($act/sector[@vocabulary='7']/@code)=>sort()=>string-join(', ')}</column>
        <column name="SDG goal percentages" style="co1">{($act/sector[@vocabulary='7']/@percentage)=>sort()=>string-join(', ')}</column>
        
        <column name="SDG target sectors" style="co1">{($act/sector[@vocabulary='7']/@code)=>sort()=>string-join(', ')}</column>
        <column name="SDG target percentages" style="co1">{($act/sector[@vocabulary='7']/@percentage)=>sort()=>string-join(', ')}</column>
        
        <column name="SDG indicator sectors" style="co1">{($act/sector[@vocabulary='7']/@code)=>sort()=>string-join(', ')}</column>
        <column name="SDG indicator percentages" style="co1">{($act/sector[@vocabulary='7']/@percentage)=>sort()=>string-join(', ')}</column>
        
        <column name="SDG goals (tags)" style="co1">{($act/tag[@vocabulary='2']/@code)=>sort()=>string-join(', ')}</column>
        <column name="SDG targets (tags)" style="co1">{($act/tag[@vocabulary='3']/@code)=>sort()=>string-join(', ')}</column>
        
        <column name="Geography:" style="co1"></column>
        <column name="Countries" style="co1">{me:list($act/recipient-country/@code)}</column>
        <column name="# locations" style="co1">{me:nonzero(count($act/location))}</column>
        
        <column name="Participating orgs:" style="co2"></column>
        <column name="# funding" style="co1">{me:nonzero(count($act/participating-org[@role='1']))}</column>
        <column name="# accountable" style="co1">{me:nonzero(count($act/participating-org[@role='2']))}</column>
        <column name="# implementing" style="co1">{me:nonzero(count($act/participating-org[@role='4']))}</column>
        
        <column name="Results:" style="co1"></column>
        <column name="# indicators" style="co1">{me:nonzero(count($act/result/indicator))}</column>
      </row>      
    </xsl:for-each>
  </xsl:template>
  
  <xsl:function name="me:yesno" as="xs:string">
    <xsl:param name="bool"/>
    <xsl:text>{if ($bool) then ('yes') else ('no')}</xsl:text>
  </xsl:function>

  <xsl:function name="me:nonzero" as="xs:string">
    <xsl:param name="val"/>
    <xsl:text>{if ($val!=0) then ($val) else ('')}</xsl:text>
  </xsl:function>
  
  <xsl:function name="me:list" as="xs:string">
    <xsl:param name="list"/>
    <xsl:text>{($list)=>distinct-values()=>sort()=>string-join(', ')}</xsl:text>
  </xsl:function>
</xsl:stylesheet>
