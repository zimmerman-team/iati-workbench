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

<!-- Nuffic-specific transformation of Akvo IATI to S2I IATI -->

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  xmlns:nuffic="http://iati.me/nuffic"
  xmlns:akvo="http://akvo.org/iati-activities"
  exclude-result-prefixes="akvo"
  expand-text="yes">

  <xsl:include href="nuffic-lib.xslt"/>
  <xsl:mode name="nuffic" on-no-match="shallow-copy"/>

  <xsl:template match="iati-activity" mode="nuffic">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="nuffic:idfix(iati-identifier)"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="result" mode="nuffic">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="title/narrative[1]"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="indicator" mode="nuffic">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:attribute name="merge:id" select="(reference/@code,title/narrative)[1]"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="iati-identifier" mode="nuffic">
    <xsl:copy>{nuffic:idfix(.)}</xsl:copy>
  </xsl:template>

  <xsl:template match="related-activity" mode="nuffic">
    <xsl:if test="@type='1'">
      <xsl:variable name="parent">
        <xsl:choose>
          <xsl:when test="starts-with(../iati-identifier, 'NL-KVK-41150085-OKP-ICP-')">NL-KVK-41150085-OKP-ICP</xsl:when>
          <xsl:when test="../iati-identifier='NL-KVK-41150085-OKP-TMT'">NL-KVK-41150085-OKP-GT</xsl:when>
          <xsl:when test="../iati-identifier='NL-KVK-41150085-OKP-TMTPLUS'">NL-KVK-41150085-OKP-GT</xsl:when>
          <xsl:when test="../iati-identifier='NL-KVK-41150085-OKP-RC'">NL-KVK-41150085-OKP-GT</xsl:when>
          <xsl:otherwise>{@ref}</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:copy>
        <xsl:attribute name="type" select="@type"/>
        <xsl:attribute name="ref" select="nuffic:idfix($parent)"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="contact-info" mode="nuffic">
    <contact-info type="1">
      <organisation>
        <narrative>Nuffic</narrative>
      </organisation>
      <email>okp@nuffic.nl</email>
      <mailing-address>
        <narrative>P.O. Box 29777, 2502 LT The Hague, The Netherlands</narrative>
      </mailing-address>
    </contact-info>
  </xsl:template>

  <!-- skip BZ as funding org, add it via participating orgs sheet -->
  <xsl:template match="participating-org[@ref=('XM-DAC-7', 'XM-DAC-7-') and @role='1']" mode="nuffic"/>

  <!-- skip results with value 'N/A' -->
  <xsl:template match="(baseline|target|actual)[lower-case(@value)='n/a']" mode="nuffic"/>

</xsl:stylesheet>
