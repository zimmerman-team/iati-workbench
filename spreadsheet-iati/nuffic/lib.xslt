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
                xmlns:merge="http://iati.me/merge"
                xmlns:nuffic="http://iati.me/nuffic"
                exclude-result-prefixes=""
                expand-text="yes">

  <xsl:function name="nuffic:idfix">
    <xsl:param name="i"/>
    <xsl:text>{replace($i, "TMT.+TMT", "TMT")
      =>replace("ICP-[A-Za-z]+-([0-9]+)", "ICP-$1")
      =>replace("NL-KVK-41150085-NL-KVK-41150085-", "NL-KVK-41150085-")
      =>replace("OKP-TMT-","OKP-TMT.")
      =>replace("OKP/NFP","OKP")
      =>replace("(OKP-.*[0-9]{5}).*", "$1")
      =>replace("[ ,()]", "-")
      =>replace("-+", "-")
      =>replace("-$", "")
      =>replace("\+", "PLUS")
      =>replace("41150085[0-9]+", "41150085")
      =>replace("TMT-[0-9]{4}.call-[0-9]", "TMT")
      =>substring(1,70)}</xsl:text>
  </xsl:function>

</xsl:stylesheet>
