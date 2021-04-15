<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:me="http://iati.me/activities/2.03"
  exclude-result-prefixes="xs math xd"
  expand-text="yes"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>
        This stylesheet transforms an IATI file into a more canonical version,
        to make it easier to process in subsequent pipelines.
      </xd:p>
      <xd:p>
        Where IATI elements or attributes exist, these will be used.
      </xd:p>
      <xd:ul>
        <xd:li>By adding explicit values for implicit defaults, subsequent processors can expect an attribute to be present if valid, and raise an error if it is not.</xd:li>
        <xd:li>If the input file is valid IATI according to the IATI Schema, the output file should be too.</xd:li>
        <xd:li>The input and output files are expected to be semantically identical with respect to the IATI Standard.</xd:li>
        <xd:li>Whitespace before or after identifiers and codes will be removed.</xd:li>
      </xd:ul>
      <xd:p>
        Where IATI elements or attributes do not exist, additional data will be added in a separate namespace.
      </xd:p>
      <xd:ul>
        <xd:li>Attributes based on child text nodes make indexing and lookups faster.</xd:li>
        <xd:li>Hash values based on child values make deduplication and detecting changes easier.</xd:li>
      </xd:ul>
      <xd:p>
        The output will be formatted.
      </xd:p>
      <xd:ul>
        <xd:li>Whitespace and indenting will be adapted to increase readibility as source code, without changing the semantics.</xd:li>
        <xd:li>Comments and processing instructions should be maintained.</xd:li>
        <xd:li>Elements in other namespaces should be retained.</xd:li>
      </xd:ul>

      <xd:p>
        Each template makes a specific change, see the template descriptions for details.
      </xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:output indent="yes"/>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Add our version (and thereby namespace declaration) to the root element.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="iati-activities">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="me:canonical" select="'2.03.1'"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Add activity and organisation identifiers to main element.</xd:p>
      <xd:p>This will allow maps and indices on those identifiers, for faster queries.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="iati-activity">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="me:act-id" select="normalize-space(iati-identifier)"/>
      <xsl:attribute name="me:org-id" select="normalize-space(reporting-org/@ref)"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Add an explicit language to narratives (if available).</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="narrative">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="xml:lang" select="(@xml:lang, ancestor::iati-activity/@xml:lang)[1]"></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>