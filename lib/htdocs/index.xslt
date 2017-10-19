<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx merge">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="bootstrap.xslt"/>
  <xsl:output indent="yes"/>

  <xsl:template match="/" mode="html-head">
    <title>Overview of outputs</title>
  </xsl:template>

  <xsl:template match="/" mode="html-body">
    <h1>Overview of outputs</h1>
    <table class="table table-hover table-bordered">
      <tr>
        <th>Page or file</th>
        <th>Modified (UTC time)</th>
      </tr>
      <xsl:apply-templates select="dir/f[@s!='0']">
        <xsl:sort select="@m"/>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="f">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="@n='iati-activities.xml'">IATI Activities as raw XML file for publication</xsl:when>
        <xsl:when test="@n='iati-activities.svg'">Structure diagram of IATI activities</xsl:when>
        <xsl:when test="@n='iati-activities.html'">IATI Activities as viewable XML with line numbers</xsl:when>
        <xsl:when test="@n='iati-activities.summary.html'">Data quality feedback summary</xsl:when>
        <xsl:when test="@n='iati-activities.summary.fods'">Spreadsheet with summary of elements used per activity</xsl:when>
        <xsl:when test="@n='iati-activities.gantt.html'">
          <xsl:if test="../f[@n='iati-activities.gantt.xml' and (@s cast as xs:integer)>0]">
            Gantt-style overview of results
          </xsl:if>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$title!=''">
      <tr>
        <td>
          <a href="{@n}" target="_blank"><xsl:value-of select="$title"/></a>
        </td>
        <td>
          <xsl:value-of select="format-dateTime(replace(@m,'(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})(.)','$1-$2-$3T$4:$5:$6$7') cast as xs:dateTime, '[D]-[M]-[Y] [H01]:[m]:[s]')"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
