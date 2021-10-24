<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' 
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  expand-text="yes">
  
  <!-- Transform Ant XmlLogger output into JSON -->

  <xsl:mode on-no-match="shallow-skip"/>
  <xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:variable name="log">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:text>{$log=>xml-to-json()}</xsl:text>
  </xsl:template>
  
  <xsl:template match="build">
    <j:map>
      <j:string key="time">{@time}</j:string>
      <j:boolean key="success">{not(@error)}</j:boolean>
      <xsl:if test="@error">
        <j:string key="error">{@error}</j:string>
      </xsl:if>
      <j:array key="steps">
        <xsl:apply-templates/>
      </j:array>
    </j:map>
  </xsl:template>
  
  <xsl:template match="target">
    <j:map>
      <j:string key="name">{@name}</j:string>
      <j:string key="time">{@time}</j:string>
      <j:array key="tasks">
        <xsl:apply-templates/>
      </j:array>
    </j:map>
  </xsl:template>
  
  <xsl:template match="task[message]">
    <j:map>
      <j:string key="name">{@name}</j:string>
      <j:string key="time">{@time}</j:string>
      <j:array key="messages">
        <xsl:apply-templates/>
      </j:array>
    </j:map>
  </xsl:template>
  
  <xsl:template match="message">
    <j:string>{.}</j:string>
  </xsl:template>
</xsl:stylesheet>
