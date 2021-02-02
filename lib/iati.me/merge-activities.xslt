<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:merge="http://iati.me/merge"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx merge">

  <xsl:import href="../functx.xslt"/>
  <xsl:output indent="yes"/>

  <xsl:template match="/dir">
    <iati-activities version="2.03" generated-datetime="{current-dateTime()}" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xsi:noNamespaceSchemaLocation="http://iatistandard.org/203/schema/downloads/iati-activities-schema.xsd">
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment>Data4Development Spreadsheets2IATI converter service https://data4development.nl</xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:for-each-group select="document(f/@n[ends-with(.,'.generated.xml')])//iati-activity" group-by="functx:trim(@merge:id)">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:if test="not(@merge:exclude='true')">
          <iati-activity>
            <xsl:copy-of select="current-group()/@*[.!='' and not(name(.)=('merge:id', 'merge:exclude'))]" />
            <!-- <xsl:for-each-group select="current-group()/@*[.!='' and name(.)!='merge:id']" group-by="name(.)">
              <xsl:copy-of select=".[1]" />
            </xsl:for-each-group> -->
            <iati-identifier><xsl:copy-of select="current-grouping-key()"/></iati-identifier>
            <xsl:apply-templates select="(current-group()/reporting-org)[1]"/>

            <title>
              <xsl:apply-templates select="current-group()/title/narrative"/>
            </title>

            <!-- <xsl:for-each-group select="current-group()/description" group-by="@type"> -->
              <xsl:apply-templates select="current-group()/description"/>
            <!-- </xsl:for-each-group> -->

            <xsl:for-each-group select="current-group()/participating-org" group-by="@role">
              <!-- all orgs with refs -->
              <xsl:for-each-group select="current-group()[@ref!='']" group-by="@ref">
                <xsl:apply-templates select="current-group()[1]"/>
              </xsl:for-each-group>
              <!-- all orgs without refs -->
              <xsl:for-each-group select="current-group()[not(@ref) or @ref='']" group-by="narrative[1]">
                <xsl:apply-templates select="current-group()"/>
              </xsl:for-each-group>
            </xsl:for-each-group>

            <xsl:apply-templates select="current-group()/other-identifier"/>
            <xsl:for-each-group select="current-group()/activity-status[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>

            <xsl:for-each-group select="current-group()/activity-date[@iso-date!='']" group-by="@type">
              <xsl:sort select="@iso-date"/>
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>

            <xsl:apply-templates select="current-group()/contact-info"/>
            <xsl:for-each-group select="current-group()/activity-scope[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>
            <xsl:apply-templates select="current-group()/recipient-country[@code!='' and (@percentage!='0' or not(@percentage))]"/>
            <xsl:apply-templates select="current-group()/recipient-region[@code!='']"/>
            <xsl:apply-templates select="current-group()/location"/>
            <xsl:apply-templates select="current-group()/sector"/>
            <xsl:apply-templates select="current-group()/country-budget-items"/>
            <xsl:apply-templates select="current-group()/humanitarian-scope"/>
            <xsl:apply-templates select="current-group()/policy-marker"/>

            <xsl:for-each-group select="current-group()/collaboration-type[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="current-group()/default-flow-type[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="current-group()/default-finance-type[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="current-group()/default-aid-type[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="current-group()/default-tied-status[@code!='']" group-by="@code">
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:for-each-group>

            <xsl:for-each-group select="current-group()/budget" group-by="@type">
              <!-- TODO split by @status as well -->
              <xsl:apply-templates select="current-group()"/>
            </xsl:for-each-group>

            <xsl:apply-templates select="current-group()/planned-disbursement"/>
            <xsl:apply-templates select="current-group()/capital-spend"/>
            <xsl:apply-templates select="current-group()/transaction[transaction-type/@code!='' and value!='']"/>
            <xsl:apply-templates select="current-group()/document-link[@url!='']"/>
            <xsl:apply-templates select="current-group()/related-activity[@ref!='']"/>

            <xsl:if test="current-group()/conditions/condition/narrative">
              <conditions attached="1">
                <xsl:for-each-group select="current-group()/conditions/condition" group-by="@type">
                  <xsl:variable name="ctype" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="narrative">
                      <condition type="{$ctype}">
                        <narrative>
                          <!-- TODO add language -->
                          <xsl:value-of select="current-grouping-key()"/>
                        </narrative>
                      </condition>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </conditions>
            </xsl:if>

            <xsl:for-each-group select="current-group()/result" group-by="@merge:id">
              <xsl:if test="current-group()/indicator/title/narrative/text() and current-group()/@type">
                <result>
                  <xsl:copy-of select="current-group()/@*[.!='' and name(.)!='merge:id']" />
                  <!-- TODO find the proper way to avoid duplicates... this may eliminate multiple language versions -->
                  <xsl:apply-templates select="(current-group()/title)[1]"/>
                  <xsl:apply-templates select="(current-group()/description)[1]"/>
                  <xsl:apply-templates select="current-group()/*[not(name()=('title', 'description', 'indicator'))]"/>
                  <xsl:for-each-group select="current-group()/indicator" group-by="@merge:id">
                    <indicator>
                      <!-- <xsl:copy-of select="@*[.!='' and name(.)!='merge:id']" /> -->
                      <xsl:copy-of select="current-group()/@*[.!='' and name(.)!='merge:id']"/>
                      <!-- TODO find the proper way to avoid duplicates... this may eliminate multiple language versions, and multiple baselines versions -->
                      <xsl:apply-templates select="(current-group()/title)[1]"/>
                      <xsl:apply-templates select="(current-group()/description)[1]"/>
                      <xsl:for-each-group select="current-group()/reference" group-by="@vocabulary">
                        <xsl:for-each-group select="." group-by="@code">
                          <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each-group>
                      </xsl:for-each-group>
                      <!-- <xsl:apply-templates select="current-group()/reference"/> -->
                      <xsl:for-each-group select="current-group()/baseline" group-by="@merge:id">
                        <baseline>
                          <xsl:copy-of select="current-group()/@*[.!='' and name(.)!='merge:id']" />
                          <xsl:apply-templates select="current-group()[1]/dimension"/>
                          <xsl:apply-templates select="current-group()[1]/comment"/>
                        </baseline>
                      </xsl:for-each-group>
                      <xsl:apply-templates select="current-group()/*[not(name()=('title', 'description', 'baseline', 'reference'))]"/>
                      <!-- <xsl:copy-of select="current-group()/*[not(name()=('title', 'description', 'baseline'))]" copy-namespaces="no"/> -->
                      <!-- <xsl:apply-templates select="current-group()/*"/> -->
                    </indicator>
                  </xsl:for-each-group>
                </result>
              </xsl:if>
            </xsl:for-each-group>

            <xsl:apply-templates select="current-group()/resultcrs-add"/>
            <xsl:apply-templates select="current-group()/fss"/>
          </iati-activity>
        </xsl:if>
      </xsl:for-each-group>
    </iati-activities>
  </xsl:template>

  <!-- ignore these elements: -->
  <xsl:template match="narrative            [not(text())]"/>

  <!-- text elements without any narrative element with actual content -->
  <xsl:template match="title                [not(narrative!='')]"/>
  <xsl:template match="description          [not(narrative!='')]"/>
  <xsl:template match="comment              [not(narrative!='')]"/>
  <xsl:template match="condition            [not(narrative!='')]"/>
  <xsl:template match="organisation         [not(narrative!='')]"/>
  <xsl:template match="department           [not(narrative!='')]"/>
  <xsl:template match="person-name          [not(narrative!='')]"/>
  <xsl:template match="job-title            [not(narrative!='')]"/>
  <xsl:template match="mailing-address      [not(narrative!='')]"/>
  <xsl:template match="name                 [not(narrative!='')]"/>
  <xsl:template match="activity-description [not(narrative!='')]"/>

  <xsl:template match="telephone[.='']"/>
  
  <xsl:template match="provider-org[not(@*[.!='']) and not(narrative!='')]"/>
  <xsl:template match="receiver-org[not(@*[.!='']) and not(narrative!='')]"/>
  
  <!-- targets or actuals without values -->
  <xsl:template match="target[not(@value) or @value='']"/>
  <xsl:template match="actual[not(@value) or @value='']"/>

  <!-- <xsl:template match="collaboration-type   [@code=(parent::collaboration-type/@code)]"/> -->
  <!-- <xsl:template match="collaboration-type">
    <collaboration-type code="{@code}">
      <xsl:copy-of select="parent::*[name()='collaboration-type']"/>
    </collaboration-type>
  </xsl:template> -->

  <!-- copy the rest -->
  <!-- <xsl:template match="*[not(functx:is-node-in-sequence-deep-equal(.,preceding-sibling::*)) and not(name()='dir')]"> -->
  <xsl:template match="*">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[.!='']"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
