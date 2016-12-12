<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:y='http://www.yworks.com/xml/graphml' xmlns:g='http://graphml.graphdrawing.org/xmlns'>

<!--
<h1>Transform generic, annotated GraphML into an yEd GraphML.</h1>
-->

  <xsl:template match="g:graphml">
    <g:graphml>
      <g:key for="node" id="ynode" yfiles.type="nodegraphics"/>
      <g:key for="edge" id="yedge" yfiles.type="edgegraphics"/>
      <g:key for="node" id="url" attr.name="url" attr.type="string"/>

      <xsl:apply-templates/>
    </g:graphml>
  </xsl:template>

  <xsl:template match="g:graph">
    <g:graph>
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates/>
    </g:graph>
  </xsl:template>

  <xsl:template match="g:node[g:data[@key='type' and text()='organisation']]">
    <g:node yfiles.foldertype="group">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates select="g:data" mode="copy"/>
      <xsl:if test="g:data[@key='ref']!=''">
        <g:data key="url">http://d-portal.org/ctrack.html?publisher=<xsl:value-of select="g:data[@key='ref']"/>#view=publisher</g:data>
      </xsl:if>
      <g:data key="ynode">
        <y:ProxyAutoBoundsNode>
          <y:Realizers active="0">
            <y:GroupNode>
              <y:Shape type="roundrectangle"/>
              <y:Geometry height="80.0" width="220.0"/>
              <y:Fill color="#F6F6FF" transparent="false"/>
              <y:BorderStyle color="#0000FF" type="dashed" width="1.0"/>
              <y:State closed="false" closedHeight="80.0" closedWidth="200.0" innerGraphDisplayEnabled="false"/>
              <y:Insets bottom="25" bottomF="25.0" left="15" leftF="15.0" right="15" rightF="15.0" top="25" topF="25.0"/>
              <y:NodeLabel autoSizePolicy="content" modelName="internal" modelPosition="t" fontFamily="Alegreya Sans" fontSize="12" textColor="#000000">
                <xsl:value-of select="g:data[@key='label']"/>
              </y:NodeLabel>
              <y:NodeLabel autoSizePolicy="content" modelName="internal" modelPosition="br" fontFamily="Alegreya Sans" fontSize="10" textColor="#000000">
                <xsl:value-of select="g:data[@key='iati-id']"/>
              </y:NodeLabel>
            </y:GroupNode>
          </y:Realizers>
        </y:ProxyAutoBoundsNode>
      </g:data>
      <xsl:apply-templates select="g:graph"/>
    </g:node>
  </xsl:template>

  <xsl:template match="g:node[g:data[@key='type' and text()='activity']]">
    <xsl:call-template name="activity"/>
  </xsl:template>

  <xsl:template match="g:node[g:data[@key='type' and text()='activity-reference']]">
    <xsl:call-template name="activity">
      <xsl:with-param name="titleStyle">italic</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="g:edge">

      <xsl:choose>
        <xsl:when test="g:data[@key='type' and text()='parent-child']">
          <xsl:call-template name="edge">
            <xsl:with-param name="lineWidth">3.0</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="g:data[@key='type' and text()='1']">
          <xsl:call-template name="edge">
            <xsl:with-param name="color">#ff0000</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="g:data[@key='type' and text()='2']">
          <xsl:call-template name="edge">
            <xsl:with-param name="color">#00AA00</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="g:data[@key='type' and text()='3']">
          <xsl:call-template name="edge">
            <xsl:with-param name="color">#00AA00</xsl:with-param>
            <xsl:with-param name="lineStyle">dashed</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="g:data[@key='type' and text()='4']">
          <xsl:call-template name="edge">
            <xsl:with-param name="color">#0000FF</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="edge">
            <xsl:with-param name="lineStyle">dotted</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- HELPER TEMPLATES -->

  <!-- copy elements or attributes -->
  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>

  <!-- yEd edge template -->
  <xsl:template name="edge">
    <xsl:param name="color">#000000</xsl:param>
    <xsl:param name="arrowSource">none</xsl:param>
    <xsl:param name="arrowTarget">standard</xsl:param>
    <xsl:param name="lineStyle">line</xsl:param>
    <xsl:param name="lineWidth">1.0</xsl:param>

    <g:edge>
      <xsl:apply-templates select="@*" mode="copy"/>
      <g:data key="yedge">
        <y:PolyLineEdge>
          <y:LineStyle color="{$color}" type="{$lineStyle}" width="{$lineWidth}"/>
          <y:Arrows source="{$arrowSource}" target="{$arrowTarget}"/>
          <y:BendStyle smoothed="true"/>
        </y:PolyLineEdge>
      </g:data>
    </g:edge>
  </xsl:template>

  <!-- yEd node template for activity -->
  <xsl:template name="activity">
    <xsl:param name="color">#0000FF</xsl:param>
    <xsl:param name="titleColor">#FFFFFF</xsl:param>
    <xsl:param name="titleFont">Alegreya Sans</xsl:param>
    <xsl:param name="titleStyle">plain</xsl:param>
    <xsl:param name="refColor">#BBBBFF</xsl:param>
    <xsl:param name="refFont">Alegreya Sans</xsl:param>
    <xsl:param name="refStyle">plain</xsl:param>

    <g:node>
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates select="g:data" mode="copy"/>
      <g:data key="url">http://d-portal.org/ctrack.html?publisher=<xsl:value-of select="../../g:data[@key='ref']"/>#view=act&amp;aid=<xsl:value-of select="g:data[@key='ref']"/></g:data>
      <g:data key="ynode">
        <y:ShapeNode>
          <y:Shape type="rectangle"/>
          <y:Geometry height="80.0" width="220.0"/>
          <y:Fill color="{$color}" transparent="false"/>
          <y:BorderStyle hasColor="false" type="line" width="1.0"/>
          <y:NodeLabel autoSizePolicy="content" modelName="internal" modelPosition="t" fontFamily="{$titleFont}" fontStyle="{$titleStyle}" fontSize="14" textColor="{$titleColor}">
            <xsl:value-of select="g:data[@key='label']"/>
          </y:NodeLabel>
          <y:NodeLabel autoSizePolicy="content" modelName="internal" modelPosition="br" fontFamily="{$refFont}" fontStyle="{$refStyle}" fontSize="12" textColor="{$refColor}">
            <xsl:value-of select="g:data[@key='iati-id']"/>
          </y:NodeLabel>
        </y:ShapeNode>
      </g:data>
    </g:node>
  </xsl:template>

</xsl:stylesheet>
