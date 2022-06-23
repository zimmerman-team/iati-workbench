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
<!-- TODO: A general description of the functional content of this file. for example
  XSLT Stylesheet responsible for...
  Specific design choices here were...
-->
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://aida.tools/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:import href="../functx.xslt"/>

  <!-- configuration variables for conversion -->
  <xsl:variable name="reporting-org"/>
  <xsl:variable name="reporting-org-type"/>
  <xsl:variable name="reporting-org-name"/>
  <xsl:variable name="include-reporting-org-as-role"/>
  <xsl:variable name="default-participating-role"/>
  <xsl:variable name="default-currency"/>

  <xsl:template match="csv">
    <iati-activities version="2.03" generated-datetime="{current-dateTime()}" xml:lang="en">
      <xsl:apply-templates select="record"/>
    </iati-activities>
  </xsl:template>

  <xsl:template match="record">
    <!-- This is a fallback for any file not mentioned in any of the templates -->
    <merge:not-processed>row {position()}</merge:not-processed>
  </xsl:template>

  <xsl:function name="merge:boolean" as="xs:boolean">
    <xsl:param name="item" as="xs:string?"/>
    <xsl:choose>
      <!-- TODO: Describe extremely specific strings such as this, why are only these values considered as boolean true. Should other languages be included? -->
      <xsl:when test="lower-case($item) = ('true', '1', 'ja', 'yes', 'oui', 'si', 'waar', 'y')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="merge:decimal" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>
    <xsl:if test="$item!=''">
      <!-- remove '%' and ',' -->
      <xsl:variable name="i" select="replace($item,'[%,]','')=>functx:trim()=>replace('\((.+)\)', '-$1')"/>
      <xsl:if test="$i!=''">{$i}</xsl:if>
    </xsl:if>
  </xsl:function>

  <!-- Remove periods, replace commas with period, then turn into decimal -->
  <xsl:function name="merge:decimal2" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>
    {merge:decimal(replace($item, '.', '')=>replace(',', '.'))}
  </xsl:function>

  <xsl:function name="merge:currency-value" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>

    <!-- TODO: As you've done for previous functions, describe "why are we doing this". -->
    <xsl:analyze-string regex="^[a-zA-Z€$]*\s?([+-]?[0-9.,]+)$" select="normalize-space($item)">
      <xsl:matching-substring>{merge:decimal(regex-group(1))}</xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="merge:currency-symbol" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>

    <xsl:analyze-string regex="^([a-zA-Z]+)\s?[+-]?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>{regex-group(1)}</xsl:matching-substring>
    </xsl:analyze-string>

    <!-- TODO: Why do we only have USD and EUR? Is this a specific decision? A short comment could be helpful to explain the decision. -->
    <xsl:analyze-string regex="^€\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>EUR</xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:analyze-string regex="^(US)?\$\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>USD</xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="merge:date" as="xs:date?">
    <!-- date function without format: recognise the format -->
    <xsl:param name="item" as="xs:string"/>

    <!-- DD-MM-YYYY, DD/MM/YYYY HH:MM, DD.MM.YYYY -->
    <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d{{4}})([T ].+)?$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:try>
          {functx:date(regex-group(3), regex-group(2), regex-group(1))}
          <xsl:catch/>
        </xsl:try>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <!-- DD-MM-YY, DD.MM.YY, DD/MM/YY -->
    <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d\d)$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:try>
          {functx:date(merge:year(regex-group(3)), regex-group(2), regex-group(1))}
          <xsl:catch/>
        </xsl:try>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <!-- YYYY-MM-DD or YYYY-MM-DD HH:MM... or YYYY-MM-DDTHH:MM... -->
    <xsl:analyze-string regex="^(\d{{4}})\D(\d\d?)\D(\d\d)([T ].+)?$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:try>
          {functx:date(regex-group(1), regex-group(2), regex-group(3))}
          <xsl:catch/>
        </xsl:try>
      </xsl:matching-substring>
    </xsl:analyze-string>

  </xsl:function>

  <!-- TODO: Perhaps describe why we have two `merge:date` functions. -->
  <xsl:function name="merge:date" as="xs:date?">
    <!-- date function with format: return as proper date if possible -->
    <xsl:param name="item" as="xs:string"/>
    <xsl:param name="format" as="xs:string"/>

    <xsl:choose>
      <!-- TODO: Perhaps a more clear description here, describe decision of why only mm.dd.yyyy and yyyy.dd.mm? do we never receive dd.mm.yyyy? -->
      <!-- MM-DD-YYYY, MM/DD/YYYY -->
      <xsl:when test="matches($format, 'MM.DD.YYYY', 'i')">
        <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d{{4}})$" select="normalize-space($item)">
          <xsl:matching-substring>
            <xsl:try>
              {functx:date(regex-group(3), regex-group(1), regex-group(2))}
              <xsl:catch/>
            </xsl:try>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            {merge:date($item)}
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($format, 'YYYY.DD.MM', 'i')">
        <xsl:analyze-string regex="^(\d{{4}})\D(\d\d?)\D(\d\d?)$" select="normalize-space($item)">
          <xsl:matching-substring>
            <xsl:try>
              {functx:date(regex-group(1), regex-group(3), regex-group(2))}
              <xsl:catch/>
            </xsl:try>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            {merge:date($item)}
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        {merge:date($item)}
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="merge:year" as="xs:string">
    <xsl:param name="year" as="xs:string"/>
    <xsl:variable name="yy" select="xs:decimal($year)"/>
    <!-- for YY >= 70 we'll assume 19YY, otherwise 20YY TODO: describe why we use 70. What about 1967 data, what about 2070 data. (Presumably, that data is never expected, thus 70 is a safe value) -->
    <xsl:choose>
      <xsl:when test="$yy >= 70">{1900+$yy}</xsl:when>
      <xsl:otherwise>{2000+$yy}</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="merge:tokenize" as="xs:string*">
    <xsl:param name="item" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="matches($item, '\W+')">
        <xsl:sequence select="functx:substring-before-match($item,'\W+')"/>
        <xsl:sequence select="merge:tokenize(functx:substring-after-match($item,'\W+'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$item"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="merge:entry">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>

    <xsl:sequence select="merge:entry($record, $label, '')"/>
  </xsl:function>

  <xsl:function name="merge:entry">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>
    <xsl:param name="default" as="xs:string"/>

    <xsl:variable name="values" select="for $w in $label return $record/entry[functx:trim(lower-case(@name)) = lower-case($w) and functx:trim(.) != '']"/>
    <xsl:sequence select="functx:trim(($values, $default)[1])"/>
  </xsl:function>

  <xsl:function name="merge:entryExists" as="xs:boolean">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>

    <xsl:variable name="values" select="for $w in $label return $record/entry[functx:trim(lower-case(@name)) = lower-case($w) and functx:trim(.) != '']"/>
    {count($values)>0}
  </xsl:function>

  <xsl:function name="merge:format" as="xs:string">
    <xsl:param name="from" as="xs:string"/>
    <xsl:variable name="known">
      <to format="application/pdf"><f>pdf</f></to>
      <to format="image/jpeg"><f>jpg</f><f>jpeg</f></to>
      <to format="text/html"><f>html</f><f>web</f></to>
    </xsl:variable>
    <xsl:text>{($known/to[lower-case(functx:trim($from))=f]/@format, $from)[1]}</xsl:text>
  </xsl:function>

  <xsl:function name="merge:get-code-from-list">
    <xsl:param name="list"/>
    <xsl:param name="text"/>
    <!--  TODO: refactor IATI version for codelists into configuration  -->
    <xsl:variable name="codelist" select="doc(concat('../schemata/2.03/codelist/', $list, '.xml' ))"/>
    <xsl:text>{($codelist//codelist-item[some $name in name/narrative satisfies (lower-case($name)=lower-case($text))]/code,
      $text)[1]}</xsl:text>
  </xsl:function>
</xsl:stylesheet>
