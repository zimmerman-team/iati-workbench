<?xml version="1.0" encoding="UTF-8"?>
<!--  IATI workbench: produce and use IATI data
  Copyright (C) 2016-2022, drostan.org and data4development.org
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.
  
  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->  

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  expand-text="yes">

  <xsl:import href="bootstrap.xslt"/>
  <xsl:variable name="filename" select="tokenize(document-uri(.), '/')[last()]"/>

  <xsl:template match="/" mode="html-head">
    <title>Activity results</title>
    <link rel="stylesheet" type="text/css" href="/css/jsgantt.css" />
    <script language="javascript" src="/js/jsgantt.js"></script>
  </xsl:template>

  <xsl:template match="/" mode="html-body">
    <div class="container-fluid" role="main">

      <div style="position:relative" class="gantt" id="GanttChartDIV"></div>
      <script type="text/javascript">
        var g = new JSGantt.GanttChart(document.getElementById('GanttChartDIV'), 'quarter');
        g.setShowRes(false);
        g.setShowDur(false);
        g.setShowComp(false);
        g.setShowStartDate(false);
        g.setShowEndDate(false);
        g.setShowTaskInfoRes(false);
        g.setQuarterColWidth(36);
        g.setShowTaskInfoLink(true);

        JSGantt.parseXML("{replace($filename,'^(.*).xml$','$1.gantt.xml')}",g);
        g.Draw();
      </script>
    </div>
  </xsl:template>

</xsl:stylesheet>
