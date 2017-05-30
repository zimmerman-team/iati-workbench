<?xml version="1.0" encoding="UTF-8"?>
<!--
  Stylesheet with default components to provide feedback.
-->

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  xmlns:iati-me="http://iati.me"
  exclude-result-prefixes="">

  <xsl:variable name="feedback-meta" select="document('../../augment/rules/meta.xml')/iati-me:meta"/>

  <xsl:template match="iati-me:feedback">
    <xsl:variable name="src" select="@src"/>
    <div role="alert">
      <xsl:attribute name="class">alert alert-dismissable
        alert-<xsl:value-of select="@type"/>
        <xsl:if test="@src"> src-<xsl:value-of select="@src"/></xsl:if>
      </xsl:attribute>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
      <xsl:apply-templates select="$feedback-meta/iati-me:sources/iati-me:source[@src=$src]/@logo"/>
      <xsl:apply-templates select="@href"/>
      <div class="context"><xsl:apply-templates select="." mode="context"/></div>
      <xsl:copy-of select="*|text()"/>
    </div>
  </xsl:template>

  <xsl:template match="@logo">
    <img class="logo" src="{.}"/>
  </xsl:template>

  <xsl:template match="@href">
    <a target="_blank" class="bookmark glyphicon glyphicon-new-window" href="{.}"/>
  </xsl:template>

  <xsl:template name="feedback-list">
    <xsl:param name="list"/>
    <div class="feedback-list">
      <xsl:choose>
        <xsl:when test="$list">
          <xsl:apply-templates select="$list"/>
        </xsl:when>
        <xsl:otherwise>
          <div role="alert" class="alert alert-dismissable alert-success">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
            No issues reported.
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="feedback-list-type">
    <xsl:param name="feedback"/>

      <h3>Issue severity:</h3>
      <div class="list-group">
        <xsl:for-each select="$feedback-meta/iati-me:severities/iati-me:severity">
          <xsl:variable name="type" select="@type"/>
          <div>
            <xsl:attribute name="class">checkbox list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>
            <label class="checkbox-custom" data-initialize="checkbox">
              <input class="sr-only" type="checkbox" checked="checked">
                <xsl:attribute name="data-toggle">.feedback-list .alert-<xsl:value-of select="$type"/></xsl:attribute>
              </input>
              <xsl:value-of select="."/>
            </label>
            <xsl:if test="count($feedback[@type=$type]) > 0">
              <span class="badge"><xsl:value-of select="count($feedback[@type=$type])"/></span>
            </xsl:if>
          </div>
        </xsl:for-each>
      </div>

  </xsl:template>

  <xsl:template name="feedback-list-src">
    <xsl:param name="feedback"/>

    <h3>Rules and guidelines by:</h3>

    <div class="list-group">
      <xsl:for-each select="$feedback-meta/iati-me:sources/iati-me:source">
        <xsl:variable name="src" select="@src"/>
        <div class="checkbox list-group-item">
          <label class="checkbox-custom" data-initialize="checkbox">
            <input class="sr-only" type="checkbox" checked="checked">
              <xsl:attribute name="data-toggle">.feedback-list .src-<xsl:value-of select="$src"/></xsl:attribute>
            </input>
            <xsl:value-of select="."/>
          </label>
          <xsl:choose>
            <xsl:when test="@src">
              <xsl:if test="count($feedback[@src=$src]) > 0">
                <span class="badge"><xsl:value-of select="count($feedback[@src=$src])"/></span>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <span class="badge"><xsl:value-of select="count($feedback[not(@src)])"/></span>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="@logo"/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="show-organisation">
    <xsl:choose>
      <xsl:when test="../@ref"><code><xsl:value-of select="../@ref"/></code></xsl:when>
      <xsl:otherwise>"<xsl:value-of select="functx:trim(string-join((../text(),../narrative[1]/.),''))"/>"</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Context information for reporting-org -->
  <xsl:template match="reporting-org/iati-me:feedback" mode="context">
    <xsl:variable name="ref">
    </xsl:variable>
    In <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/>:
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="participating-org/iati-me:feedback" mode="context">
    In <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/> (role <code><xsl:value-of select="../@role"/></code>):
  </xsl:template>

  <!-- Context information for transactions -->
  <xsl:template match="transaction/iati-me:feedback" mode="context">
    In
    <xsl:choose>
      <xsl:when test="../transaction-type/@code='1'">incoming funds</xsl:when>
      <xsl:when test="../transaction-type/@code='2'">(outgoing) commitment</xsl:when>
      <xsl:when test="../transaction-type/@code='3'">disbursement</xsl:when>
      <xsl:when test="../transaction-type/@code='4'">expenditure</xsl:when>
      <xsl:when test="../transaction-type/@code='11'">incoming commitment</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    transaction of <xsl:value-of select="../transaction-date/@iso-date"/>:
  </xsl:template>

  <!-- Context information for provider-org and receiver-org in transactions -->
  <xsl:template match="provider-org/iati-me:feedback|receiver-org/iati-me:feedback" mode="context">
    In transaction of <xsl:value-of select="../../transaction-date/@iso-date"/> for <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/>:
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="document-link/iati-me:feedback" mode="context">
    For the document <a href="{../@url}"><xsl:value-of select="functx:trim(../title/.)"/></a>:
  </xsl:template>

  <!-- Context information for result indicator -->
  <xsl:template match="indicator/iati-me:feedback" mode="context">
    For the indicator "<em><xsl:value-of select="functx:trim(../title/narrative[1])"/></em>":
  </xsl:template>

  <xsl:template match="@*|node()" mode="context">
  </xsl:template>

</xsl:stylesheet>
