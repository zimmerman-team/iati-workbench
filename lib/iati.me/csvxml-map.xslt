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
<!--
  This stylesheet looks at the available "*.csv.xml" files,
  and lists the column headers in the first line, sorted by name.
  This allows us to compare a CSV file with its previous version, for column name changes.
-->
<xsl:stylesheet version='3.0' expand-text="yes" xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:export="http://iati.me/export"
  xmlns:functx="http://www.functx.com">
  
  <xsl:output method="text"/>

  <xsl:import href="../functx.xslt"/>

  <xsl:template match="/">
    <xsl:text>File,Column&#xa;</xsl:text>
    <xsl:apply-templates select="dir/f[ends-with(@n, '.csv.xml')]">
      <xsl:sort select="@n"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="f">
      <xsl:apply-templates select="doc(concat('/workspace/tmp/',@n))/csv/record[1]/entry">

        <xsl:with-param name="filename" select="substring-before(@n,'.csv.xml')"/>
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="entry">
    <xsl:param name="filename"/>
    <xsl:text>{$filename},{@name}&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
