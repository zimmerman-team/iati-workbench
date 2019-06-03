<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"
  expand-text="yes">
  
  <xsl:output indent="yes"/>

  <xsl:variable name="corpus" select="collection('/workspace/input/?select=*.xml')/*/iati-activity"/>
  <xsl:variable name="ignore" select="//activity[@class='ignore']"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="partnerships">
    <xsl:copy>
      <xsl:apply-templates select="activity[not(@class='downstream')]"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="activity">
    <activity 
      partnership="{@partnership}"
      partnership-name="{@partnership-name}"
      published="{.=$corpus/iati-identifier}"
      org="{($corpus[iati-identifier=current()]/reporting-org/narrative)[1]}"
      level="{@level}"
      hierarchy="{(@hierarchy)[1]}"
      class="{@class}" 
      up="{@up}"
      up_org="{($corpus[iati-identifier=current()/@up]/reporting-org/narrative)[1]}"
      in_this="{@in_this}"
      in_up="{@in_up}">
      <xsl:text>{.}</xsl:text>
    </activity>
          
    <xsl:apply-templates select="." mode="downstream"/>
  </xsl:template>
  
  <xsl:template match="activity" mode="downstream">
    <xsl:param name="known" select="()" tunnel="yes"/>
    <xsl:variable name="this" select="."/>
    
    <xsl:variable name="findings_from_here" as="xs:untypedAtomic*">
      <!-- participating-org that is extending or implementing -->
      <xsl:sequence select="$corpus[iati-identifier=current()]/participating-org[lower-case(@role)=('3', '4', 'extending', 'implementing')]/@activity-id"/>
      
      <!-- any activity that transactions go to -->
      <xsl:sequence select="$corpus[iati-identifier=current()]/transaction[lower-case(transaction-type/@code)=('2', '3', '7', '12', 'c', 'd', 'r')]/receiver-org/@receiver-activity-id"/>
      
      <!-- any activity is indicated as child -->
      <xsl:sequence select="$corpus[iati-identifier=current()]/related-activity[@type='2']/@ref"/>
    </xsl:variable>
    
    <xsl:variable name="findings_to_here" as="xs:untypedAtomic*">     
      <!-- activities that claim to have this activity as funding -->
      <xsl:sequence select="$corpus[participating-org[@activity-id=current() and lower-case(@role)=('1', 'funding')]]/iati-identifier"/>
      
      <!-- activities with incoming transactions from this activity -->
      <xsl:sequence select="$corpus[provider-org[@provider-activity-id=current() and lower-case(transaction-type/@code)=('1', '11', '13', 'if')]]/iati-identifier"/>
      
      <!-- activities that claim this activity is a parent or cofunder -->
      <xsl:sequence select="$corpus[related-activity[@ref=current() and
        @type=('1', '4')]]/iati-identifier"/>
      
      <!-- TODO: add facility to capture previous activity identifiers that may be used downstream, from other-identifier[...]; these should be marked as such in the table as they should not exist anymore -->
    </xsl:variable>
    
    <xsl:variable name="seeds" select="distinct-values(//activity[@partnership=current()/@partnership])"/>
        
    <xsl:for-each select="distinct-values(($findings_from_here, $findings_to_here))[not(.=($seeds, $known))]">

      <xsl:variable name="activity">
        <activity
          partnership="{$this/@partnership}"
          partnership-name="{$this/@partnership-name}"
          level="{$this/@level+1}" 
          class="downstream" 
          up="{$this}"
          in_this="{.=$findings_to_here}"
          in_up="{.=$findings_from_here}">
          <xsl:text>{.}</xsl:text>
        </activity>
      </xsl:variable>

      <xsl:apply-templates select="$activity[not(.=$ignore)]">
        <xsl:with-param name="known" select="distinct-values(($findings_from_here, $findings_to_here, $seeds, $known))" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:for-each>
    
  </xsl:template>
  
  <!--Identity template copies content forward -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>