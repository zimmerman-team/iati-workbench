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
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:variable name="reporting-org" select="'XE-EXAMPLE-AIDA'"/>
  <xsl:variable name="file" select="'countries'"/>
  <xsl:include href="../../spreadsheet-iati/csvxml-s2i.xslt"/>
</xsl:stylesheet>
