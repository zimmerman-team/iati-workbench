<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:iati-me="http://iati.me" xmlns:functx="http://www.functx.com" exclude-result-prefixes="iati-me functx">

  <xsl:import href="../lib/functx.xslt"/>

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <link href="lib/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/main.css" rel="stylesheet" type="text/css"/>
        <title>Financial flows</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
          google.charts.load('current', {'packages': ['sankey']});
        </script>

        <xsl:for-each-group select="//transaction[provider-org/@provider-activity-id or receiver-org/@receiver-activity-id]" group-by="transaction-type/@code">
          <script>
            function <xsl:value-of select="concat('drawChart', current-grouping-key(), '()')" /> {
              var data = new google.visualization.DataTable();
              data.addColumn('string', 'From');
              data.addColumn('string', 'To');
              data.addColumn('number', '€');
              data.addColumn({
                type: 'string',
                role: 'tooltip',
                'p': {
                  'html': true
                }
              });
              data.addRows([ <xsl:for-each select="current-group()" >
                <!-- pick the first from: declared activity identifier; the identifier of the current activity -->
                <xsl:variable name="p_id" select="(provider-org/@provider-activity-id,../iati-identifier)[1]" />
                <!-- pick the first from: self-reported name for the activity; name given in transaction; identifier in the transaction -->
                <xsl:variable name="p_ro" select="(//iati-activity[iati-identifier=$p_id][1]/reporting-org/narrative, provider-org/narrative, provider-org/@ref)[1]" />

                <!-- pick the first from: declared activity identifier; the identifier of the current activity -->
                <xsl:variable name="r_id" select="(receiver-org/@receiver-activity-id,../iati-identifier)[1]" />
                <!-- pick the first from: self-reported name for the activity; name given in transaction; identifier in the transaction -->
                <xsl:variable name="r_ro" select="(//iati-activity[iati-identifier=$r_id][1]/reporting-org/narrative, receiver-org/narrative, receiver-org/@ref)[1]" />

                <xsl:choose>

                  <xsl:when test="$p_id != $r_id">
                    [ '<xsl:value-of select="$p_ro"/>&#160;(<xsl:value-of select="substring($p_id, string-length((provider-org/@ref,../reporting-org/@ref)[1])+2)"/>)',
                    '<xsl:value-of select="$r_ro"/>&#160;(<xsl:value-of select="substring($r_id, string-length((receiver-org/@ref,../reporting-org/@ref)[1])+2)"/>)',
                    <xsl:value-of select="value"/>,
                    '<xsl:value-of select="transaction-date/@iso-date"/>: <xsl:value-of select="$p_ro"/> &#x2192; <xsl:value-of select="$r_ro"/><xsl:text> </xsl:text><xsl:value-of select="format-number(value, '€#,##0.00')"/>' ],
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
              ]);

              var options = {
                width: 500,
                height: 500,
                tooltip: {
                  isHtml: true,
                },
                sankey: {
                  node: {
                    interactivity: true,
                  },
                  link: {
                  }
                }

              };

              // Instantiates and draws our chart, passing in some options.
              var chart = new google.visualization.Sankey(document.getElementById('<xsl:value-of select="concat('chart_', current-grouping-key())"/>'));
 chart.draw(data, options);
              }

              google.charts.setOnLoadCallback(<xsl:value-of select="concat('drawChart', current-grouping-key())"/>);
          </script>
        </xsl:for-each-group>

      </head>
      <body>

        <div class="container-fluid" role="main">
          <h1>Transactions between activities</h1>

          <div class="row">

            <xsl:for-each-group select="//transaction[provider-org/@provider-activity-id or receiver-org/@receiver-activity-id]" group-by="transaction-type/@code">
              <div style="col-md-1">
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <xsl:choose>
                      <xsl:when test="current-grouping-key()=1">&#xab; Incoming Funds</xsl:when>
                      <xsl:when test="current-grouping-key()=2">&#xbb; Outgoing Commitments</xsl:when>
                      <xsl:when test="current-grouping-key()=3">&#xbb; Disbursements</xsl:when>
                      <xsl:when test="current-grouping-key()=11">&#xab; Incoming Commitments</xsl:when>
                      <xsl:otherwise>Transactions of type <xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div class="panel-body">
                    <div>
                      <xsl:attribute name="id" select="concat('chart_', current-grouping-key())"/>
                    </div>
                  </div>
                </div>
              </div>
            </xsl:for-each-group>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="text()|@*"></xsl:template>
</xsl:stylesheet>
