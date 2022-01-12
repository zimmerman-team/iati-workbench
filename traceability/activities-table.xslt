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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"
  expand-text="yes">
  
  <xsl:output method="text"/>
  
  <xsl:variable name="corpus" select="collection('/workspace/input/?select=*.xml')/*/iati-activity"/>
  
  <xsl:template match="/">
    <xsl:text>"iati-identifier", "organisation", "partnership", "comments", "feedback", "what it means", "action needed?", "action by whom?", "published?", "is this linking to upstream?", "is upstream linking to this?", "upstream", "upstream organisation", "hierarchy", "level", "class"</xsl:text>    
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="activity">
    <xsl:text>"{.}", "{@org}", "{@partnership}", "", </xsl:text>
    <xsl:apply-templates select="." mode="meaning"/>
    <xsl:text>, "{@published}", "{@in_this}", "{@in_up}", "{@up}", "{@up_org}", "{@hierarchy}", "{@level}", "{@class}"</xsl:text>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[@published='true' and @in_this='' and @in_up='']" mode="meaning">
    <xsl:text>"OK", "This activity is provided manually (as partnership lead or otherwise)", "", ""</xsl:text>
  </xsl:template>

  <xsl:template match="*[@published='false' and @in_this='' and @in_up='']" mode="meaning">
    <xsl:text>"WARNING", "This activity is provided manually (partnership lead or otherwise) but not published", "{@org} should publish the activity", "{@org}"</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[@published='true' and @in_this='true' and @in_up='true']" mode="meaning">
    <xsl:text>"OK", "Both activities point to each other", "", ""</xsl:text>
  </xsl:template>

  <xsl:template match="*[@published='true' and @in_this='true' and @in_up='false']" mode="meaning">
    <xsl:text>"OK", "This activity points upstream", "", ""</xsl:text>
  </xsl:template>

  <xsl:template match="*[@published='true' and @in_this='false' and @in_up='true']" mode="meaning">
    <xsl:text>"WARNING", "The upstream activity points downward to this activity", "{@org} should include a reference to the upstream activity (or {@up_org} must fix the downward reference)", "{@org}"</xsl:text>
  </xsl:template>

  <xsl:template match="*[@published='false' and @in_this='false' and @in_up='true']" mode="meaning">
    <xsl:text>"WARNING", "The upstream activity points to an activity that does not exist", "Check if the activity is from a DRA member. If so, {@up_org} must fix the downward reference</xsl:text>
    <xsl:if test="@org!=''">
      <xsl:text> (or {@org} should publish this activity)</xsl:text>
    </xsl:if>
    <xsl:text>", "{@up_org}"</xsl:text>
  </xsl:template>
  
  <xsl:template match="*" mode="meaning">
    <xsl:text>"n/a", "n/a", ""</xsl:text>
  </xsl:template>

</xsl:stylesheet>