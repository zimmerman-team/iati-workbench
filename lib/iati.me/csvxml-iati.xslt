<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes=""
  expand-text="yes">

  <xsl:import href="codelists.xslt"/>

  <xsl:template match="csv">
    <iati-activities version="2.03" generated-datetime="{current-dateTime()}" xml:lang="en">
      <xsl:apply-templates select="record"/>
    </iati-activities>
  </xsl:template>

  <xsl:template match="record">
    <!-- This is a fallback for any file not mentioned in the /workspace/config/csvxml-iati.xslt file -->
    <merge:not-processed>file <xsl:value-of select="$file"/> row <xsl:value-of select="position()"/></merge:not-processed>
  </xsl:template>

  <xsl:function name="merge:boolean" as="xs:boolean">
    <xsl:param name="item" as="xs:string?"/>

    <xsl:choose>
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

  <xsl:function name="merge:currency-value" as="xs:decimal?">
    <xsl:param name="item" as="xs:string"/>

    <xsl:analyze-string regex="^[a-zA-Z€$]*\s?([+-]?[0-9.,]+)$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="merge:decimal(regex-group(1))"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="merge:currency-symbol" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>

    <xsl:analyze-string regex="^([a-zA-Z]+)\s?[+-]?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:analyze-string regex="^€\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="'EUR'"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:analyze-string regex="^$\s?[0-9.,]+$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="'USD'"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

  </xsl:function>

  <xsl:function name="merge:date" as="xs:date?">
    <!-- date function without format: recognise the format -->
    <xsl:param name="item" as="xs:string"/>

    <!-- DD-MM-YYYY, DD/MM/YYYY, DD.MM.YYYY -->
    <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d{{4}})$" select="normalize-space($item)">
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

  <xsl:function name="merge:year" as="xs:string">
    <xsl:param name="year" as="xs:string"/>
    <xsl:variable name="yy" select="xs:decimal($year)"/>
    <!-- for YY >= 70 we'll assume 19YY, otherwise 20YY -->
    <xsl:choose>
      <xsl:when test="$yy >= 70"><xsl:value-of select="1900+$yy"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="2000+$yy"/></xsl:otherwise>
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

  <xsl:function name="merge:entry" as="item()*">
    <xsl:param name="record" as="node()"/>
    <xsl:param name="label" as="xs:string+"/>

    <xsl:sequence select="merge:entry($record, $label, '')"/>
  </xsl:function>

  <xsl:function name="merge:entry" as="item()*">
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
    <xsl:value-of select="count($values)>0"/>
  </xsl:function>

  <xsl:function name="merge:format" as="xs:string">
    <xsl:param name="from" as="xs:string"/>
    <xsl:variable name="known">
      <to format="application/pdf"><f>pdf</f></to>
      <to format="image/jpeg"><f>jpg</f><f>jpeg</f></to>
      <to format="text/html"><f>html</f><f>web</f></to>
    </xsl:variable>
    <xsl:value-of select="($known/to[lower-case(functx:trim($from))=f]/@format, $from)[1]"/>
  </xsl:function>
</xsl:stylesheet>
