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

  <xsl:function name="merge:decimal" as="xs:decimal?">
    <xsl:param name="item" as="xs:string"/>
    <xsl:if test="$item!=''">
      <!-- remove '%' and ',' -->
      {replace($item,'[%,]','')}
    </xsl:if>
  </xsl:function>

  <xsl:function name="merge:decimal2" as="xs:decimal?">
    <xsl:param name="item" as="xs:string"/>
    <xsl:if test="$item!=''">
      <!-- remove '%' and '.', replace comma by period as decimal-separator -->
      {replace(replace($item,'[%.]',''), ',', '.')}
    </xsl:if>
  </xsl:function>
  
  <xsl:function name="merge:currency-value" as="xs:decimal?">
    <xsl:param name="item" as="xs:string"/>
    
    <xsl:analyze-string regex="^[a-zA-Z€$]*\s?([0-9.,]+)$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="merge:decimal(regex-group(1))"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="merge:currency-symbol" as="xs:string?">
    <xsl:param name="item" as="xs:string"/>
    
    <xsl:analyze-string regex="^([a-zA-Z]+)\s?[0-9.,]+$" select="normalize-space($item)">
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
        <xsl:value-of select="functx:date(regex-group(3), regex-group(2), regex-group(1))"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <!-- DD-MM-YY, DD.MM.YY, DD/MM/YY -->
    <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d\d)$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="functx:date(merge:year(regex-group(3)), regex-group(2), regex-group(1))"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <!-- YYYY-MM-DD -->
    <xsl:analyze-string regex="^(\d{{4}})\D(\d\d?)\D(\d\d)$" select="normalize-space($item)">
      <xsl:matching-substring>
        <xsl:value-of select="functx:date(regex-group(1), regex-group(2), regex-group(3))"/>
      </xsl:matching-substring>
    </xsl:analyze-string>

  </xsl:function>

  <xsl:function name="merge:date" as="xs:date?">
    <!-- date function with format: return as proper date if possible -->
    <xsl:param name="item" as="xs:string"/>
    <xsl:param name="format" as="xs:string"/>
    <xsl:variable name="i" select="normalize-space($item)"/>
    <xsl:choose>

      <!-- MM-DD-YYYY, MM/DD/YYYY -->
      <xsl:when test="matches($format, 'MM.DD.YYYY', 'i')">
        <xsl:analyze-string regex="^(\d\d?)\D(\d\d?)\D(\d{{4}})$" select="normalize-space($item)">
          <xsl:matching-substring>
            <xsl:value-of select="functx:date(regex-group(3), regex-group(1), regex-group(2))"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="merge:date($item)"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="matches($format, 'YYYY.DD.MM', 'i')">
        <xsl:analyze-string regex="^(\d{{4}})\D(\d\d?)\D(\d\d?)$" select="normalize-space($item)">
          <xsl:matching-substring>
            <xsl:value-of select="functx:date(regex-group(1), regex-group(3), regex-group(2))"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="merge:date($item)"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="merge:date($item)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="merge:year" as="xs:decimal">
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

</xsl:stylesheet>
