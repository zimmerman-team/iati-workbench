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
  This styleheet contains generic templates for CSV-XML files,
  and functions to process strings in templates.

  The string processing functions expand the capabilities to recognise various common formats
  that are not included in the standard XML/Xpath functions.

  The functions will return an (optional) string.
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

  <!-- Expand recognition of boolean values.
  XML only accepts 'true', '1', and 'yes' as booleans.
  We want to add some more based on experience with client sheets. -->
  <xsl:function name="merge:boolean" as="xs:boolean">
    <xsl:param name="item" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="lower-case($item) = ('true', '1', 'ja', 'yes', 'oui', 'si', 'waar', 'y')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Expand recognition of common numerical values:
   * remove '%' and ',' characters (common in percentages or formatted number strings)
   * interpret (...) as negative number -->
  <xsl:function name="merge:decimal" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>
    <xsl:if test="$item!=''">
      <xsl:variable name="i" select="replace($item,'[%,]','')=>functx:trim()=>replace('\((.+)\)', '-$1')"/>
      <xsl:if test="$i!=''">{$i}</xsl:if>
    </xsl:if>
  </xsl:function>

  <!-- Recognise Dutch numerical values:
  Remove periods, replace commas with period, then apply decimal() -->
  <xsl:function name="merge:decimal2" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>
    {merge:decimal(replace($item, '.', '')=>replace(',', '.'))}
  </xsl:function>

  <!-- Currency values: some systems export financial data in a single column -->
  <!-- Recognise numerical currency values with a currency in the string: USD 1234, €567
  It will remove starting text, €, $, and apply decimal() on a possible number. -->
  <xsl:function name="merge:currency-value" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>

    <xsl:analyze-string regex="^[a-zA-Z€$]*\s?([+-]?[0-9.,]+)$" select="normalize-space($item)">
      <xsl:matching-substring>{merge:decimal(regex-group(1))}</xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <!-- Recognise currency symbols in a string.
  Currently recognising € as EUR, and $ and US$ as USD,
  and returning any non-numerical starting text as symbol. -->
  <xsl:function name="merge:currency-symbol" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>

    <xsl:analyze-string regex="^([a-zA-Z]+)\s?[+-]?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>{regex-group(1)}</xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:analyze-string regex="^€\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>EUR</xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:analyze-string regex="^(US)?\$\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>USD</xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <!-- Recognise various date formats.
  This is the generic function. -->
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

  <!-- Recognise specific known date formats in client-specific templates.
  For this version, a second format parameter is required, to indicate how to interpret the string.
  This is useful when a client uses for instance a US-specific format that cannot always be recognised automatically. -->
  <xsl:function name="merge:date" as="xs:date?">
    <!-- date function with format: return as proper date if possible -->
    <xsl:param name="item" as="xs:string"/>
    <xsl:param name="format" as="xs:string"/>

    <xsl:choose>
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

  <!-- Recognise more possible year values:
  * anything from '70' onwards will be interpreted as 19..
  * anything up to '69' will be interpreted as 20...
  Based on existing values in earlier examples. -->
  <xsl:function name="merge:year" as="xs:string">
    <xsl:param name="year" as="xs:string"/>
    <xsl:variable name="yy" select="xs:decimal($year)"/>
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

  <!-- Look for a column (=entry) with a possible column name.
  Return and empty string if not found -->
  <xsl:function name="merge:entry">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>

    <xsl:sequence select="merge:entry($record, $label, '')"/>
  </xsl:function>

  <!-- Look for a column (=entry) with a list of possible column names.
  If not found, return the provided default string.
  If multiple options are found, return the first one.
  Remove starting or trailing whitespace, and compare as lower-case values. -->
  <xsl:function name="merge:entry">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>
    <xsl:param name="default" as="xs:string"/>

    <xsl:variable name="values" select="for $w in $label return $record/entry[functx:trim(lower-case(@name)) = lower-case($w) and functx:trim(.) != '']"/>
    <xsl:sequence select="functx:trim(($values, $default)[1])"/>
  </xsl:function>

  <!-- Check if a column with a list of possible names has a value that is not an empty string. -->
  <xsl:function name="merge:entryExists" as="xs:boolean">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>

    <xsl:variable name="values" select="for $w in $label return $record/entry[functx:trim(lower-case(@name)) = lower-case($w) and functx:trim(.) != '']"/>
    {count($values)>0}
  </xsl:function>

  <!-- Recognise some common file formats, and return their proper mime type.
   TODO: this could be an XSLT map as well to maybe make it easier to read. -->
  <xsl:function name="merge:format" as="xs:string">
    <xsl:param name="from" as="xs:string"/>
    <xsl:variable name="known">
      <to format="application/pdf"><f>pdf</f></to>
      <to format="image/jpeg"><f>jpg</f><f>jpeg</f></to>
      <to format="text/html"><f>html</f><f>web</f></to>
    </xsl:variable>
    <xsl:text>{($known/to[lower-case(functx:trim($from))=f]/@format, $from)[1]}</xsl:text>
  </xsl:function>

  <!-- Recognise a possible code textual or numerical value, or return a default value.
   This requires up-to-date IATI codelists in `lib/schemata/2.03/codelists` -->
  <xsl:function name="merge:get-code-from-list">
    <xsl:param name="list"/>
    <xsl:param name="default"/>
    <!--  TODO: refactor IATI version for codelists into configuration  -->
    <xsl:variable name="codelist" select="doc(concat('../schemata/2.03/codelist/', $list, '.xml' ))"/>
    <xsl:text>{($codelist//codelist-item[some $name in name/narrative satisfies (lower-case($name)=lower-case($text))]/code,
      $default)[1]}</xsl:text>
  </xsl:function>
</xsl:stylesheet>
