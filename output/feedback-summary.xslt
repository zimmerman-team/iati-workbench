<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="">

  <xsl:import href="../lib/functx.xslt"/>
  <xsl:import href="../lib/htdocs/bootstrap.xslt"/>
  <xsl:import href="../lib/iati.me/feedback.xslt"/>
  <xsl:variable name="categories" select="$feedback-meta/iati-me:categories/iati-me:category"/>

  <xsl:template match="/" mode="html-body">
    <h1>IATI Data Quality Feedback Summary (per organisation)</h1>

    <xsl:for-each-group select="//iati-activity" group-by="reporting-org/@ref">
      <!-- <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='danger'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='warning'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='info'])"/>
      <xsl:sort order="ascending" select="count(current-group()//iati-me:feedback[@type='success'])"/> -->
      <xsl:sort select="lower-case((current-group()/reporting-org/(narrative,.)[1])[1])"/>

      <xsl:variable name="orgName" select="(current-group()/reporting-org/(narrative,.)[1])[1]"/>
      <xsl:variable name="feedback" select="current-group()//iati-me:feedback"/>

      <div class="panel panel-default">
        <div class="panel-heading"><h3><xsl:value-of select="$orgName"/></h3></div>
        <div class="panel-body collapse-group">
          <div class="row">
            <div class="col-md-3">
              <h4>Per issue severity:</h4>
              <xsl:for-each select="$feedback-meta/iati-me:severities/iati-me:severity">
                <xsl:variable name="type" select="@type"/>
                <div class="list-group">
                  <xsl:attribute name="class">list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>
                  <xsl:value-of select="."/>
                  <xsl:if test="count($feedback[@type=$type]) > 0">
                    <span class="badge"><xsl:value-of select="count($feedback[@type=$type])"/></span>
                  </xsl:if>
                </div>
              </xsl:for-each>
            </div>

            <div class="col-md-9">
              <h4>Per specific issue:</h4>
              <xsl:for-each-group select="$feedback" group-by="@id">
                <xsl:sort select="count(current-group())" order="descending"/>
                <xsl:variable name="type" select="@type[1]"/>
                <div class="list-group">
                  <xsl:attribute name="class">list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>
                  <strong><xsl:value-of select="@class[1]"/>: </strong>
                  <xsl:value-of select="data(current-group()[1])"/>
                  <span class="badge"><xsl:value-of select="count(current-group())"/></span>
                </div>
              </xsl:for-each-group>
            </div>

          </div>

          <button type="button" class="btn btn-default showdetails" data-toggle="collapse">
            <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
            Show/hide activities
          </button>

          <div class="panel panel-default collapse">
            <xsl:attribute name="id"><xsl:value-of select="current-grouping-key()"/></xsl:attribute>
            <div class="panel-body">
              <xsl:apply-templates select="current-group()[//iati-me:feedback]"/>
              <button type="button" class="btn btn-default" data-toggle="collapse">
                <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                Hide activities
              </button>
            </div>
          </div>

        </div>
      </div>

    </xsl:for-each-group>

  </xsl:template>

  <xsl:template match="iati-activity">
    <div class="container-fluid activity collapse in">
      <xsl:attribute name="issues" select="count(descendant::iati-me:feedback)>0"/>
      <xsl:attribute name="id">activity-<xsl:value-of select="position()"/></xsl:attribute>
      <div class="header" data-toggle="collapse" aria-label="Collapse">
        <xsl:attribute name="data-target">#activity-<xsl:value-of select="position()"/>-details</xsl:attribute>
        <h2>
          <xsl:value-of select="title[1]"/>
          <xsl:if test="count(descendant::iati-me:feedback[@type='info'])>0">
            <span class="badge badge-info"><xsl:value-of select="count(descendant::iati-me:feedback[@type='info'])"/></span>
          </xsl:if>
          <xsl:if test="count(descendant::iati-me:feedback[@type='warning'])>0">
            <span class="badge badge-warning"><xsl:value-of select="count(descendant::iati-me:feedback[@type='warning'])"/></span>
          </xsl:if>
          <xsl:if test="count(descendant::iati-me:feedback[@type='danger'])>0">
            <span class="badge badge-danger"><xsl:value-of select="count(descendant::iati-me:feedback[@type='danger'])"/></span>
          </xsl:if>
        </h2>
      </div>
      <div class="details collapse in">
        <xsl:attribute name="id">activity-<xsl:value-of select="position()"/>-details</xsl:attribute>
        <p>Activity <code><xsl:value-of select="functx:trim(string-join(iati-identifier/text(),''))"/></code>
        reported by <xsl:value-of select="reporting-org/(narrative|text())"/></p>

        <xsl:variable name="activity" select="."/>

        <xsl:for-each-group select="$categories" group-by="(position() -1) idiv 4">
          <div class="row">
            <xsl:for-each select="current-group()">
              <div class="col-md-3">
                <h3><xsl:value-of select="iati-me:title"/></h3>
                <xsl:variable name="class" select="string(@class)"/>
                <xsl:call-template name="feedback-list">
                  <xsl:with-param name="list" select="$activity/descendant::iati-me:feedback[@class=$class]"/>
                </xsl:call-template>
              </div>
            </xsl:for-each>
          </div>
       </xsl:for-each-group>

      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
