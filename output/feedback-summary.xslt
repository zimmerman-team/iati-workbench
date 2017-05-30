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
    <h1>IATI Data Quality Feedback Summary</h1>

    <xsl:for-each-group select="//iati-activity" group-by="reporting-org/@ref">
      <!-- <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='danger'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='warning'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='info'])"/>
      <xsl:sort order="ascending" select="count(current-group()//iati-me:feedback[@type='success'])"/> -->
      <xsl:sort select="lower-case((current-group()/reporting-org/(narrative,.)[1])[1])"/>

      <xsl:variable name="orgName" select="(current-group()/reporting-org/(narrative,.)[1])[1]"/>
      <xsl:variable name="feedback" select="current-group()//iati-me:feedback"/>

      <div class="panel panel-default">
        <div class="panel-heading">
          <h3><xsl:value-of select="$orgName"/></h3>
          <p>
            <span class="label label-primary">
              <xsl:value-of select="count(current-group())"/>
              <xsl:choose>
                <xsl:when test="count(current-group()) = 1"> activity</xsl:when>
                <xsl:otherwise> activities</xsl:otherwise>
              </xsl:choose>
            </span>
            <xsl:text> </xsl:text>
            <span class="badge"><xsl:value-of select="count($feedback)"/> comments</span>
          </p>
        </div>

        <div class="panel-body collapse-group">
          <div class="row">
            <div class="col-md-3">

              <h4>Number of comments per severity</h4>
              <xsl:for-each select="$feedback-meta/iati-me:severities/iati-me:severity">
                <xsl:variable name="type" select="@type"/>
                <div class="list-group">
                  <xsl:attribute name="class">list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>
                  <xsl:value-of select="."/>
                  <xsl:if test="count(current-group()[.//iati-me:feedback[@type=$type]]) > 0">
                    <xsl:text> </xsl:text>
                    <span class="label label-primary">
                      <xsl:value-of select="count(current-group()[.//iati-me:feedback[@type=$type]])"/>
                      <xsl:choose>
                        <xsl:when test="count(current-group()[.//iati-me:feedback[@type=$type]]) = 1"> activity</xsl:when>
                        <xsl:otherwise> activities</xsl:otherwise>
                      </xsl:choose>
                    </span>
                  </xsl:if>
                  <xsl:if test="count($feedback[@type=$type]) > 0">
                    <span class="badge"><xsl:value-of select="count($feedback[@type=$type])"/></span>
                  </xsl:if>
                </div>
              </xsl:for-each>

              <div class="list-group list-group-item">
                No comments
                <xsl:if test="count(current-group()[not(.//iati-me:feedback)]) > 0">
                  <span class="badge"><xsl:value-of select="count(current-group()[not(.//iati-me:feedback)])"/></span>
                </xsl:if>
              </div>

              <h4>Number of comments per type</h4>
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

            <div class="col-md-9">
              <button type="button" class="btn btn-default showdetails" data-toggle="collapse">
                <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                Show/hide activities with comments
              </button>

              <div class="panel panel-default collapse">
                <xsl:attribute name="id"><xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                <div class="panel-body">
                  <table class="table table-condensed details">
                    <xsl:apply-templates select="current-group()[//iati-me:feedback]"/>
                  </table>
                  <button type="button" class="btn btn-default" data-toggle="collapse">
                    <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                    Hide activities
                  </button>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>

    </xsl:for-each-group>

  </xsl:template>

  <!-- skip activities without feedback -->
  <xsl:template match="iati-activity[not(.//iati-me:feedback)]"/>

  <xsl:template match="iati-activity">
    <div class="container-fluid activity collapse">
      <xsl:attribute name="issues" select="count(.//iati-me:feedback)>0"/>
      <xsl:attribute name="id">activity-<xsl:value-of select="position()"/></xsl:attribute>

      <tr data-toggle="collapse" aria-label="Collapse">
        <xsl:attribute name="data-target">#activity-<xsl:value-of select="position()"/>-details</xsl:attribute>
        <th>
          <h3><xsl:value-of select="title[1]"/></h3>
          <div>
            <code><xsl:value-of select="functx:trim(string-join(iati-identifier/text(),''))"/></code>
            <xsl:if test="count(descendant::iati-me:feedback[@type='danger'])>0">
              <span class="label label-danger"><xsl:value-of select="count(descendant::iati-me:feedback[@type='danger'])"/></span>
            </xsl:if>
            <xsl:if test="count(descendant::iati-me:feedback[@type='warning'])>0">
              <span class="label label-warning"><xsl:value-of select="count(descendant::iati-me:feedback[@type='warning'])"/></span>
            </xsl:if>
            <xsl:if test="count(.//iati-me:feedback[@type='info'])>0">
              <span class="label label-info"><xsl:value-of select="count(.//iati-me:feedback[@type='info'])"/></span>
            </xsl:if>
          </div>
        </th>
      </tr>
      <tbody>
        <xsl:attribute name="id">activity-<xsl:value-of select="position()"/>-details</xsl:attribute>
        <xsl:for-each-group select="descendant::iati-me:feedback" group-by="@class">
          <xsl:sort select="count(current-group())" order="descending"/>
          <tr>
            <th><xsl:value-of select="$categories[@class=current-grouping-key()][1]/iati-me:title"/></th>
          </tr>
          <xsl:call-template name="feedback-list">
            <xsl:with-param name="list" select="current-group()"/>
          </xsl:call-template>
        </xsl:for-each-group>
      </tbody>
    </div>
  </xsl:template>

  <xsl:template name="feedback-list">
    <xsl:param name="list"/>
    <xsl:choose>
      <xsl:when test="$list">
        <xsl:apply-templates select="$list"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="iati-me:feedback">
    <xsl:variable name="src" select="@src"/>
    <tr><td>
      <xsl:attribute name="class"><xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates select="$feedback-meta/iati-me:sources/iati-me:source[@src=$src]/@logo"/>
      <xsl:apply-templates select="@href"/>
      <div class="context"><xsl:apply-templates select="." mode="context"/>
      <xsl:copy-of select="*|text()"/></div>
    </td></tr>
  </xsl:template>

</xsl:stylesheet>
