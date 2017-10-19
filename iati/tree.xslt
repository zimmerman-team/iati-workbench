<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:import href="../lib/htdocs/bootstrap.xslt"/>
<xsl:import href="model/activity-hierarchy.xslt"/>
<xsl:import href="view/html/activity-table.xslt"/>

<xsl:template match="/" mode="html-head">
  <link href="css/table.css" rel="stylesheet"/>
</xsl:template>

<xsl:template match="/" mode="html-body">
  <!-- <nav class="navbar navbar-inverse navbar-fixed-top"> -->
  <nav class="navbar navbar-inverse">
    <div class="container">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
      </div>
      <div class="navbar-collapse collapse">
        <ul class="nav navbar-nav">
          <li><a href="iati-activities.list.html">Home</a></li>
          <li><a href="iati-activities.gantt.html">Results overview</a></li>
          <li><a href="iati-activities.summary.html">Quality feedback</a></li>
        </ul>
      </div><!--/.nav-collapse -->
    </div>
  </nav>

  <div role="main">
    <div class="container-fluid">
      <iframe src="index.svg" style="width:100%; height: 40em; border: 1px solid #ecf0f1"/>
    </div>

    <div class="container">
      <h1><xsl:value-of select="count(//iati-activity)"/> Activities</h1>
      <xsl:apply-templates select="iati-activities"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="recipient-country" mode="data-row">
  <budget country="{upper-case(@code)}">
    <xsl:value-of select="sum(../budget/value) div 1000 * (xs:decimal(@percentage),100)[1]"/>
  </budget>
</xsl:template>

</xsl:stylesheet>
