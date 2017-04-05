<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0'
  xmlns:functx="http://www.functx.com"
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'>

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="bootstrap.xslt"/>
  <xsl:output method="html" encoding="UTF-8" indent="yes" use-character-maps="latin1"/>

  <xsl:template match="/" mode="html-body">
    <xsl:apply-templates select="//iati-activity">
      <xsl:with-param name="iati-activities" select="//iati-activity" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="iati-activity">
    <xsl:result-document method="html" href="{encode-for-uri(iati-identifier)}.html">
      <!-- <xsl:apply-templates select="." mode="file"/> -->
      <xsl:call-template name="bootstrap-file"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="iati-activity" mode="html-head">
    <xsl:param name="iati-activities" tunnel="yes"/>
    <title><xsl:value-of select="(title/narrative,title)[1]"/></title>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript"><![CDATA[
      google.charts.load('current', {packages:['corechart', 'orgchart', 'geochart', 'calendar']});
      google.charts.setOnLoadCallback(drawCharts);

      function drawCharts() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'ID');
        data.addColumn('string', 'Parent');
        data.addColumn('string', 'ToolTip');

        data.addRows([
        ]]>
          <xsl:apply-templates select="." mode="chart-data-row"/>
          <xsl:variable name="childrenIds" select="distinct-values((
              related-activity[@type='2']/@ref,
              $iati-activities[related-activity[@ref=data(current()/iati-identifier) and @type='1']]/iati-identifier
            ))"/>
          <!-- add children to the data -->
          <xsl:apply-templates select="$iati-activities[data(iati-identifier)=$childrenIds]" mode="chart-data-row"/>

        <![CDATA[
        ]);

        data.setRowProperty(0, 'style', 'background: #ffff00');

        // Create the chart.
        var chart = new google.visualization.OrgChart(document.getElementById('chart_activities'));
        // Draw the chart, setting the allowHtml option to true for the tooltips.
        chart.draw(data, {allowHtml:true});

        var geodata = google.visualization.arrayToDataTable([
          ['Country', 'Percentage'],
        ]]>
          <xsl:apply-templates select="recipient-country" mode="chart-data-row"/>
        <![CDATA[
        ]);

        var geooptions = {
          colorAxis: {minValue:0, maxValue:100, colors:['yellow','green']},
        ]]>
        <xsl:variable name="regions" select="document('../iati.me/geo.xml')/(
          countries/country[@code=current()/recipient-country/@code],
          regions/region[@code=current()/recipient-region/@code]
          )"/>
        <xsl:choose>
          <xsl:when test="count(distinct-values($regions/@region)) eq 1">'region': '<xsl:value-of select="($regions/@region)[1]"/>'</xsl:when>
          <xsl:when test="count(distinct-values($regions/@continent)) eq 1">'region': '<xsl:value-of select="($regions/@continent)[1]"/>'</xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <![CDATA[
        };
        var geochart = new google.visualization.GeoChart(document.getElementById('regions_div'));
        geochart.draw(geodata, geooptions);

        var dacdata = google.visualization.arrayToDataTable([
          ['Sector', 'Percentage'],
        ]]>
          <xsl:apply-templates select="sector[not(@vocabulary) or @vocabulary=('1','2')]" mode="chart-data-row">
            <xsl:sort select="@percentage"/>
          </xsl:apply-templates>
        <![CDATA[
        ]);

        var dacoptions = {
          pieHole: 0.4,
        };

        var dacchart = new google.visualization.PieChart(document.getElementById('dacchart'));
        dacchart.draw(dacdata, dacoptions);
        ]]>

        <xsl:variable name="minValue" select="min((transaction/value,0))"/>
        <xsl:variable name="maxValue" select="max(transaction/value)"/>
        <xsl:for-each-group select="transaction" group-by="transaction-type/@code">
          <xsl:sort select="current-grouping-key()" data-type="number"/>
          var findata<xsl:value-of select="current-grouping-key()"/> = google.visualization.arrayToDataTable([
            ['Date', 'Amount'],
            <xsl:apply-templates select="current-group()" mode="chart-data-row">
              <xsl:sort select="transaction-date/@iso-date"/>
            </xsl:apply-templates>
          ]);

          var finoptions<xsl:value-of select="current-grouping-key()"/> = {
            calendar: { cellSize: 8.9 },
            colorAxis: {
              minValue: <xsl:value-of select="$minValue"/>,
              maxValue: <xsl:value-of select="$maxValue"/>,
              colors: ['yellow', 'green']
            },
            noDataPattern: {
              backgroundColor: '#eeeeee',
              color: '#eeeeee'
            },
            height:
              <xsl:value-of select='30+80*(1+
                year-from-date(reverse(functx:sort(current-group()/transaction-date/@iso-date))[1])-
                year-from-date(functx:sort(current-group()/transaction-date/@iso-date)[1]))'/>
          };

          var finchart<xsl:value-of select="current-grouping-key()"/> = new google.visualization.Calendar(document.getElementById('financials<xsl:value-of select="current-grouping-key()"/>'));
          finchart<xsl:value-of select="current-grouping-key()"/>.draw(findata<xsl:value-of select="current-grouping-key()"/>, finoptions<xsl:value-of select="current-grouping-key()"/>);
        </xsl:for-each-group>
      }
   </script>
  </xsl:template>

  <xsl:template match="iati-activity" mode="chart-data-row">
    <xsl:param name="childDone" select="''"/>
    <xsl:param name="iati-activities" tunnel="yes"/>
    <!-- find possible parents -->
    <xsl:variable name="parent" select="(related-activity[@type='1']/@ref,
        $iati-activities[related-activity[@ref=current()/iati-identifier and @type='2']]/iati-identifier
      )[1]"/>

    [{
      v:'<xsl:value-of select="iati-identifier"/>',
      f:'<a href="{encode-for-uri(iati-identifier)}.html"><xsl:apply-templates select="title" mode="narrative"/></a>'
    }, '<xsl:value-of select="$parent"/>', ''],

    <!-- add the parent to the data -->
    <xsl:apply-templates select="$iati-activities[iati-identifier=$parent]" mode="chart-data-row">
      <xsl:with-param name="childDone" select="data(iati-identifier)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="recipient-country|sector" mode="chart-data-row">
    ['<xsl:value-of select="upper-case(@code)"/>', <xsl:value-of select="(@percentage,'100')[1]"/>],
  </xsl:template>

  <xsl:template match="transaction" mode="chart-data-row">
    [new Date(
      <xsl:value-of select="format-date(transaction-date/@iso-date, '[Y]')"/>,
      <xsl:value-of select="format-date(transaction-date/@iso-date, '[M]')"/>,
      <xsl:value-of select="format-date(transaction-date/@iso-date, '[D]')"/>
      ),
      <xsl:value-of select="value"/>
    ],
  </xsl:template>

  <xsl:template match="iati-activity" mode="html-body">
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
            <li><a href="#">Home</a></li>
            <xsl:if test="./preceding-sibling::iati-activity[1]">
              <li><a href="{encode-for-uri(./preceding-sibling::iati-activity[1]/iati-identifier)}.html"
                title="{./preceding-sibling::iati-activity[1]/title/narrative[1]}">Previous activity</a></li>
            </xsl:if>
            <xsl:if test="./following-sibling::iati-activity[1]">
              <li><a href="{encode-for-uri(./following-sibling::iati-activity[1]/iati-identifier)}.html"
                title="{./following-sibling::iati-activity[1]/title/narrative[1]}">Next activity</a></li>
            </xsl:if>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>

    <div class="container" role="main">
      <!-- create tabs for different language versions -->
      <xsl:variable name="languagesRaw" select="distinct-values((@xml:lang,//@xml:lang[.!='']))"/>
      <xsl:variable name="languages" as="xs:string*">
        <xsl:for-each select="$languagesRaw">
          <xsl:sequence select="lower-case(.)"/>
        </xsl:for-each>
      </xsl:variable>

      <ul class="nav nav-tabs">
        <xsl:for-each select="$languages">
          <li>
            <xsl:if test="position()=1">
              <xsl:attribute name="class" select="'active'"/>
            </xsl:if>
            <a data-toggle="tab" href="#{.}"><xsl:value-of select="."/></a>
          </li>
        </xsl:for-each>
      </ul>
      <div class="tab-content">
        <xsl:apply-templates select="." mode="language-versions">
          <xsl:with-param name="languages" select="$languages"/>
          <xsl:with-param name="active" select="true()"/>
          <xsl:with-param name="default-lang" select="$languages[1]" tunnel="yes"/>
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="iati-activity" mode="language-versions">
    <xsl:param name="languages"/>
    <xsl:param name="active" select="false()"/>
    <div id="{$languages[1]}" class="tab-pane fade in">
      <xsl:if test="$active">
        <xsl:attribute name="class" select="'tab-pane fade in active'"/>

      </xsl:if>
      <xsl:apply-templates select="." mode="language-version">
        <xsl:with-param name="lang" select="$languages[1]" tunnel="yes"/>
      </xsl:apply-templates>
    </div>

    <xsl:if test="count($languages)>1">
      <xsl:apply-templates select="." mode="language-versions">
        <xsl:with-param name="languages" select="remove($languages,1)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="iati-activity" mode="language-version">
    <p/>
    <div class="jumbotron">
      <h1 title="{iati-identifier}">
        <xsl:apply-templates select="title" mode="narrative"/>
      </h1>
      <p title='{reporting-org/@ref}'>
        <xsl:apply-templates select="reporting-org" mode="narrative"/>
      </p>
    </div>

    <div class="row">
      <div class="col-md-6">
        <xsl:apply-templates select="description">
          <xsl:sort select="@type"/>
        </xsl:apply-templates>

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Financial details</h3>
          </div>
          <div class="panel-body" style="overflow: scroll">
            <xsl:variable name="act" select="."/>
            <xsl:for-each select="('11','2','1','3','4')">
              <xsl:if test=".=($act/transaction/transaction-type/@code)">
                <h3 class="panel-title">
                  <xsl:choose>
                    <xsl:when test=".='1'">Incoming funds</xsl:when>
                    <xsl:when test=".='2'">Outgoing commitments</xsl:when>
                    <xsl:when test=".='3'">Disbursements</xsl:when>
                    <xsl:when test=".='4'">Expenditure</xsl:when>
                    <xsl:when test=".='11'">Incoming commitments</xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                  </xsl:choose>
                </h3>
                <div id="financials{.}"/>
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Details</h3>
          </div>
          <div class="panel-body">
            <table class="table">
              <caption>Lifespan</caption>
              <thead>
                <tr>
                  <th></th>
                  <th>Start</th>
                  <th>End</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Planned</td>
                  <td><xsl:apply-templates select="activity-date[@type='1'][1]" mode="format-date"/></td>
                  <td><xsl:apply-templates select="activity-date[@type='3'][1]" mode="format-date"/></td>
                </tr>
                <tr>
                  <td>Actual</td>
                  <td><xsl:apply-templates select="activity-date[@type='2'][1]" mode="format-date"/></td>
                  <td><xsl:apply-templates select="activity-date[@type='4'][1]" mode="format-date"/></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Parent and child activities</h3>
          </div>
          <div class="panel-body" style="overflow: scroll">
            <div id="chart_activities"/>
            <p><em>If you have multiple parents for an activity, this chart will not show all relations.</em></p>
            <p><em>Only one level of children is displayed.</em></p>
          </div>
        </div>

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Geography</h3>
          </div>
          <div class="panel-body" style="overflow: scroll">
            <p>Budget percentage per country</p>
            <div id="regions_div"/>
          </div>
        </div>

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">DAC sectors</h3>
          </div>
          <div class="panel-body" style="overflow: scroll">
            <p>Budget percentage per DAC sector code</p>
            <div id="dacchart"/>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="description">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">
          <xsl:choose>
            <xsl:when test="@type='1'">General description</xsl:when>
            <xsl:when test="@type='2'">Objectives</xsl:when>
            <xsl:when test="@type='3'">Target groups</xsl:when>
            <xsl:otherwise>Other</xsl:otherwise>
          </xsl:choose>
        </h3>
      </div>
      <div class="panel-body">
        <xsl:apply-templates select="." mode="narrative"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="*[narrative]" mode="narrative">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:param name="default-lang" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="narrative[lower-case(@xml:lang)=$lang]">
        <span class="languageSet"><xsl:value-of select="narrative[lower-case(@xml:lang)=$lang]"/></span>
      </xsl:when>
      <xsl:when test="narrative[not(@xml:lang)] and $lang=$default-lang">
        <span class="languageDefault"><xsl:value-of select="narrative[not(@xml:lang)]"/></span>
      </xsl:when>
      <xsl:otherwise>
        <span class="languageNA" title="Not available in this language"><xsl:value-of select="(narrative[not(@xml:lang)],name(.))[1]"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@iso-date]" mode="format-date">
    <xsl:param name="lang" tunnel="yes"/>
    <span title="{@iso-date}">
      <xsl:value-of select="format-date(@iso-date, '[D1o] [MNn], [Y]', $lang, (), ())"/>
    </span>
  </xsl:template>


</xsl:stylesheet>
