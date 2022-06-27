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
  xmlns:merge="http://aida.tools/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <!-- ignore these elements: -->
  <!-- attributes without a value -->
  <xsl:template match="@*[normalize-space(.) = '']"/>

  <!-- Process a sequence of narratives:
    * Group by language
    * Then group by content (in effect eliminating duplicates in a language)
    * Add the xml:lang attribute if it is not the default language
  -->
  <xsl:template name="narratives">
    <xsl:param name="narratives"/>
    <xsl:param name="default-lang" tunnel="yes"/>
    <xsl:for-each-group select="$narratives"
      group-by="(@xml:lang, $default-lang)[1]">
      <xsl:variable name="lang" select="current-grouping-key()"/>

      <narrative>
        <xsl:if test="$lang!=$default-lang">
          <xsl:attribute name="xml:lang" select="$lang"/>
        </xsl:if>
        <xsl:text>{text()[1]}</xsl:text>
      </narrative>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="narrative[text()]">
    <xsl:param name="default-lang" tunnel="yes"/>
    <narrative>
      <xsl:if test="@xml:lang != $default-lang">
        <xsl:copy-of select="@xml:lang"/>
      </xsl:if>
      <xsl:text>{.}</xsl:text>
    </narrative>
  </xsl:template>

  <!-- our version of on-no-match="shallow-copy", without copying namespaces -->
  <xsl:template match=".">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
