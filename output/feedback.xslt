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
    <h1>IATI Data Quality Feedback</h1>
    <p>Overview of the activities, reporting possible issues in the data.</p>
    <p>This page is intended to help you fix the issues:</p>
    <ul>
      <li>Filter the view to focus on issues.</li>
      <li>You can 'close' an issue to have it disappear.</li>
      <li>Reload the page to show all issues again.</li>
    </ul>
    <p><strong>This is mostly a front-end demo for now. It shows a very limited number of checks. Contact rolf@drostan.org if you want to sponsor further development and get a report on your data :-)</strong></p>

    <div class="panel panel-default">
      <div class="panel-heading">Show or hide reported issues</div>
      <div class="panel-body">
        <div class="row">
          <div class="col-md-6">
            <xsl:call-template name="feedback-list-type">
              <xsl:with-param name="feedback" select="//iati-me:feedback"/>
            </xsl:call-template>
          </div>

          <div class="col-md-6">
            <xsl:call-template name="feedback-list-src">
              <xsl:with-param name="feedback" select="//iati-me:feedback"/>
            </xsl:call-template>
          </div>
        </div>

        <button type="button" class="btn btn-default" data-toggle="collapse" data-target=".activity .collapse.in">Show only activity titles</button>
        <button type="button" class="btn btn-default" data-toggle="collapse" data-target=".activity .collapse[aria-expanded=false]">Show all activity details</button>
        <button type="button" class="btn btn-default" data-toggle="collapse" data-target=".activity.collapse.in[issues=false]">
          Show only activities with issues
          <span class="badge"><xsl:value-of select="count(//iati-activity[count(descendant::iati-me:feedback)>0])"/></span>
        </button>
        <button type="button" class="btn btn-default" data-toggle="collapse" data-target=".activity.collapse[aria-expanded=false]">
          Show all activities
          <span class="badge"><xsl:value-of select="count(//iati-activity)"/></span>
        </button>
      </div>
    </div>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="iati-activities">
    <div class="container-fluid activity collapse in">
      <xsl:attribute name="issues" select="count(iati-me:feedback)>0"/>
      <xsl:attribute name="id">activities</xsl:attribute>
      <div class="header" data-toggle="collapse" aria-label="Collapse">
        <xsl:attribute name="data-target">#activities-details</xsl:attribute>
        <h2>
          About the complete dataset
          <xsl:if test="count(iati-me:feedback[@type='info'])>0">
            <span class="badge badge-info"><xsl:value-of select="count(iati-me:feedback[@type='info'])"/></span>
          </xsl:if>
          <xsl:if test="count(iati-me:feedback[@type='warning'])>0">
            <span class="badge badge-warning"><xsl:value-of select="count(iati-me:feedback[@type='warning'])"/></span>
          </xsl:if>
          <xsl:if test="count(iati-me:feedback[@type='danger'])>0">
            <span class="badge badge-danger"><xsl:value-of select="count(iati-me:feedback[@type='danger'])"/></span>
          </xsl:if>
        </h2>
      </div>
      <div class="details collapse in">
        <xsl:attribute name="id">activities-details</xsl:attribute>
        <p>Issues and feedback over the dataset as a whole.</p>

        <xsl:variable name="activity" select="."/>

        <xsl:for-each-group select="$categories" group-by="(position() -1) idiv 4">
          <div class="row">
            <xsl:for-each select="current-group()">
              <div class="col-md-3">
                <h3><xsl:value-of select="iati-me:title"/></h3>
                <xsl:variable name="class" select="string(@class)"/>
                <xsl:call-template name="feedback-list">
                  <xsl:with-param name="list" select="$activity/iati-me:feedback[@class=$class]"/>
                </xsl:call-template>
              </div>
            </xsl:for-each>
          </div>
        </xsl:for-each-group>

      </div>
    </div>

    <xsl:apply-templates select="iati-activity"/>
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
