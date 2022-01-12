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
