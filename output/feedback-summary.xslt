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
      <xsl:variable name="feedback" select="current-group()/*/iati-me:feedback"/>

      <div class="panel panel-default">
        <div class="panel-heading"><h3><xsl:value-of select="$orgName"/></h3></div>
        <div class="panel-body">
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

        </div>
      </div>

    </xsl:for-each-group>

  </xsl:template>
</xsl:stylesheet>
